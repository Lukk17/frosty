# Changes to the Layan Plasma Style

The folder [frosty](frosty) is a changed copy of the Layan Plasma Style from [vinceliuice/Layan-kde](https://github.com/vinceliuice/Layan-kde) at commit `a0b6a4956022276aee33309b2e07d1d0ef3db30c`. The glass changes are the ones the owner tested earlier in the Layan-glass theme.

This file is the notice of changes that the GNU GPL asks for. lukk17 changed the files named in the points below. Points 1 to 8 were made from 2026-10-20 to 2026-10-22. Every later point starts with the date of its change.

### 0.0.1, 2026-10-22, lukk17

1. Put together the way Layan's `install.sh` does it: `plasma/desktoptheme/common`, then `plasma/desktoptheme/Layan/metadata.json` and `metadata.desktop`, then `color-schemes/Layan.colors` saved as `colors`. The result matched the installed `~/.local/share/plasma/desktoptheme/Layan` file for file before any change.
2. `metadata.json`: `Id` is `frosty`, `Name` is `Frosty`, `Version` is `0.0.1`, and `"KPackageStructure": "Plasma/Theme"` is added, so `kpackagetool6 --type Plasma/Theme --list` lists the style.
3. `metadata.desktop`: `Name=Frosty`, `X-KDE-PluginInfo-Name=frosty`, `X-KDE-PluginInfo-Version=0.0.1`.
4. `translucent/dialogs/background.svg`: the 9 frame pieces (`center`, `top`, `bottom`, `left`, `right` and the 4 corners) changed from opacity 0.8 to 0.35.
5. `translucent/widgets/panel-background.svg`: the 9 frame pieces changed from opacity 0.6 to 0.35.
6. `translucent/widgets/background.svg` and `widgets/background.svg`: the 8 `blurred-` pieces changed from opacity 0.8 to 0.35. The normal pieces keep 0.96.
7. `widgets/tasks.svgz`: the 36 faint fills of the `normal`, `minimized`, `attention` and `progress` frames changed from opacity 0.01 to 0. The `focus` and `hover` frames, and the `north-`, `east-` and `west-` versions of `focus`, `hover`, `attention` and `progress`, changed to opacity 0. The small bars keep their opacity.
8. Added `plasmarc` with `[ContrastEffect] enabled=false contrast=1 intensity=1 saturation=1`, the `[Wallpaper]` keys from `metadata.desktop` and `[AdaptiveTransparency] enabled=true`.
9. (2026-11-07) `colors`, the color scheme of the Plasma Style, has the RGB values of [Frosty.colors](../color-scheme/Frosty.colors) in place of the Layan greys, but every color is solid (no alpha), so it differs from `Frosty.colors` in `[General]` and in the alpha of the `[Colors:Window]` and `[Colors:Header][Inactive]` backgrounds. `[General]` kept `ColorScheme=VimixDarkDoder` and `Name=Layan` until point 16 removed them.
   1. `[Colors:Header]`: `BackgroundNormal` changed from `49,49,58` to `16,16,20`, and `BackgroundAlternate` from `54,56,62` to `21,23,24`.
   2. `[Colors:Header][Inactive]`: `BackgroundNormal` changed from `49,49,58` to `16,16,20`, `BackgroundAlternate` from `54,56,62` to `21,23,24`, `ForegroundActive` from `255,128,224,150` to `255,128,224`, and `ForegroundNormal` from `234,234,234,150` to `234,234,234`.
   3. `[Colors:View]`: `BackgroundNormal` changed from `49,49,58` to `16,16,20`, and `BackgroundAlternate` from `54,56,62` to `21,23,24`.
   4. `[Colors:Window]`: `BackgroundNormal` changed from `49,49,58` to `16,16,20`, and `BackgroundAlternate` from `54,56,62` to `21,23,24`.
   5. `[WM]`: `activeBackground` changed from `54,56,62` to `21,23,24`.
10. (2026-11-10) `colors`: the see-through groups now have the alpha of [Frosty.colors](../color-scheme/Frosty.colors), which reverses the "every color is solid" part of point 9 for these four lines. Lines 49 to 132 are now the same as in `Frosty.colors`.
   1. `[Colors:Header][Inactive]`: `BackgroundAlternate` changed from `21,23,24` to `21,23,24,166`, and `BackgroundNormal` from `16,16,20` to `16,16,20,166`.
   2. `[Colors:Window]`: `BackgroundAlternate` changed from `21,23,24` to `21,23,24,166`, and `BackgroundNormal` from `16,16,20` to `16,16,20,166`.
   3. Measured in a container with libplasma 6.8.2, KSvg 6.31 and Kirigami 6.31: with the Kirigami Plasma platform, `Kirigami.Theme.backgroundColor` of the `Window` color set changed from `16,16,20,255` to `16,16,20,166`, for the active and the inactive color group. A card filled with it, as KDE Control Station does, went from 100 to 65 percent cover. The `Header` color set gave `68,69,75,255`, the same before and after. The SVG frames `widgets/background`, `dialogs/background`, `widgets/panel-background`, `widgets/tooltip` and `widgets/plasmoidheading` drew the same pixels before and after, because KSvg writes the colors into the SVG style sheet with `QColor::name()`, which has no alpha.
11. (2026-11-10) `colors` follows [Frosty.colors](../color-scheme/Frosty.colors) to 80 percent glass, and lines 49 to 132 are still the same as in that file.
   1. `[Colors:Header][Inactive]`: `BackgroundAlternate` (line 64) changed from `21,23,24,166` to `21,23,24,204`, and `BackgroundNormal` (line 65) from `16,16,20,166` to `16,16,20,204`.
   2. `[Colors:Window]`: `BackgroundAlternate` (line 120) changed from `21,23,24,166` to `21,23,24,204`, and `BackgroundNormal` (line 121) from `16,16,20,166` to `16,16,20,204`.
   3. A card filled with `Kirigami.Theme.backgroundColor`, as KDE Control Station does, is now 80 percent cover. This was not measured again: point 10 measured that the Kirigami Plasma platform keeps the alpha of the file.
12. (2026-11-10) `metadata.json` and `metadata.desktop` describe Frosty instead of Layan. lukk17 is added as the second author after Vinceliuice, the original author, in `Authors` and in `X-KDE-PluginInfo-Author`. The description changed from "Layan theme for plasma" to "Frosted glass Plasma Style, based on the Layan Plasma Style by Vinceliuice", the license from `GPL 3.0` to `GPL-3.0-only`, and the website from https://github.com/vinceliuice/Layan-kde to https://github.com/Lukk17/frosty.
13. (2026-11-12) `colors` follows [Frosty.colors](../color-scheme/Frosty.colors) to Obsidian grey, and lines 49 to 132 are still the same as in that file. The alpha 204 of point 11 is unchanged, and no other color changed.
   1. `[Colors:Header]`: `BackgroundAlternate` (line 50) changed from `21,23,24` to `43,43,43`, and `BackgroundNormal` (line 51) from `16,16,20` to `38,38,38`.
   2. `[Colors:Header][Inactive]`: `BackgroundAlternate` (line 64) changed from `21,23,24,204` to `43,43,43,204`, and `BackgroundNormal` (line 65) from `16,16,20,204` to `38,38,38,204`.
   3. `[Colors:View]`: `BackgroundAlternate` (line 106) changed from `21,23,24` to `43,43,43`, and `BackgroundNormal` (line 107) from `16,16,20` to `38,38,38`.
   4. `[Colors:Window]`: `BackgroundAlternate` (line 120) changed from `21,23,24,204` to `43,43,43,204`, and `BackgroundNormal` (line 121) from `16,16,20,204` to `38,38,38,204`.
   5. `[WM]`: `activeBackground` (line 142) changed from `21,23,24` to `43,43,43`.
14. (2026-11-12) The style names no wallpaper. The `[Wallpaper]` group with `defaultWallpaperTheme=Layan`, `defaultFileSuffix=.png`, `defaultWidth=2560` and `defaultHeight=1440` is removed from `plasmarc` (lines 7 to 12) and from `metadata.desktop` (lines 21 to 26). This reverses the `[Wallpaper]` part of point 8. Without the group, libplasma reads `defaultWallpaperTheme` from the `[Theme]` group of the user's `plasmarc` and then from the fallback Plasma Style `default`, which is Breeze and names `Next` (`ThemePrivate::processWallpaperSettings` in libplasma 6.8.2 `src/plasma/private/theme_p.cpp`).
15. (2026-11-12) `colors` follows [Frosty.colors](../color-scheme/Frosty.colors) to the Breeze Dark status text colors, and lines 1 to 132 are the same as in that file. The contrast measured on `38,38,38` is in point 9 of [vendor/color-scheme/CHANGES.md](../color-scheme/CHANGES.md).
   1. `[Colors:Button]`, `[Colors:Complementary]`, `[Colors:Header]`, `[Colors:Header][Inactive]`, `[Colors:Tooltip]`, `[Colors:View]` and `[Colors:Window]`: `ForegroundNegative` changed from `191,3,3` to `218,68,83`, `ForegroundNeutral` from `176,128,0` to `246,116,0`, and `ForegroundPositive` from `0,110,40` to `39,174,96`, on lines 29, 30, 32, 43, 44, 46, 57, 58, 60, 71, 72, 74, 99, 100, 102, 113, 114, 116, 127, 128 and 130.
   2. `[Colors:Selection]`: `ForegroundNegative` (line 85) changed from `156,14,14` to `176,55,69`.
16. (2026-11-12) Layan leftovers that had no effect are removed.
   1. The tray icons `icons/manjaro.svg` (Manjaro Settings Manager), `icons/pamac.svg` (Pamac, the Manjaro package manager) and `icons/apport.svg` (Apport, the Ubuntu crash reporter). They belong to other distributions.
   2. `metadata.desktop`: the line `X-KDE-PluginInfo-Email` (line 6) with the email address of Vinceliuice. Vinceliuice stays the first author in `X-KDE-PluginInfo-Author` and in the `Authors` of `metadata.json`.
   3. `metadata.desktop`: the groups `[ContrastEffect]` (`enabled=false`, `contrast=0.2`, `intensity=0.4`, `saturation=1.7`) and `[AdaptiveTransparency]` (`enabled=true`), lines 15 to 22. libplasma 6.8.2 reads these groups from `plasmarc` and opens `metadata.desktop` for them only when a style has no `plasmarc` (`configForTheme` in `src/plasma/private/theme_p.cpp`). `plasmarc` keeps both groups unchanged.
   4. `colors`: `ColorScheme=VimixDarkDoder` (line 134) and `Name=Layan` (line 135) in `[General]`. This reverses the last sentence of point 9. `[General]` keeps `shadeSortColumn=true`.
17. (2026-11-12) `colors` follows [Frosty.colors](../color-scheme/Frosty.colors) to neutral grey buttons, tooltips and complementary areas, and lines 1 to 132 are still the same as in that file. No other color changed.
   1. `[Colors:Button]`: `BackgroundAlternate` (line 22) changed from `49,51,56` to `51,51,51`, and `BackgroundNormal` (line 23) from `68,69,75` to `69,69,69`.
   2. `[Colors:Complementary]`: `BackgroundAlternate` (line 36) changed from `54,57,62` to `57,57,57`, and `BackgroundNormal` (line 37) from `33,35,41` to `35,35,35`.
   3. `[Colors:Tooltip]`: `BackgroundAlternate` (line 92) changed from `54,57,62` to `57,57,57`, and `BackgroundNormal` (line 93) from `33,35,41` to `35,35,35`.
18. (2026-11-12) `icons/start.svg` is removed. It held Layan's mountain logo as `start-here-kde`, in the sizes 16 and 22 and without a size, and replaced the KDE start icon in the application launcher. The fallback Plasma Style `default` (Breeze) of libplasma 6.8.2 has its own `icons/start.svgz` with the same three elements `16-16-start-here-kde`, `22-22-start-here-kde` and `start-here-kde`.
19. (2026-11-12) Two Layan blue-greys written straight into the SVG files are now neutral greys of the same lightness, the same values point 17 gave to `colors`.
   1. `widgets/notes.svg`: the face of the black note in the `black-notes` group (line 84) changed from `fill:#36393e` (`54,57,62`) to `fill:#393939` (`57,57,57`).
   2. `widgets/plot-background.svg`: the `center` piece (line 3) changed from `fill="#212329"` (`33,35,41`) to `fill="#232323"` (`35,35,35`). Its opacity of 0.4 is unchanged.
20. (2026-11-12) The two tinted greys of `widgets/clock.svg` are now neutral greys of the same relative luminance. The blue marks, the blue numbers, the white hands, the black drop shadow and every opacity are unchanged.
   1. The face (line 13) changed from `fill="#31313f"` (`49,49,63`, a purple-grey) to `fill="#323232"` (`50,50,50`). Its opacity of 0.95 is unchanged.
   2. The shadow ring gradient `radialGradient4671` (lines 4 to 7) changed from `stop-color="#232629"` (`35,38,41`, a blue-grey) to `stop-color="#262626"` (`38,38,38`) in all four stops. Their opacities are unchanged.
21. (2026-11-12) `colors` follows [Frosty.colors](../color-scheme/Frosty.colors) to point 11 of [vendor/color-scheme/CHANGES.md](../color-scheme/CHANGES.md), and lines 1 to 132 are still the same as in that file.
   1. `[ColorEffects:Inactive]`: `Enable` (line 17) changed from `true` to `false`.
   2. `[Colors:Selection]`: `ForegroundNegative` (line 85) changed from `176,55,69` to `255,179,164`.
