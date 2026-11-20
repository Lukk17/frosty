# Credits

Frosty is built from the work of the people below. Every piece is a pinned copy of their source, changed only as written in [CHANGES.md](CHANGES.md). The pins were taken on 2026-10-20, the Konsole pin on 2026-10-22, the widget and breeze-gtk pins on 2026-11-12.

### Pinned sources

| Component in this project | Upstream | Pin | Commit date | License | Copyright |
|---|---|---|---|---|---|
| [vendor/plasma-style](vendor/plasma-style) | [vinceliuice/Layan-kde](https://github.com/vinceliuice/Layan-kde), `plasma/desktoptheme/common` and `plasma/desktoptheme/Layan` | commit `a0b6a4956022276aee33309b2e07d1d0ef3db30c` | 2025-11-27 | GPL-3.0-only | vinceliuice |
| [vendor/color-scheme](vendor/color-scheme) | [vinceliuice/Layan-kde](https://github.com/vinceliuice/Layan-kde), `color-schemes/Layan.colors` | commit `a0b6a4956022276aee33309b2e07d1d0ef3db30c` | 2025-11-27 | GPL-3.0-only | vinceliuice |
| [vendor/style](vendor/style) | [Bali10050/Darkly](https://github.com/Bali10050/Darkly) | tag `v0.5.41`, commit `6fc65177b22983d54aa965ea3617f8c9d658f442` | 2026-10-13 | GPL-2.0-or-later, some files MIT | the authors named in each file header and in [vendor/style/AUTHORS](vendor/style/AUTHORS) |
| [vendor/icons](vendor/icons), system icons | [L4ki/Infinity-Plasma-Themes](https://github.com/L4ki/Infinity-Plasma-Themes), `Infinity-Icons/Infinity-Dark-Icons` | commit `e40490e79decb2f76d8e30c737bf7065f3112715` | 2026-02-23 | GPL-3.0-only, except the Breeze and GNOME icons inside it, see below | L4ki |
| [vendor/icons](vendor/icons), terminal, settings, system monitor and drive icons | [EliverLara/candy-icons](https://github.com/EliverLara/candy-icons) | commit `8d21022f3b77d6a3b44f9a4a1ed26d6a974c41f6` | 2026-10-19 | GPL-3.0-only | EliverLara |
| [vendor/icons](vendor/icons), input and device icons | [tully-t/Sours](https://github.com/tully-t/Sours), `Sours-Full-Color` (the source of [store.kde.org/p/2214536](https://store.kde.org/p/2214536)) | commit `a7027ca599d1cba293d769fb23f3c225dd1edbc0` | 2025-10-27 | GPL-3.0-only | tully-t |
| [vendor/cursors](vendor/cursors) | [EliverLara/Sweet](https://github.com/EliverLara/Sweet), branch `dark-plasma-6`, `kde/cursors/Sweet-cursors`, and its source `kde/cursors/src` and `kde/cursors/build.sh` | commit `fa5229183093c078bebbc1b405d78909ffa18bb4` | 2024-03-27 | GPL-3.0-only | EliverLara |
| [vendor/konsole](vendor/konsole) | [Konsole](https://invent.kde.org/utilities/konsole), `data/color-schemes/DarkPastels.colorscheme` | tag `v26.08.2`, commit `c21993d0b73b6fe5d4c52da50b25370b40389e4e` | 2026-10-06 | GPL-2.0-or-later | the Konsole authors |
| [LICENSES](LICENSES) | [spdx/license-list-data](https://github.com/spdx/license-list-data), `text/` | tag `v3.29.0`, commit `76c9a79bb7d2bf851143b76b3935a4d7cbaa644b` | | license texts | Free Software Foundation, SPDX |

### Bundled widgets

The widgets of the Frosty layout are not copied into this repository. [packaging/aur/PKGBUILD](packaging/aur/PKGBUILD) downloads the GitHub archive of each pinned commit, checks it against its `sha256sums` entry, and installs `metadata.json` and `contents` of each widget unchanged in `/usr/share/plasma/plasmoids/<id>`, with the widget's own `LICENSE` in `/usr/share/licenses/frosty/widgets/<id>`. Each pin is the code the owner ran on 2026-11-12.

| Widget id | Upstream | Pin | Commit date | License | Copyright |
|---|---|---|---|---|---|
| `KdeControlStation` | [Lukk17/kde-control-station](https://github.com/Lukk17/kde-control-station), the owner's fork of [EliverLara/kde-control-station](https://github.com/EliverLara/kde-control-station), branch `fix-plasma-6.8-inhibitions`, folder `package` | commit `15760413b19f24b5e242baadba09d59fa4168088` | 2026-11-11 | GPL-3.0-only, some files GPL-2.0-or-later, LGPL-2.0-or-later or the KDE license choices, see below | Eliver Lara, the KDE authors named in the file headers, lukk17 |
| `com.github.N0repi.compactclock` | [N0repi/kde-compact-clock](https://github.com/N0repi/kde-compact-clock) | commit `457200d59e4e6d1b5376bf74a13c4b2b17a4d17b` | 2026-07-24 | GPL-3.0-or-later, one file LGPL-2.0-or-later | N0repi and the Plasma Digital Clock authors named in its `CREDITS.md` and the file headers |
| `org.kde.plasma.dockio` | [brilliantnz/plasmoid-dockio](https://github.com/brilliantnz/plasmoid-dockio), before named imoize/plasmoid-dockio, folder `package` | tag `v0.2.4`, commit `e3388fc24c05329d95dfbffd8988c00cceb39041` | 2024-09-22 | GPL-3.0-only | Brilliant Nurzaman |
| `com.github.itayavra.batterywatch` | [itayavra/batterywatch](https://github.com/itayavra/batterywatch) | commit `4dc3d4c1786c8bbcf28b32396fa412aabfc5b1b6`, on the upstream `master` branch since pull request 66 | 2026-10-22 | GPL-3.0-only | Itay Avraham and the BatteryWatch contributors |
| `com.github.lukk17.aiusage` | [Lukk17/ai-usage-widget](https://github.com/Lukk17/ai-usage-widget), folder `package` | commit `79b139a77da21d4d5f5a5ab7256b0466cf4f9830` | 2026-11-20 | GPL-3.0-or-later | lukk17 (Łukasz Sarna) |
| `/usr/share/licenses/frosty/LGPL-2.0-or-later.txt` | [spdx/license-list-data](https://github.com/spdx/license-list-data), `text/LGPL-2.0-or-later.txt` | tag `v3.29.0` | | license text | Free Software Foundation, SPDX |

### Notes on the widgets

1. Each widget repository ships the GNU GPL version 3 text in its root `LICENSE`, which allows copying and sharing inside another GPL-3.0 package. KDE Control Station says "GPLv3" in its README and its `metadata.json`, Dockio says `GPL-3.0` in its `metadata.json`, and BatteryWatch has no license in its `metadata.json` but links its `LICENSE` from its README badge. None of the three adds an "or later" notice, so they are GPL-3.0-only. Compact Clock and the AI usage widget say GPL-3.0-or-later in their README and `metadata.json`.
2. The files that KDE Control Station and Compact Clock took from Plasma keep their own SPDX headers: GPL-2.0-or-later, LGPL-2.0-or-later, `GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL` and `LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL`. Frosty passes them on under the GPL-3.0-only and LGPL-3.0-only choices of the last two, so the package license list names GPL-3.0-only, GPL-2.0-or-later, LGPL-3.0-only and LGPL-2.0-or-later for them. The headers stay unchanged.
3. KDE Control Station is the upstream `plasma6` branch at commit `bb473188a19d6cbe89a9c1bb5b08c7ddc609375d` plus one commit by lukk17 of 2026-11-11, `15760413b19f24b5e242baadba09d59fa4168088`. It reads the Plasma 6.5 inhibition names `requestedInhibitions`, `icon`, `prettyName` and `reason` with a fallback to the old names, and uses `Kirigami.Units` in place of the removed `PlasmaCore.Units`, in `package/contents/ui/pages/BatteryPage.qml`, `package/contents/ui/pages/components/battery/MainView.qml` and `package/contents/ui/pages/components/battery/PowerManagementItem.qml`. The same change is offered upstream as [EliverLara/kde-control-station#117](https://github.com/EliverLara/kde-control-station/pull/117), still open on 2026-11-12. Its `metadata.json` says version 2.8.0, like the upstream branch. The KDE Store copy that the owner patched says 2.11.0 and has the same files, except an unused `contents/ui/js/helpers.js` left from an older version.
4. BatteryWatch is installed the way its own `build-plasmoid.sh` packs it: without `contents/screenshots`, `contents/bin/tests` and the `*.test.*` files. Its two helpers in `contents/bin` keep their executable mode.
5. Compact Clock's `CREDITS.md` names the Plasma Digital Clock authors it derives from. The package installs it next to the widget's `LICENSE`.

### GTK theme

The GTK theme `Frosty-Dark` is not copied into this repository either. [packaging/aur/PKGBUILD](packaging/aur/PKGBUILD) downloads the breeze-gtk release archive, checks it against its `sha256sums` entry, and [packaging/gtk-theme.sh](packaging/gtk-theme.sh) builds it in `build()` with the colors of [vendor/color-scheme/Frosty.colors](vendor/color-scheme/Frosty.colors) without their alpha. No breeze-gtk file is changed. The package installs the result in `/usr/share/themes/Frosty-Dark` and, for Flatpak, the GTK 3 part in `/var/lib/flatpak/extension/org.gtk.Gtk3theme.Frosty-Dark/x86_64/3.22`.

| Component | Upstream | Pin | Commit date | License | Copyright |
|---|---|---|---|---|---|
| `/usr/share/themes/Frosty-Dark` and the Flatpak extension | [breeze-gtk](https://invent.kde.org/plasma/breeze-gtk), the release archive `https://download.kde.org/stable/plasma/6.8.2/breeze-gtk-6.8.2.tar.xz`, sha256 `662337b96be3fb67f5ecf903bbd685b894b6b899464822e09311f652a98bc4dd` | tag `v6.8.2`, commit `6a97a744c9bfcd2aa7b47b214af61c432df8858c` | 2026-10-27 | LGPL-2.1-or-later, see below | the KDE development team |
| `/usr/share/licenses/frosty/LGPL-2.1-or-later.txt` | [spdx/license-list-data](https://github.com/spdx/license-list-data), `text/LGPL-2.1-or-later.txt` | tag `v3.29.0` | | license text | Free Software Foundation, SPDX |

### Notes on the GTK theme

1. The files of the release archive are the same as the tag `v6.8.2`, checked with `diff -r`.
2. The breeze-gtk files carry no license statement. Its `LICENSES` folder holds only BSD-3-Clause and CC0-1.0, for its build and CI files. Debian's copyright file for breeze-gtk 6.7.4-1 gives every file ("Files: *") to the KDE development team under LGPL-2.1+, so Frosty uses LGPL-2.1-or-later. The Arch Linux package `breeze-gtk` says LGPL-2.0-or-later instead. LGPL-2.1-or-later allows the theme to be shipped next to the GPL parts of Frosty.

### Notes on the sources

1. Layan-kde says "GNU GPL v3" in its README and ships the plain GPL version 3 text without an "or later" notice, so its files are GPL-3.0-only. Infinity-Plasma-Themes, candy-icons, Sours and Sweet ship the same plain text with no "or later" notice either.
2. Darkly's source files carry their own headers: most say GPL version 2 "or (at your option) any later version", the files listed in [REUSE.toml](REUSE.toml) under MIT carry the MIT permission notice. Both headers are kept unchanged.
3. The Sweet cursors are compiled X cursor files. Their editable source, `kde/cursors/src` and `kde/cursors/build.sh` of the same upstream commit, is copied unchanged into [vendor/cursors/source](vendor/cursors/source), so the source travels with every copy of Frosty.
4. Sours is by tully-t, not by L4ki. Its `Sours-Full-Color` folder at the pinned commit matches the copy from the KDE Store except five extra application icons that Frosty does not use.
5. Konsole ships the GNU GPL version 2 text in `COPYING` and gives no separate license for its color schemes. Frosty Green is therefore treated as GPL-2.0-or-later, like the rest of Konsole.

### Older sources inside the copies

The pinned sources above are themselves built on older work. Their authors and licenses travel with the copies:

| Inside | Older source | License | Copyright | How it was checked |
|---|---|---|---|---|
| Darkly, in [vendor/style](vendor/style) | [Lightly](https://github.com/Luwx/Lightly) by Luwx, which Darkly forked | GPL-2.0-or-later (GPL version 2 text in its `COPYING`, "or later" in the file headers) | Luwx and the Lightly authors | Darkly's README says it was "Forked from the lightly theme", and Lightly's README says it is "a fork of breeze theme style" |
| Darkly, through Lightly | [Breeze](https://invent.kde.org/plasma/breeze), the KDE application style and window decoration | GPL-2.0-or-later, and MIT for some of the files Darkly kept | Hugo Pereira Da Costa, Andrew Lake and the other Breeze authors, named in the file headers and in [vendor/style/AUTHORS](vendor/style/AUTHORS) | the file headers kept in [vendor/style](vendor/style) |
| Sours-Full-Color, in [vendor/icons](vendor/icons) | [BeautyLine](https://store.kde.org/p/1425426) by sajjad606 | GPL version 3 (tag `gplv3` on its KDE Store page) | sajjad606 | Sours' README says Sours "is a descendant of Beautyline and Candy icons" |
| Sours-Full-Color, in [vendor/icons](vendor/icons) | [candy-icons](https://github.com/EliverLara/candy-icons) by EliverLara | GPL-3.0-only | EliverLara | the same README |
| Infinity-Dark-Icons, in [vendor/icons](vendor/icons) | [Breeze icons](https://invent.kde.org/frameworks/breeze-icons) | LGPL-3.0-or-later, as `COPYING-ICONS` of breeze-icons says, which allows them to be shipped under the GPL version 3 | 2014 Uri Herrera and the other Breeze icon authors, the KDE Visual Design Group | 12827 icon files in [vendor/icons/frosty](vendor/icons/frosty), with 3334 different contents, have the same git blob hash, so the same bytes, as a file in the history of breeze-icons. The release with the most of them is tag `v5.68.0`, commit `c470fad5f8290770febfc14a1231a09dc6b87d5c` of 2020-03-07, with 12411 files. Several still name the Nitrux folder of Uri Herrera in their Inkscape export path. [REUSE.toml](REUSE.toml) gives these files to the Breeze authors under LGPL-3.0-or-later |
| Infinity-Dark-Icons, in [vendor/icons](vendor/icons) | GNOME symbolic icons from [Adwaita](https://gitlab.gnome.org/GNOME/adwaita-icon-theme), first drawn for [gnome-icon-theme-symbolic](https://gitlab.gnome.org/Archive/gnome-icon-theme-symbolic) | "either the GNU LGPL v3 or Creative Commons Attribution-Share Alike 3.0 United States", as `COPYING` of adwaita-icon-theme says, so LGPL-3.0-only or CC BY-SA 3.0 United States. The SPDX license list has no identifier for the United States version, so [REUSE.toml](REUSE.toml) records the LGPL-3.0-only choice, which allows them to be shipped under the GPL version 3 | the GNOME Project | 10 icon files in `actions/symbolic` (`pan-*`, `selection-*`), with 6 different contents, are byte for byte the same as files in `Adwaita/scalable/actions` of adwaita-icon-theme, in every tag from `3.15.90` to `3.28.0` (commit `ef52430db1201dce0cbc6563a3de3e9ba1ed60e4` of 2018-03-14). breeze-icons ships the same 6 contents in `icons-dark/actions/symbolic`, which is how they reached Infinity. They name `gnome-icon-theme-symbolic` in their Inkscape export path, but none is byte for byte the same as a file of the archived gnome-icon-theme-symbolic repository |

### Your own work in this project

The AI usage widget and the Plasma inhibition fix in KDE Control Station are by lukk17, see [Bundled widgets](#bundled-widgets). The global theme and its layout in [look-and-feel](look-and-feel), [bin/frosty-setup](bin/frosty-setup), the one time GTK step in [kconf_update](kconf_update), the Flatpak override in [flatpak](flatpak), the tests in [tests](tests), the defaults in [xdg](xdg), the Konsole profile in [konsole](konsole), the [PKGBUILD](PKGBUILD), the AUR recipe, the release scripts and the store credits in [packaging](packaging), the release workflow in [.github/workflows](.github/workflows) and the documentation are by lukk17, under GPL-3.0-or-later. The new style files `kstyle/frostyquickwindowblur.h`, `kstyle/tests/dolphinstatusbar_test.cpp` and `kstyle/tests/windowbackground_test.cpp` in [vendor/style](vendor/style) are by lukk17 under GPL-2.0-or-later, like the Darkly files around them.
