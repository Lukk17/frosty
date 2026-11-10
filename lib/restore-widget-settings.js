var locationNames = { "3": "top", "4": "bottom", "5": "left", "6": "right" };

function child(parent, name) {
    return ConfigFile(parent, name);
}

function readTree(source) {
    var tree = { entries: {}, groups: {} };
    source.keyList.forEach(function (key) {
        tree.entries[key] = source.readEntry(key);
    });
    source.groupList.forEach(function (name) {
        tree.groups[name] = readTree(child(source, name));
    });
    return tree;
}

function countEntries(tree) {
    return Object.keys(tree.groups).reduce(function (total, name) {
        return total + countEntries(tree.groups[name]);
    }, Object.keys(tree.entries).length);
}

function orderedIds(ids, order) {
    var known = order.filter(function (id) {
        return ids.indexOf(id) !== -1;
    });
    var rest = ids.filter(function (id) {
        return known.indexOf(id) === -1;
    }).sort(function (a, b) {
        return Number(a) - Number(b);
    });
    return known.concat(rest);
}

function oldWidgets(file) {
    var result = [];
    var containments = ConfigFile(file, "Containments");
    containments.groupList.forEach(function (id) {
        var containment = child(containments, id);
        var plugin = containment.readEntry("plugin");
        var location = containment.readEntry("location");
        var place;
        var order = [];
        if (plugin === "org.kde.panel") {
            place = "panel " + (locationNames[location] || location);
            order = String(child(containment, "General").readEntry("AppletOrder")).split(";");
        } else if (location === "0" || location === "") {
            place = "desktop";
        } else {
            return;
        }
        var applets = child(containment, "Applets");
        orderedIds(applets.groupList, order).forEach(function (appletId, position) {
            var applet = child(applets, appletId);
            var appletPlugin = applet.readEntry("plugin");
            if (!appletPlugin) {
                return;
            }
            var config = applet.groupList.indexOf("Applets") !== -1
                ? { entries: {}, groups: { "General": readTree(child(applet, "General")) } }
                : readTree(child(applet, "Configuration"));
            result.push({
                plugin: appletPlugin,
                place: place,
                screen: Number(containment.readEntry("lastScreen")),
                position: position,
                config: config
            });
        });
    });
    return result;
}

function listOf(arrayLike) {
    var list = [];
    for (var i = 0; i < arrayLike.length; i++) {
        list.push(arrayLike[i]);
    }
    return list;
}

function newWidgets() {
    var result = [];
    listOf(panels()).forEach(function (panel) {
        listOf(panel.widgets()).sort(function (a, b) {
            return a.index - b.index;
        }).forEach(function (widget, position) {
            result.push({ plugin: widget.type, place: "panel " + panel.location, screen: panel.screen, position: position, widget: widget });
        });
    });
    listOf(desktops()).forEach(function (desktop) {
        listOf(desktop.widgets()).sort(function (a, b) {
            return a.id - b.id;
        }).forEach(function (widget, position) {
            result.push({ plugin: widget.type, place: "desktop", screen: desktop.screen, position: position, widget: widget });
        });
    });
    return result;
}

var placeRanks = ["panel top", "panel bottom", "panel left", "panel right", "desktop"];

function placeRank(place) {
    var rank = placeRanks.indexOf(place);
    return rank === -1 ? placeRanks.length : rank;
}

function byPlugin(widgets) {
    var map = {};
    widgets.forEach(function (widget) {
        (map[widget.plugin] = map[widget.plugin] || []).push(widget);
    });
    Object.keys(map).forEach(function (plugin) {
        map[plugin].sort(function (a, b) {
            return placeRank(a.place) - placeRank(b.place) || a.screen - b.screen || a.position - b.position;
        });
    });
    return map;
}

function writeTree(widget, tree, path) {
    widget.currentConfigGroup = path;
    Object.keys(tree.entries).forEach(function (key) {
        widget.writeConfig(key, tree.entries[key]);
    });
    Object.keys(tree.groups).forEach(function (name) {
        writeTree(widget, tree.groups[name], path.concat([name]));
    });
}

function describe(widget) {
    var where = widget.place === "desktop" ? "the desktop" : "the " + widget.place.replace("panel ", "") + " panel";
    return widget.plugin + " on " + where + " of screen " + widget.screen;
}

var oldByPlugin = byPlugin(oldWidgets(backupFile));
var newByPlugin = byPlugin(newWidgets());
var lines = [];
Object.keys(oldByPlugin).sort().forEach(function (plugin) {
    var news = newByPlugin[plugin] || [];
    oldByPlugin[plugin].forEach(function (old, i) {
        if (i >= news.length) {
            lines.push("not in Frosty: " + describe(old));
            return;
        }
        var settings = countEntries(old.config);
        writeTree(news[i].widget, old.config, []);
        if (settings > 0) {
            lines.push("restored: " + describe(news[i]) + ", " + settings + " settings from the one on " + describe(old).replace(plugin + " on ", ""));
        }
    });
});
print(lines.join("\n"));
