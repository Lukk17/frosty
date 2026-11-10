# Credits

Frosty is built from the work of the people below. Every piece is a pinned copy of their source, changed only as written in [CHANGES.md](CHANGES.md). The pins were taken on 2026-10-20, the Konsole pin on 2026-10-22.

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

The global theme and its layout in [look-and-feel](look-and-feel), [bin/frosty-setup](bin/frosty-setup), the defaults in [xdg](xdg), the Konsole profile in [konsole](konsole), the [PKGBUILD](PKGBUILD), the AUR recipe, the release scripts and the store credits in [packaging](packaging), the release workflow in [.github/workflows](.github/workflows) and the documentation are by lukk17, under GPL-3.0-or-later. The new style files `kstyle/frostyquickwindowblur.h`, `kstyle/tests/dolphinstatusbar_test.cpp` and `kstyle/tests/windowbackground_test.cpp` in [vendor/style](vendor/style) are by lukk17 under GPL-2.0-or-later, like the Darkly files around them.
