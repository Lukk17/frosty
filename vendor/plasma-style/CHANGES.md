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
9. (2026-11-07) `colors`, the color scheme of the Plasma Style, has the RGB values of [Frosty.colors](../color-scheme/Frosty.colors) in place of the Layan greys, but every color is solid (no alpha), so it differs from `Frosty.colors` in `[General]` and in the alpha of the `[Colors:Window]` and `[Colors:Header][Inactive]` backgrounds. `[General]` keeps `ColorScheme=VimixDarkDoder` and `Name=Layan`.
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
