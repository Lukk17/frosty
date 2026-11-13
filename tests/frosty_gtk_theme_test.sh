#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
readonly ROOT
. "$ROOT/tests/lib.sh"

readonly KCONF_UPDATE=/usr/lib/kf6/kconf_update
readonly SCRIPT="$ROOT/kconf_update/frosty-gtk-theme.sh"
readonly UPDATE_FILE="$ROOT/kconf_update/frosty.upd"
SUITE=$(mktemp -d)
readonly SUITE
trap 'rm -rf -- "$SUITE"' EXIT

new_case() {
  local tool
  CASE=$(mktemp -d "$SUITE/case.XXXXXX")
  TOOLS="$CASE/bin"
  export HOME="$CASE/home" XDG_CONFIG_HOME="$CASE/home/.config" XDG_DATA_HOME="$CASE/home/.local/share" XDG_DATA_DIRS="$CASE/data" FAKE_STATE="$CASE/state"
  mkdir -p -- "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_DATA_DIRS" "$FAKE_STATE" "$TOOLS"
  : > "$FAKE_STATE/log"
  for tool in bash kreadconfig6 kwriteconfig6; do
    ln -s -- "$(command -v "$tool")" "$TOOLS/$tool"
  done
}

fake_gsettings() {
  local writable=$1
  write_program "$TOOLS/gsettings" "$(cat <<EOF
printf 'gsettings %s\n' "\$*" >> "\$FAKE_STATE/log"
if [[ "\$1" == writable ]]; then
  printf '%s\n' $writable
fi
EOF
)"
}

settings() {
  local version=$1
  shift
  mkdir -p -- "$XDG_CONFIG_HOME/gtk-$version.0"
  printf '%s\n' "$@" > "$XDG_CONFIG_HOME/gtk-$version.0/settings.ini"
}

theme_in() {
  kreadconfig6 --file "$XDG_CONFIG_HOME/gtk-$1.0/settings.ini" --group Settings --key gtk-theme-name
}

run_script() {
  env PATH="$TOOLS" bash "$SCRIPT" > "$CASE/out" 2>&1
}

run_kconf_update() {
  env PATH="$TOOLS" "$KCONF_UPDATE" "$UPDATE_FILE" > "$CASE/$1" 2>&1 || fail "kconf_update failed: $(< "$CASE/$1")"
}

assert_frosty_dark_everywhere() {
  assert_eq "$(theme_in 3)" Frosty-Dark 'GTK 3 theme'
  assert_eq "$(theme_in 4)" Frosty-Dark 'GTK 4 theme'
  assert_file_has "$FAKE_STATE/log" 'gsettings set org.gnome.desktop.interface gtk-theme Frosty-Dark'
}

test_missing_settings_files_get_frosty_dark() {
  new_case
  fake_gsettings true
  run_script
  assert_frosty_dark_everywhere
}

test_empty_name_gets_frosty_dark() {
  new_case
  fake_gsettings true
  settings 3 '[Settings]' 'gtk-theme-name='
  run_script
  assert_frosty_dark_everywhere
}

test_breeze_gets_frosty_dark_and_other_keys_stay() {
  new_case
  fake_gsettings true
  settings 3 '[Settings]' 'gtk-application-prefer-dark-theme=true' 'gtk-font-name=Noto Sans,  10' 'gtk-theme-name=Breeze'
  settings 4 '[Settings]' 'gtk-theme-name=Breeze' 'gtk-icon-theme-name=frosty'
  run_script
  assert_frosty_dark_everywhere
  assert_file_has "$XDG_CONFIG_HOME/gtk-3.0/settings.ini" 'gtk-font-name=Noto Sans,  10'
  assert_file_has "$XDG_CONFIG_HOME/gtk-3.0/settings.ini" 'gtk-application-prefer-dark-theme=true'
  assert_file_has "$XDG_CONFIG_HOME/gtk-4.0/settings.ini" 'gtk-icon-theme-name=frosty'
}

test_breeze_dark_gets_frosty_dark() {
  new_case
  fake_gsettings true
  settings 3 '[Settings]' 'gtk-theme-name=Breeze-Dark'
  run_script
  assert_frosty_dark_everywhere
}

test_a_theme_picked_by_hand_stays() {
  new_case
  fake_gsettings true
  settings 3 '[Settings]' 'gtk-theme-name=Adwaita-dark'
  settings 4 '[Settings]' 'gtk-theme-name=Adwaita-dark'
  cp -r -- "$XDG_CONFIG_HOME" "$CASE/before"
  run_script
  diff -r -- "$CASE/before" "$XDG_CONFIG_HOME" > /dev/null || fail 'a settings file changed'
  assert_file_lacks "$FAKE_STATE/log" 'gsettings'
  assert_file_has "$CASE/out" 'Adwaita-dark was picked by hand, so it stays'
}

test_without_gsettings_only_the_files_change() {
  new_case
  settings 3 '[Settings]' 'gtk-theme-name=Breeze'
  run_script
  assert_eq "$(theme_in 3)" Frosty-Dark 'GTK 3 theme'
  assert_eq "$(theme_in 4)" Frosty-Dark 'GTK 4 theme'
  assert_file_has "$CASE/out" 'gsettings is not installed'
}

test_a_key_gsettings_cannot_write_is_left_alone() {
  new_case
  fake_gsettings false
  settings 3 '[Settings]' 'gtk-theme-name=Breeze'
  run_script
  assert_eq "$(theme_in 3)" Frosty-Dark 'GTK 3 theme'
  assert_file_has "$FAKE_STATE/log" 'gsettings writable org.gnome.desktop.interface gtk-theme'
  assert_file_lacks "$FAKE_STATE/log" 'gsettings set'
}

test_kconf_update_runs_the_script_once_per_user() {
  new_case
  fake_gsettings true
  mkdir -p -- "$XDG_DATA_HOME/kconf_update"
  cp -- "$SCRIPT" "$XDG_DATA_HOME/kconf_update/"
  settings 3 '[Settings]' 'gtk-theme-name=Breeze'
  run_kconf_update kconf-1
  assert_frosty_dark_everywhere
  assert_file_has "$XDG_CONFIG_HOME/kconf_updaterc" 'done=frosty_gtk_theme'
  settings 3 '[Settings]' 'gtk-theme-name=Breeze'
  run_kconf_update kconf-2
  assert_eq "$(theme_in 3)" Breeze 'GTK 3 theme after the second run'
}

[[ -x "$KCONF_UPDATE" ]] || { printf 'frosty_gtk_theme_test.sh: %s is missing, install kconfig\n' "$KCONF_UPDATE" >&2; exit 1; }
run_test test_missing_settings_files_get_frosty_dark
run_test test_empty_name_gets_frosty_dark
run_test test_breeze_gets_frosty_dark_and_other_keys_stay
run_test test_breeze_dark_gets_frosty_dark
run_test test_a_theme_picked_by_hand_stays
run_test test_without_gsettings_only_the_files_change
run_test test_a_key_gsettings_cannot_write_is_left_alone
run_test test_kconf_update_runs_the_script_once_per_user
finish_tests frosty_gtk_theme_test.sh
