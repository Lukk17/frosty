var installedWidgets = knownWidgetTypes;

function isInstalled(plugin) {
    return installedWidgets.indexOf(plugin) !== -1;
}

function writeGroups(widget, groups) {
    Object.keys(groups).forEach(function (group) {
        widget.currentConfigGroup = group.split("/");
        var entries = groups[group];
        Object.keys(entries).forEach(function (key) {
            widget.writeConfig(key, entries[key]);
        });
    });
}

function addWidgets(panel, widgets) {
    widgets.forEach(function (spec) {
        if (!isInstalled(spec.plugin)) {
            return;
        }
        var widget = panel.addWidget(spec.plugin);
        writeGroups(widget, spec.config || {});
        if (spec.shortcut) {
            widget.globalShortcut = spec.shortcut;
        }
    });
}

var topBar = new Panel;
topBar.location = "top";
topBar.height = 30;
topBar.floating = false;
topBar.alignment = "center";
topBar.lengthMode = "fill";
topBar.opacity = "translucent";
topBar.hiding = "none";

addWidgets(topBar, [
    { plugin: "org.kde.plasma.showdesktop" },
    {
        plugin: "org.kde.plasma.systemmonitor.memory",
        config: {
            "Appearance": { chartFace: "org.kde.ksysguard.piechart", title: "Memory Usage" },
            "SensorColors": { "memory/physical/used": "0,170,255" },
            "Sensors": {
                highPrioritySensorIds: "[\"memory/physical/used\"]",
                lowPrioritySensorIds: "[\"memory/physical/total\"]",
                totalSensors: "[\"memory/physical/usedPercent\"]"
            }
        }
    },
    {
        plugin: "org.kde.plasma.systemmonitor.cpu",
        config: {
            "Appearance": { chartFace: "org.kde.ksysguard.piechart", title: "Total CPU Use" },
            "SensorColors": { "cpu/all/usage": "255,0,0" },
            "Sensors": {
                highPrioritySensorIds: "[\"cpu/all/usage\"]",
                lowPrioritySensorIds: "[\"cpu/all/cpuCount\",\"cpu/all/coreCount\"]",
                totalSensors: "[\"cpu/all/usage\"]"
            }
        }
    },
    {
        plugin: "org.kde.plasma.systemmonitor.cpu",
        config: {
            "Appearance": { chartFace: "org.kde.ksysguard.piechart", showTitle: true, title: "GPU Temp" },
            "SensorColors": { "cpu/all/usage": "85,170,0", "gpu/gpu0/temperature": "85,255,0" },
            "SensorLabels": { "gpu/gpu0/temperature": "GPU Temp" },
            "Sensors": {
                highPrioritySensorIds: "[\"gpu/gpu0/temperature\"]",
                lowPrioritySensorIds: "[]",
                totalSensors: "[\"gpu/gpu0/temperature\"]"
            },
            "org.kde.ksysguard.piechart/General": { rangeAuto: false }
        }
    },
    { plugin: "org.kde.plasma.pager" },
    { plugin: "com.github.itayavra.batterywatch" },
    { plugin: "org.kde.plasma.panelspacer" },
    { plugin: "org.kde.plasma.marginsseparator" },
    {
        plugin: "com.github.N0repi.compactclock",
        config: {
            "Appearance": { segmentOrder: "time,day,date", segmentSeparator: " ", showDate: false, showSeconds: "Always" }
        }
    },
    {
        plugin: "org.kde.plasma.panelspacer",
        config: { "General": { expanding: false, length: 50 } }
    },
    {
        plugin: "com.github.N0repi.compactclock",
        config: { "Appearance": { showTime: false } }
    },
    { plugin: "org.kde.plasma.panelspacer" },
    { plugin: "org.kde.kdeconnect" },
    { plugin: "org.kde.plasma.dockio" },
    {
        plugin: "org.kde.plasma.systemtray",
        config: {
            "General": {
                extraItems: [
                    "org.kde.kscreen", "org.kde.plasma.battery", "org.kde.plasma.devicenotifier",
                    "org.kde.plasma.mediacontroller", "org.kde.plasma.weather", "org.kde.plasma.cameraindicator",
                    "org.kde.plasma.keyboardindicator", "org.kde.plasma.clipboard", "org.kde.plasma.manage-inputmethod",
                    "org.kde.plasma.brightness", "org.kde.kdeconnect", "org.kde.plasma.notifications",
                    "org.kde.plasma.dockio", "org.kde.plasma.bluetooth", "org.kde.plasma.volume",
                    "org.kde.plasma.keyboardlayout", "org.kde.plasma.networkmanagement", "org.kde.merkuro.contact.applet"
                ],
                hiddenItems: [
                    "org.kde.plasma.clipboard", "org.kde.plasma.brightness", "org.kde.kdeconnect",
                    "org.kde.plasma.notifications", "org.kde.plasma.dockio", "org.kde.merkuro.contact.applet"
                ],
                knownItems: [
                    "org.kde.kscreen", "org.kde.plasma.battery", "org.kde.plasma.brightness",
                    "org.kde.plasma.cameraindicator", "org.kde.plasma.clipboard", "org.kde.plasma.devicenotifier",
                    "org.kde.plasma.keyboardlayout", "org.kde.plasma.manage-inputmethod", "org.kde.plasma.mediacontroller",
                    "org.kde.plasma.networkmanagement", "org.kde.plasma.notifications", "org.kde.plasma.volume",
                    "org.kde.kdeconnect", "org.kde.plasma.bluetooth", "org.kde.plasma.keyboardindicator",
                    "org.kde.plasma.weather", "org.kde.merkuro.contact.applet", "org.kde.plasma.dockio"
                ],
                shownItems: [
                    "org.kde.plasma.bluetooth", "org.kde.plasma.volume", "org.kde.plasma.keyboardlayout",
                    "org.kde.plasma.networkmanagement"
                ]
            }
        }
    },
    { plugin: "org.kde.plasma.notifications" },
    { plugin: "KdeControlStation" },
    {
        plugin: "com.github.lukk17.aiusage",
        config: { "General": { refreshSeconds: 300 } }
    }
]);

function dockWidgets(shortcut) {
    return [
        {
            plugin: "dev.xarbit.appgrid",
            shortcut: shortcut
        },
        { plugin: "org.kde.plasma.marginsseparator" },
        {
            plugin: "org.kde.plasma.icontasks",
            config: {
                "General": {
                    launchers: [
                        "applications:systemsettings.desktop", "applications:org.kde.plasma-systemmonitor.desktop",
                        "applications:org.kde.konsole.desktop", "preferred://filemanager", "preferred://browser"
                    ]
                }
            }
        },
        { plugin: "org.kde.plasma.marginsseparator" },
        { plugin: "org.kde.plasma.trash" }
    ];
}

function addDock(screen, hiding, shortcut) {
    var dock = new Panel;
    if (screen > 0) {
        dock.screen = screen;
    }
    dock.location = "bottom";
    dock.height = 50;
    dock.floating = true;
    dock.alignment = "center";
    dock.lengthMode = "fit";
    dock.opacity = "translucent";
    dock.hiding = hiding;
    addWidgets(dock, dockWidgets(shortcut));
}

function lineChart(title, sensorConfig, faceConfig, extraAppearance) {
    var appearance = { chartFace: "org.kde.ksysguard.linechart", showTitle: false, title: title };
    Object.keys(extraAppearance || {}).forEach(function (key) {
        appearance[key] = extraAppearance[key];
    });
    var config = { "Appearance": appearance };
    Object.keys(sensorConfig).forEach(function (group) {
        config[group] = sensorConfig[group];
    });
    if (faceConfig) {
        config["org.kde.ksysguard.linechart/General"] = faceConfig;
    }
    return config;
}

function addDesktopWidgets(desktop, widgets) {
    widgets.forEach(function (spec) {
        if (!isInstalled(spec.plugin)) {
            return;
        }
        var widget = desktop.addWidget(spec.plugin, spec.x, spec.y, spec.width, spec.height);
        writeGroups(widget, spec.config);
    });
}

addDock(0, "none", "Alt+F1");
if (screenCount > 1) {
    addDock(1, "dodgewindows", "");
}

addDesktopWidgets(desktopForScreen(screenCount > 1 ? 1 : 0), [
    {
        plugin: "org.kde.plasma.systemmonitor", x: 1680, y: 0, width: 240, height: 192,
        config: lineChart("Memory Usage", {
            "SensorColors": { "memory/physical/used": "61,174,233", "memory/swap/used": "233,120,61" },
            "SensorLabels": { "memory/physical/used": "Memory Usage", "memory/swap/used": "Swap Usage" },
            "Sensors": {
                highPrioritySensorIds: "[\"memory/physical/used\",\"memory/swap/used\"]",
                lowPrioritySensorIds: "[]"
            }
        }, { historyAmount: 3600 })
    },
    {
        plugin: "org.kde.plasma.systemmonitor", x: 1472, y: 192, width: 208, height: 160,
        config: lineChart("GPU Power", {
            "SensorColors": { "gpu/gpu0/power": "233,168,61" },
            "SensorLabels": { "gpu/gpu0/power": "GPU Power" },
            "Sensors": {
                highPrioritySensorIds: "[\"gpu/gpu0/power\"]",
                totalSensors: "[\"gpu/gpu0/power\"]"
            }
        }, { historyAmount: 3600 })
    },
    {
        plugin: "org.kde.plasma.systemmonitor", x: 1680, y: 192, width: 240, height: 160,
        config: lineChart("GPU Video Memory Used", {
            "SensorColors": { "gpu/all/usedVram": "61,214,233" },
            "SensorLabels": { "gpu/all/usedVram": "GPU Video Memory Used" },
            "Sensors": { highPrioritySensorIds: "[\"gpu/all/usedVram\"]" }
        })
    },
    {
        plugin: "org.kde.plasma.systemmonitor", x: 1504, y: 352, width: 208, height: 160,
        config: lineChart("GPU Usage", {
            "SensorColors": {
                "gpu/gpu0/temperature": "61,233,160", "gpu/all/usage": "61,174,233", "gpu/all/usedVram": "188,61,233"
            },
            "SensorLabels": { "gpu/all/usage": "GPU Usage" },
            "Sensors": { highPrioritySensorIds: "[\"gpu/all/usage\"]" }
        }, { historyAmount: 3600, rangeAutoY: "" })
    },
    {
        plugin: "org.kde.plasma.systemmonitor", x: 1712, y: 352, width: 208, height: 160,
        config: lineChart("GPU Temp", {
            "FaceGrid/Appearance": { chartFace: "org.kde.ksysguard.linechart", showTitle: false },
            "FaceGrid/SensorColors": { "gpu/gpu0/temperature": "61,206,233" },
            "FaceGrid/Sensors": { highPrioritySensorIds: "[\"gpu/gpu0/temperature\"]" },
            "SensorColors": { "gpu/gpu0/temperature": "61,206,233" },
            "SensorLabels": { "gpu/gpu0/temperature": "GPU Temp" },
            "Sensors": {
                highPrioritySensorIds: "[\"gpu/gpu0/temperature\"]",
                totalSensors: "[\"gpu/gpu0/temperature\"]"
            }
        }, { historyAmount: 3600 })
    },
    {
        plugin: "org.kde.plasma.systemmonitor", x: 1712, y: 512, width: 208, height: 160,
        config: lineChart("Total CPU Usage", {
            "SensorColors": { "cpu/all/usage": "61,174,233" },
            "SensorLabels": { "cpu/all/usage": "CPU Total Usage" },
            "Sensors": { highPrioritySensorIds: "[\"cpu/all/usage\"]" }
        }, { historyAmount: 3600 })
    },
    {
        plugin: "org.kde.plasma.systemmonitor", x: 1712, y: 672, width: 208, height: 160,
        config: lineChart("CPU Temp", {
            "SensorColors": { "cpu/all/averageTemperature": "85,61,233" },
            "SensorLabels": { "cpu/all/averageTemperature": "CPU Temp" },
            "Sensors": { highPrioritySensorIds: "[\"cpu/all/averageTemperature\"]" }
        }, { historyAmount: 3600, lineChartStacked: "", rangeAutoY: "", rangeToY: 130 }, { updateRateLimit: 0 })
    }
]);
