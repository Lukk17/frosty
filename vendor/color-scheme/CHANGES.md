# Changes to the Layan color scheme

[Frosty.colors](Frosty.colors) is a changed copy of `color-schemes/Layan.colors` from [vinceliuice/Layan-kde](https://github.com/vinceliuice/Layan-kde) at commit `a0b6a4956022276aee33309b2e07d1d0ef3db30c`.

This file is the notice of changes that the GNU GPL asks for. lukk17 changed the file as listed below. Points 1 to 3 were made from 2026-10-20 to 2026-10-22. Every later point starts with the date of its change.

### 0.0.1, 2026-10-22, lukk17

1. Saved as `Frosty.colors`.
2. `[Colors:Window]` `BackgroundNormal` changed from `49,49,58` to `16,16,20,179`, so the window background is about 30 percent see-through.
3. `[General]` `Name` changed from `Layan` to `Frosty`, and `ColorScheme` from `VimixDarkDoder` to `Frosty`.
4. (2026-11-07) Smoked glass: the view and header colors are darker, so text stays readable over a white window behind the glass. In a render the file names in Dolphin measured a contrast of 6.89 to 1 over pure white, up from 2.4 to 1.
   1. `[Colors:View]` `BackgroundNormal` changed from `49,49,58` to `16,16,20`, and `BackgroundAlternate` from `54,56,62` to `21,23,24`.
   2. `[Colors:Header]` `BackgroundNormal` changed from `49,49,58` to `16,16,20`.
   3. `[Colors:Header][Inactive]` `BackgroundNormal` changed from `49,49,58` to `16,16,20,179`, and `ForegroundNormal` from `234,234,234,150` to `234,234,234`, so the text of inactive title bars and tool bars is solid.
5. (2026-11-07) The other Layan greys follow the smoked tint. `21,23,24` is the `[Colors:View]` `BackgroundAlternate` of point 4, and the see-through groups keep the alpha of their `BackgroundNormal`.
   1. `[Colors:Header]` `BackgroundAlternate` changed from `54,56,62` to `21,23,24`.
   2. `[Colors:Header][Inactive]` `BackgroundAlternate` changed from `54,56,62` to `21,23,24,179`, and `ForegroundActive` from `255,128,224,150` to `255,128,224`.
   3. `[Colors:Window]` `BackgroundAlternate` changed from `54,56,62` to `21,23,24,179`.
   4. `[WM]` `activeBackground` changed from `54,56,62` to `21,23,24`.
6. (2026-11-10) One glass value for every see-through part, 65 percent covering. The alpha 179 of points 2, 4 and 5 changed to 166, which is 65 percent of 255, in `[Colors:Header][Inactive]` `BackgroundNormal` and `BackgroundAlternate` and in `[Colors:Window]` `BackgroundNormal` and `BackgroundAlternate`. The window background is now about 35 percent see-through.
7. (2026-11-10) The glass changed from 65 to 80 percent covering. The alpha 166 of point 6 changed to 204, which is 80 percent of 255, in `[Colors:Header][Inactive]` `BackgroundAlternate` and `BackgroundNormal` (lines 64 and 65) and in `[Colors:Window]` `BackgroundAlternate` and `BackgroundNormal` (lines 120 and 121). The window background is now about 20 percent see-through.
8. (2026-11-12) Obsidian grey. The near-black `16,16,20` of points 2 and 4 is now `38,38,38`, and the `21,23,24` of point 5 is now `43,43,43`. The alpha 204 of point 7 is unchanged, and no other color changed.
   1. `[Colors:Header]`: `BackgroundAlternate` (line 50) changed from `21,23,24` to `43,43,43`, and `BackgroundNormal` (line 51) from `16,16,20` to `38,38,38`.
   2. `[Colors:Header][Inactive]`: `BackgroundAlternate` (line 64) changed from `21,23,24,204` to `43,43,43,204`, and `BackgroundNormal` (line 65) from `16,16,20,204` to `38,38,38,204`.
   3. `[Colors:View]`: `BackgroundAlternate` (line 106) changed from `21,23,24` to `43,43,43`, and `BackgroundNormal` (line 107) from `16,16,20` to `38,38,38`.
   4. `[Colors:Window]`: `BackgroundAlternate` (line 120) changed from `21,23,24,204` to `43,43,43,204`, and `BackgroundNormal` (line 121) from `16,16,20,204` to `38,38,38,204`.
   5. `[WM]`: `activeBackground` (line 142) changed from `21,23,24` to `43,43,43`.
9. (2026-11-12) Readable status text. The positive, neutral and negative text colors were the light theme values that Layan kept, made for a white background. They are now the Breeze Dark values from `BreezeDark.colors` of breeze 6.8.2. Measured with the WCAG 2 contrast formula on the base `38,38,38`: positive 5.27 to 1 (was 2.35), neutral 5.34 to 1 (was 4.28) and negative 3.55 to 1 (was 2.33). The Breeze Dark negative color is below 4.5 to 1 in Breeze Dark too, 3.71 to 1 on its own window color `32,35,38`.
   1. `[Colors:Button]`, `[Colors:Complementary]`, `[Colors:Header]`, `[Colors:Header][Inactive]`, `[Colors:Tooltip]`, `[Colors:View]` and `[Colors:Window]`: `ForegroundNegative` changed from `191,3,3` to `218,68,83`, `ForegroundNeutral` from `176,128,0` to `246,116,0`, and `ForegroundPositive` from `0,110,40` to `39,174,96`, on lines 29, 30, 32, 43, 44, 46, 57, 58, 60, 71, 72, 74, 99, 100, 102, 113, 114, 116, 127, 128 and 130. Breeze Dark has the same three values in each of these groups.
   2. `[Colors:Selection]`: `ForegroundNegative` (line 85) changed from `156,14,14` to `176,55,69`, the Breeze Dark value of that group. `ForegroundNeutral` `255,221,0` and `ForegroundPositive` `128,255,128` of that group are unchanged.
10. (2026-11-12) Neutral grey buttons, tooltips and complementary areas. Layan gave these groups a blue-grey. Each is now a neutral grey of the same lightness, and no other color changed.
   1. `[Colors:Button]`: `BackgroundAlternate` (line 22) changed from `49,51,56` to `51,51,51`, and `BackgroundNormal` (line 23) from `68,69,75` to `69,69,69`.
   2. `[Colors:Complementary]`: `BackgroundAlternate` (line 36) changed from `54,57,62` to `57,57,57`, and `BackgroundNormal` (line 37) from `33,35,41` to `35,35,35`.
   3. `[Colors:Tooltip]`: `BackgroundAlternate` (line 92) changed from `54,57,62` to `57,57,57`, and `BackgroundNormal` (line 93) from `33,35,41` to `35,35,35`.
11. (2026-11-12) Unfocused windows and the error text on a selected row.
   1. `[ColorEffects:Inactive]`: `Enable` (line 17) changed from `true` to `false`, as in `BreezeDark.colors` of breeze 6.8.2, so the colors of an unfocused window no longer get the inactive effect. The other keys of the group were already the Breeze Dark values and are unchanged. The inactive title bar colors in `[Colors:Header][Inactive]` are unchanged.
   2. `[Colors:Selection]`: `ForegroundNegative` (line 85) changed from `176,55,69` to `255,179,164`. Measured with the WCAG 2 contrast formula on the selection color `86,87,245`: 3.00 to 1, up from 1.17 to 1. This is no longer the Breeze Dark value of point 9.
