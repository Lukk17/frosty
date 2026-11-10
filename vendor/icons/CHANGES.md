# Changes to the icon themes

The folder [frosty](frosty) is the icon theme Frosty. It is made from three icon themes:

1. [L4ki/Infinity-Plasma-Themes](https://github.com/L4ki/Infinity-Plasma-Themes), folder `Infinity-Icons/Infinity-Dark-Icons`, commit `e40490e79decb2f76d8e30c737bf7065f3112715`. License file: [LICENSE.Infinity-Plasma-Themes](LICENSE.Infinity-Plasma-Themes).
2. [EliverLara/candy-icons](https://github.com/EliverLara/candy-icons), commit `8d21022f3b77d6a3b44f9a4a1ed26d6a974c41f6`. License file: [LICENSE.candy-icons](LICENSE.candy-icons).
3. [tully-t/Sours](https://github.com/tully-t/Sours), folder `Sours-Full-Color`, commit `a7027ca599d1cba293d769fb23f3c225dd1edbc0`. License file: [LICENSE.Sours](LICENSE.Sours).

### 0.0.1, 2026-10-22, lukk17

1. Copied Infinity-Dark-Icons without its `apps` folder, so applications keep their own icons, and without `icon-theme.cache`. At this commit the Infinity folder in git has no symbolic links, so there were none to keep.
2. Copied from candy-icons, unchanged, into `apps/scalable`: `utilities-terminal`, `preferences-system` and `utilities-system-monitor`.
3. Copied from candy-icons, unchanged, into `devices/scalable`: `drive-harddisk`, `drive-harddisk-encrypted`, `drive-harddisk-root`, `drive-harddisk-root-symbolic`, `drive-multidisk`, `drive-multipartition`, `drive-optical`, `drive-partition` and `drive-removable-media`, and the candy-icons links `drive-removable-media-usb` and `drive-removable-media-usb-pendrive` (both to `drive-removable-media`) and `media-optical` (to `drive-optical`).
4. Copied from Sours-Full-Color, unchanged, into `devices/scalable`:
   1. Input: `input-keyboard`, `keyboard`, `input-mouse`, `input-tablet`, `input-touchpad`, `input-touchpad-on`, `input-touchpad-off`, `input-gamepad`, `input-gaming`, `input-dialpad`, `blueman-keyboard`, `blueman-mouse`, `blueman-pointing`, `gnome-dev-keyboard`, `gnome-dev-mouse-ball` and `gnome-dev-mouse-optical`.
   2. Phones: `phone` and `smartphone`.
   3. Network: `network-card`, `network-rj45-female` and `network-rj11-female`.
   4. Sound and cameras: `audio-card`, `soundcard`, `audio-headset`, `audio-headphones` and `headphone` (links to `audio-headset`), `audio-speakers`, `microphone`, `audio-input-microphone` (link to `microphone`), `camera-photo`, `camera-video`, `camera-web` and `webcam`.
   5. Computers and screens: `computer`, `computer-laptop`, `monitor`, `video-display`, `video-television`, `tv`, `multimedia-player`, `cpu` and `memory`.
   6. Printers and scanners: `printer`, `printer-network`, `cupsprinter`, `cups`, `gnome-dev-printer` and `scanner`.
5. Sours-Full-Color has no device battery icon (its battery icons are 22 pixel status icons for the system tray), so the Infinity `battery` icon stays. Symbolic (`-symbolic`) device icons stay Infinity's.
6. Removed every icon of the same name as a copied icon from all Infinity folders, so that an Infinity icon of a fixed size does not win over the copied one. 335 files were removed.
7. New folder icon `places/64/folder.svg`: a copy of Infinity's `places/64/folder-documents.svg` (gradient from `#fac136` to `#ff00ff`) with only the small document picture (the path with id `path12`) removed and `sodipodi:docname` set to `folder.svg`. The `folder.svg` of every other Infinity size (`places/16`, `16@2x`, `16@3x`, `22`, `22@2x`, `22@3x`, `24`, `24@2x` and `32`) is replaced by a link to it. `apps/scalable/org.kde.dolphin.svg` and `apps/scalable/system-file-manager.svg` are links to it too. The other place icons, such as `folder-documents` and `folder-downloads`, stay Infinity's.
8. `index.theme`: `Name=Frosty`, `Comment=Frosty`, the `en_GB` copies of both removed, `Inherits=breeze-dark,hicolor`, the `apps/*` folders removed from `Directories`, `ScaledDirectories` and their sections, and the new scalable folders `apps/scalable` and `devices/scalable` added. `FollowsColorScheme=true` is kept.
9. Removed seven application icon names that Infinity keeps outside its `apps` folder, so those applications keep their own icons: `TeamViewer` (status folders), `flameshot` and `org.flameshot.Flameshot` (preferences folders), `keepassxc-locked` and `keepassxc-unlocked` (status folders), `vokoscreenNG` (preferences folders) and `systemsettings` (categories folder). 22 files were removed.
10. Twenty other names from the same check were kept, because Breeze also uses them as system icons (actions, status, categories, preferences or mime types), not as application icons: `applications-internet`, `applications-utilities`, `apport`, `dialog-text-and-font`, `document-open-recent`, `flash`, `folder-open-recent`, `kdeconnect`, `kontact-import-wizard`, `plasma`, `preferences-other`, `preferences-plugin`, `preferences-system-bluetooth`, `security-medium`, `system-reboot-update-symbolic`, `system-run`, `system-search`, `virtualbox-vbox`, `yast-disk` and `zoom`.
11. (2026-11-10) No icon file changed. 12827 Infinity files are byte for byte the same as Breeze icons, 10 of them (`pan-*` and `selection-*` in `actions/symbolic`) also as GNOME Adwaita icons. [REUSE.toml](../../REUSE.toml) now gives the Breeze ones to the Breeze authors under LGPL-3.0-or-later and the 10 GNOME ones to the GNOME Project under LGPL-3.0-only, see [CREDITS.md](../../CREDITS.md).
