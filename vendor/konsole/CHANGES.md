# Changes to the Konsole color scheme

`Frosty Green.colorscheme` is a changed copy of `data/color-schemes/DarkPastels.colorscheme` from [Konsole](https://invent.kde.org/utilities/konsole) tag `v26.08.2`, commit `c21993d0b73b6fe5d4c52da50b25370b40389e4e`. Konsole ships the GNU GPL version 2 text in `COPYING` and has no separate notice for its color schemes, so the file is treated as GPL-2.0-or-later like the rest of Konsole.

This file is the notice of changes that the GNU GPL asks for. The owner, lukk17, changed the file as listed below. Points 1 to 5 were made by 2026-10-22. Every later point starts with the date of its change.

### 0.0.1, 2026-10-22, lukk17

1. Made in Konsole's own editor from Dark Pastels by the owner, and copied unchanged from `~/.local/share/konsole/Frosty Green.colorscheme`. The package installs it as `/usr/share/konsole/Frosty Green.colorscheme`.
2. `[Foreground]` and `[ForegroundIntense]` `Color` changed from `220,220,204` to `24,240,24`, `[ForegroundFaint]` `Color` from `220,220,204` to `18,200,18`.
3. `[General]` `Description` changed from `Dark Pastels` to `Frosty Green`.
4. The `Bold=true` lines were removed from `[BackgroundIntense]`, `[Color0Intense]` to `[Color7Intense]` and `[ForegroundIntense]`.
5. `[General]` gained the keys Konsole writes when it saves a scheme: `Anchor=0.5,0.5`, `Blur=false`, `ColorRandomization=false`, `FillStyle=Tile`, `Wallpaper=`, `WallpaperFlipType=NoFlip` and `WallpaperOpacity=1`.
6. (2026-10-26) `[General]` `Blur` changed from `false` to `true`, so Konsole asks KWin to blur its whole window and the see-through tool bar, tab bar and menu bar are frosted. The terminal area stays solid because `Opacity=1`.
