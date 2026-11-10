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
