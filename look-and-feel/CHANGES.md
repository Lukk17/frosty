# Changes to the Frosty global theme

[com.github.lukk17.frosty](com.github.lukk17.frosty) is original work by lukk17.

### 0.0.1, 2026-10-22, lukk17

1. The global theme `com.github.lukk17.frosty`, named Frosty, version 0.0.1. Its `contents/defaults` selects the Plasma Style `frosty`, the colors `Frosty`, the application style `Frosty`, the window decoration `com.github.lukk17.frosty` with theme `Frosty`, the icons `frosty` and the cursors `Sweet-cursors`.
2. The package installs a copy of `vendor/color-scheme/Frosty.colors` as `contents/colors`.
3. It has no splash screen. Plasma fills it from the Breeze global theme, so applying Frosty sets the splash screen to `com.github.lukk17.frosty`, which shows the Breeze splash screen.
4. `contents/layouts/org.kde.plasma.desktop-layout.js` builds the owner's desktop when "Desktop and window layout" is ticked, or with `plasma-apply-lookandfeel --resetLayout`:
   1. The top bar and the bottom dock on screen 0.
   2. When a second screen exists, a second dock on screen 1 with the same widgets, order and settings as the first one, and the hiding mode "dodge windows". Only the first dock gets the Alt+F1 shortcut.
   3. The owner's seven System Monitor widgets on the desktop, at the owner's positions, on screen 1 when it exists and on screen 0 otherwise. The GPU usage and GPU memory widgets use the sensors for all GPUs (`gpu/all/usage`, `gpu/all/usedVram`) instead of the first GPU.
5. The layout adds a widget only when its plugin is installed, so a missing third-party widget is left out instead of showing an error box.
6. Left out on purpose: the wallpaper and the splash screen. Settings that hold personal data or usage history were not copied, see the "Left out of the layout" section of [README.md](../README.md).
7. (2026-11-10) The layout no longer holds the owner's own applications. `contents/layouts/org.kde.plasma.desktop-layout.js` lost the `Bitwarden_status_icon_1` entry in the hidden items of the system tray, the dock launchers `applications:com.anthropic.Claude.desktop` and `applications:md.obsidian.Obsidian.desktop`, and the AppGrid icon `org.cachyos.hello`, so AppGrid shows its own icon. The dock keeps System Settings, System Monitor, Konsole, the file manager and the web browser.
8. (2026-11-10) `metadata.json`: `License` changed from `GPL-3.0-or-later` to `GPL-3.0-only`. The files of the global theme are GPL-3.0-or-later, but the installed package and the KDE Store archive also hold `contents/colors`, the GPL-3.0-only Frosty colors, so the package as a whole is GPL-3.0-only.
