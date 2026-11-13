#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
readonly ROOT
. "$ROOT/tests/lib.sh"

SUITE=$(mktemp -d)
readonly SUITE
trap 'rm -rf -- "$SUITE"' EXIT
readonly FAKES="$SUITE/bin"

make_fakes() {
  mkdir -p -- "$FAKES"
  write_program "$FAKES/qdbus6" "$(cat <<'EOF'
printf 'qdbus6 %s\n' "$*" >> "$FAKE_STATE/log"
case "${1:-}|${2:-}|${3:-}" in
  'org.kde.plasmashell|/PlasmaShell|') ;;
  'org.kde.GtkConfig|/GtkConfig|org.kde.GtkConfig.gtkTheme')
    [[ ! -e "$FAKE_STATE/gtk-down" ]] || exit 1
    cat -- "$FAKE_STATE/gtk"
    ;;
  'org.kde.GtkConfig|/GtkConfig|org.kde.GtkConfig.setGtkTheme')
    [[ ! -e "$FAKE_STATE/gtk-down" ]] || exit 1
    [[ -e "$FAKE_STATE/gtk-stuck" ]] || printf '%s\n' "$4" > "$FAKE_STATE/gtk"
    ;;
  *) exit 1 ;;
esac
EOF
)"
  write_program "$FAKES/kreadconfig6" "$(cat <<'EOF'
printf 'kreadconfig6 %s\n' "$*" >> "$FAKE_STATE/log"
printf '%s\n' org.kde.breezedark.desktop
EOF
)"
  write_program "$FAKES/konsave" "$(cat <<'EOF'
printf 'konsave %s\n' "$*" >> "$FAKE_STATE/log"
profile="$HOME/.config/konsave/profiles/$2/configs"
case "$1" in
  -s)
    mkdir -p -- "$profile"
    printf 'layout of %s\n' "$2" > "$profile/plasma-org.kde.plasma.desktop-appletsrc"
    ;;
  -e) printf 'PK fake archive\n' > "$4/$2.knsv" ;;
  -a) cp -- "$profile/plasma-org.kde.plasma.desktop-appletsrc" "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" ;;
esac
EOF
)"
  write_program "$FAKES/plasma-apply-lookandfeel" "$(cat <<'EOF'
printf 'plasma-apply-lookandfeel %s\n' "$*" >> "$FAKE_STATE/log"
EOF
)"
  write_program "$FAKES/systemctl" "$(cat <<'EOF'
printf 'systemctl %s\n' "$*" >> "$FAKE_STATE/log"
EOF
)"
}

new_case() {
  CASE=$(mktemp -d "$SUITE/case.XXXXXX")
  export HOME="$CASE/home" FAKE_STATE="$CASE/state" PATH="$FAKES:$PATH"
  unset XDG_STATE_HOME
  mkdir -p -- "$HOME/.config" "$FAKE_STATE"
  printf '%s\n' "$1" > "$FAKE_STATE/gtk"
  : > "$FAKE_STATE/log"
  . "$ROOT/bin/frosty-setup"
  check_restore_script() { :; }
}

run_frosty_setup() {
  local status
  set +e
  (
    set -e
    main "$@"
  ) > "$CASE/out" 2>&1
  status=$?
  set -e
  printf '%s\n' "$status"
}

record() {
  mkdir -p -- "$HOME/.local/state/frosty"
  printf '%s\n' "$@" > "$HOME/.local/state/frosty/last-run"
}

saved_backup() {
  local profile="$HOME/.config/konsave/profiles/$1/configs"
  mkdir -p -- "$profile"
  printf 'layout of %s\n' "$1" > "$profile/plasma-org.kde.plasma.desktop-appletsrc"
}

test_setup_notes_the_gtk_theme_and_sets_frosty_dark() {
  new_case Breeze
  assert_eq "$(run_frosty_setup --look-only)" 0 'exit status'
  assert_file_has "$HOME/.local/state/frosty/last-run" 'previous_gtk_theme=Breeze'
  assert_file_has "$HOME/.local/state/frosty/last-run" 'previous_theme=org.kde.breezedark.desktop'
  assert_eq "$(< "$FAKE_STATE/gtk")" Frosty-Dark 'GTK theme'
  assert_order "$FAKE_STATE/log" 'konsave -s' 'org.kde.GtkConfig.setGtkTheme Frosty-Dark'
  assert_order "$FAKE_STATE/log" 'plasma-apply-lookandfeel --apply com.github.lukk17.frosty' 'org.kde.GtkConfig.setGtkTheme Frosty-Dark'
  assert_file_has "$CASE/out" 'Your current GTK theme is Breeze.'
  assert_file_has "$CASE/out" 'The GTK theme is Frosty-Dark.'
}

test_setup_notes_a_gtk_theme_picked_by_hand() {
  new_case 'Orchis Dark'
  assert_eq "$(run_frosty_setup --look-only)" 0 'exit status'
  assert_file_has "$HOME/.local/state/frosty/last-run" 'previous_gtk_theme=Orchis Dark'
  assert_file_has "$CASE/out" 'Your current GTK theme is Orchis Dark.'
  assert_eq "$(< "$FAKE_STATE/gtk")" Frosty-Dark 'GTK theme'
}

test_setup_notes_breeze_when_the_gtk_theme_is_already_frosty_dark() {
  new_case Frosty-Dark
  assert_eq "$(run_frosty_setup --look-only)" 0 'exit status'
  assert_file_has "$HOME/.local/state/frosty/last-run" 'previous_gtk_theme=Breeze'
  assert_file_lacks "$HOME/.local/state/frosty/last-run" 'previous_gtk_theme=Frosty-Dark'
  assert_file_has "$CASE/out" 'Your current GTK theme is already Frosty-Dark, so frosty-setup notes Breeze'
  assert_eq "$(< "$FAKE_STATE/gtk")" Frosty-Dark 'GTK theme'
}

test_undo_after_setup_from_frosty_dark_sets_breeze() {
  new_case Frosty-Dark
  ask_yes() { return 0; }
  assert_eq "$(run_frosty_setup --look-only)" 0 'setup exit status'
  assert_eq "$(run_frosty_setup --undo)" 0 'undo exit status'
  assert_eq "$(< "$FAKE_STATE/gtk")" Breeze 'GTK theme'
  assert_file_has "$CASE/out" 'Step 3 of 4 done: the GTK theme is Breeze again.'
}

test_setup_notes_an_unset_gtk_theme_as_empty() {
  new_case ''
  assert_eq "$(run_frosty_setup --look-only)" 0 'exit status'
  assert_file_has "$HOME/.local/state/frosty/last-run" 'previous_gtk_theme='
  assert_file_has "$CASE/out" 'Your current GTK theme is not set, so Breeze.'
  assert_eq "$(< "$FAKE_STATE/gtk")" Frosty-Dark 'GTK theme'
}

test_setup_changes_nothing_without_the_gtk_module() {
  new_case Breeze
  touch -- "$FAKE_STATE/gtk-down"
  assert_eq "$(run_frosty_setup --look-only)" 2 'exit status'
  assert_file_has "$CASE/out" 'org.kde.GtkConfig, from the kde-gtk-config package'
  assert_file_lacks "$FAKE_STATE/log" 'konsave'
  assert_file_lacks "$FAKE_STATE/log" 'plasma-apply-lookandfeel'
  [[ ! -e "$HOME/.local/state/frosty/last-run" ]] || fail 'the record was written'
}

test_setup_fails_when_the_gtk_theme_does_not_read_back() {
  new_case Breeze
  touch -- "$FAKE_STATE/gtk-stuck"
  assert_eq "$(run_frosty_setup --look-only)" 1 'exit status'
  assert_file_has "$CASE/out" 'did not set the GTK theme Frosty-Dark'
  assert_file_has "$CASE/out" 'reads back the GTK theme "Breeze"'
  assert_file_has "$HOME/.local/state/frosty/last-run" 'previous_gtk_theme=Breeze'
}

test_undo_sets_the_recorded_gtk_theme_between_konsave_and_restart() {
  new_case Frosty-Dark
  ask_yes() { return 0; }
  saved_backup frosty-backup-1
  record previous_theme=org.kde.breezedark.desktop 'previous_gtk_theme=Orchis Dark' backup=frosty-backup-1
  assert_eq "$(run_frosty_setup --undo)" 0 'exit status'
  assert_eq "$(< "$FAKE_STATE/gtk")" 'Orchis Dark' 'GTK theme'
  assert_order "$FAKE_STATE/log" 'konsave -a frosty-backup-1' 'org.kde.GtkConfig.setGtkTheme Orchis Dark'
  assert_order "$FAKE_STATE/log" 'org.kde.GtkConfig.setGtkTheme Orchis Dark' 'systemctl --user restart plasma-plasmashell'
  assert_file_has "$CASE/out" '3. qdbus6 org.kde.GtkConfig /GtkConfig org.kde.GtkConfig.setGtkTheme Orchis Dark'
  assert_file_has "$CASE/out" 'Step 3 of 4 done: the GTK theme is Orchis Dark again.'
  assert_file_has "$CASE/out" 'Step 4 of 4 done'
}

test_undo_sets_breeze_when_the_record_has_no_gtk_theme() {
  new_case Frosty-Dark
  ask_yes() { return 0; }
  saved_backup frosty-backup-1
  record previous_theme=org.kde.breeze.desktop backup=frosty-backup-1
  assert_eq "$(run_frosty_setup --undo)" 0 'exit status'
  assert_eq "$(< "$FAKE_STATE/gtk")" Breeze 'GTK theme'
  assert_file_has "$CASE/out" 'has no GTK theme, so --undo sets Breeze'
}

test_undo_stops_before_the_restart_when_the_gtk_theme_fails() {
  new_case Frosty-Dark
  ask_yes() { return 0; }
  touch -- "$FAKE_STATE/gtk-stuck"
  saved_backup frosty-backup-1
  record previous_theme=org.kde.breeze.desktop previous_gtk_theme=Breeze backup=frosty-backup-1
  assert_eq "$(run_frosty_setup --undo)" 1 'exit status'
  assert_file_has "$CASE/out" 'step 3 of 4 failed'
  assert_file_lacks "$FAKE_STATE/log" 'systemctl'
}

test_undo_answered_no_changes_nothing() {
  new_case Frosty-Dark
  saved_backup frosty-backup-1
  record previous_theme=org.kde.breeze.desktop previous_gtk_theme=Breeze backup=frosty-backup-1
  assert_eq "$(run_frosty_setup --undo < /dev/null)" 0 'exit status'
  assert_eq "$(< "$FAKE_STATE/gtk")" Frosty-Dark 'GTK theme'
  assert_file_lacks "$FAKE_STATE/log" 'setGtkTheme'
}

make_fakes
run_test test_setup_notes_the_gtk_theme_and_sets_frosty_dark
run_test test_setup_notes_a_gtk_theme_picked_by_hand
run_test test_setup_notes_breeze_when_the_gtk_theme_is_already_frosty_dark
run_test test_undo_after_setup_from_frosty_dark_sets_breeze
run_test test_setup_notes_an_unset_gtk_theme_as_empty
run_test test_setup_changes_nothing_without_the_gtk_module
run_test test_setup_fails_when_the_gtk_theme_does_not_read_back
run_test test_undo_sets_the_recorded_gtk_theme_between_konsave_and_restart
run_test test_undo_sets_breeze_when_the_record_has_no_gtk_theme
run_test test_undo_stops_before_the_restart_when_the_gtk_theme_fails
run_test test_undo_answered_no_changes_nothing
finish_tests frosty_setup_gtk_test.sh
