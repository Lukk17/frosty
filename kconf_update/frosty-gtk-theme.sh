#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly FROSTY_GTK_THEME=Frosty-Dark
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

say() {
  printf 'frosty-gtk-theme: %s\n' "$*"
}

settings_file() {
  printf '%s/gtk-%s.0/settings.ini\n' "$CONFIG_HOME" "$1"
}

current_theme() {
  kreadconfig6 --file "$(settings_file 3)" --group Settings --key gtk-theme-name
}

is_kde_default() {
  case "$1" in
    '' | Breeze | Breeze-Dark) return 0 ;;
    *) return 1 ;;
  esac
}

set_settings_files() {
  local version
  for version in 3 4; do
    kwriteconfig6 --file "$(settings_file "$version")" --group Settings --key gtk-theme-name "$FROSTY_GTK_THEME"
  done
}

set_gsettings() {
  if ! command -v gsettings >/dev/null; then
    say "gsettings is not installed, so only the settings.ini files name $FROSTY_GTK_THEME."
    return 0
  fi
  if [[ "$(gsettings writable org.gnome.desktop.interface gtk-theme 2>/dev/null || true)" != true ]]; then
    say "gsettings has no writable org.gnome.desktop.interface gtk-theme, so only the settings.ini files name $FROSTY_GTK_THEME."
    return 0
  fi
  if ! gsettings set org.gnome.desktop.interface gtk-theme "$FROSTY_GTK_THEME"; then
    say "gsettings could not set org.gnome.desktop.interface gtk-theme to $FROSTY_GTK_THEME."
  fi
}

main() {
  local current
  current=$(current_theme)
  if ! is_kde_default "$current"; then
    say "the GTK theme $current was picked by hand, so it stays."
    return 0
  fi
  set_settings_files
  set_gsettings
  say "the GTK theme is now $FROSTY_GTK_THEME, in place of '${current}'."
}

main "$@"
