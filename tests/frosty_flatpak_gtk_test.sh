#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
readonly ROOT
. "$ROOT/tests/lib.sh"

SUITE=$(mktemp -d)
readonly SUITE
trap 'rm -rf -- "$SUITE"' EXIT
readonly SCRIPT="$ROOT/flatpak/frosty-flatpak-gtk"
readonly TOOLS="$SUITE/tools"
readonly FAKES="$SUITE/fakes"

make_tools() {
  local tool
  mkdir -p -- "$TOOLS" "$FAKES"
  for tool in bash cat chmod grep mkdir mktemp mv rm sed; do
    ln -s -- "$(command -v "$tool")" "$TOOLS/$tool"
  done
  write_program "$FAKES/flatpak" "$(cat <<'EOF'
printf 'flatpak %s\n' "$*" >> "$FAKE_STATE/log"
[[ ! -e "$FAKE_STATE/flatpak-fails" ]] || exit 1
[[ "${1:-}|${2:-}" == 'override|--system' ]] || exit 1
file="$FLATPAK_SYSTEM_DIR/overrides/global"
added=''
for arg in "${@:3}"; do
  added+="${arg#--filesystem=};"
done
mkdir -p -- "${file%/*}"
if [[ -f "$file" ]] && grep -q '^filesystems=' "$file"; then
  sed -i "s|^filesystems=.*|&$added|" "$file"
elif [[ -f "$file" ]] && grep -q '^\[Context\]' "$file"; then
  sed -i "/^\[Context\]/a filesystems=$added" "$file"
else
  printf '[Context]\nfilesystems=%s\n' "$added" >> "$file"
fi
EOF
)"
}

new_case() {
  CASE=$(mktemp -d "$SUITE/case.XXXXXX")
  export FLATPAK_SYSTEM_DIR="$CASE/flatpak" FAKE_STATE="$CASE/state"
  OVERRIDE="$FLATPAK_SYSTEM_DIR/overrides/global"
  mkdir -p -- "$FLATPAK_SYSTEM_DIR/overrides" "$FAKE_STATE"
  : > "$FAKE_STATE/log"
}

override_has() {
  mkdir -p -- "${OVERRIDE%/*}"
  printf '%s\n' "$@" > "$OVERRIDE"
}

run_script() {
  local path=$1 status
  shift
  set +e
  PATH="$path" "$TOOLS/bash" "$SCRIPT" "$@" > "$CASE/out" 2>&1
  status=$?
  set -e
  printf '%s\n' "$status"
}

with_flatpak() {
  run_script "$FAKES:$TOOLS" "$@"
}

without_flatpak() {
  run_script "$TOOLS" "$@"
}

test_add_without_flatpak_prints_one_line_and_changes_nothing() {
  new_case
  assert_eq "$(without_flatpak add)" 0 'exit status'
  assert_eq "$(< "$CASE/out")" 'frosty-flatpak-gtk: flatpak is not installed, so there is no Flatpak override to add.' 'output'
  [[ ! -e "$OVERRIDE" ]] || fail 'the override file was written'
}

test_add_asks_flatpak_for_both_folders_read_only() {
  new_case
  assert_eq "$(with_flatpak add)" 0 'exit status'
  assert_eq "$(< "$FAKE_STATE/log")" 'flatpak override --system --filesystem=xdg-config/gtk-3.0:ro --filesystem=xdg-config/gtk-4.0:ro' 'flatpak call'
  assert_file_has "$OVERRIDE" 'filesystems=xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;'
  assert_file_has "$CASE/out" 'can now read the KDE colors'
}

test_add_asks_only_for_the_folder_that_is_missing() {
  new_case
  override_has '[Context]' 'filesystems=~/Music:ro;xdg-config/gtk-3.0:ro;'
  assert_eq "$(with_flatpak add)" 0 'exit status'
  assert_eq "$(< "$FAKE_STATE/log")" 'flatpak override --system --filesystem=xdg-config/gtk-4.0:ro' 'flatpak call'
  assert_file_lacks "$CASE/out" 'already names'
}

test_add_keeps_a_folder_the_user_granted_or_denied() {
  new_case
  override_has '[Context]' 'filesystems = xdg-config/gtk-3.0;!xdg-config/gtk-4.0;'
  assert_eq "$(with_flatpak add)" 0 'exit status'
  assert_eq "$(< "$FAKE_STATE/log")" '' 'flatpak calls'
  assert_file_has "$OVERRIDE" 'filesystems = xdg-config/gtk-3.0;!xdg-config/gtk-4.0;'
  assert_file_has "$CASE/out" 'already names xdg-config/gtk-4.0'
}

test_add_reads_only_the_context_group() {
  new_case
  override_has '[Other]' 'filesystems=xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;'
  assert_eq "$(with_flatpak add)" 0 'exit status'
  assert_eq "$(< "$FAKE_STATE/log")" 'flatpak override --system --filesystem=xdg-config/gtk-3.0:ro --filesystem=xdg-config/gtk-4.0:ro' 'flatpak call'
}

test_add_twice_asks_flatpak_once_and_is_quiet_the_second_time() {
  new_case
  assert_eq "$(with_flatpak add)" 0 'first exit status'
  assert_eq "$(with_flatpak add)" 0 'second exit status'
  assert_eq "$(grep -c 'flatpak override' "$FAKE_STATE/log")" 1 'flatpak calls'
  assert_eq "$(< "$CASE/out")" '' 'output of the second run'
}

test_add_reports_a_failing_flatpak() {
  new_case
  touch -- "$FAKE_STATE/flatpak-fails"
  assert_eq "$(with_flatpak add)" 1 'exit status'
  assert_file_has "$CASE/out" 'error: flatpak override --system --filesystem=xdg-config/gtk-3.0:ro --filesystem=xdg-config/gtk-4.0:ro failed.'
}

test_remove_takes_out_only_the_frosty_entries() {
  new_case
  override_has '[Context]' 'filesystems=~/Music:ro;xdg-config/gtk-3.0:ro;xdg-config/gtk-3.0/extra:ro;xdg-config/gtk-4.0:ro;' 'sockets=wayland;' '' '[Environment]' 'FOO=bar'
  chmod 640 -- "$OVERRIDE"
  assert_eq "$(without_flatpak remove)" 0 'exit status'
  assert_eq "$(< "$OVERRIDE")" $'[Context]\nfilesystems=~/Music:ro;xdg-config/gtk-3.0/extra:ro;\nsockets=wayland;\n\n[Environment]\nFOO=bar' 'override file'
  assert_eq "$(stat -c %a -- "$OVERRIDE")" 640 'file mode'
  assert_file_has "$CASE/out" 'and kept the rest.'
  [[ -z "$(find "${OVERRIDE%/*}" -name 'global.*')" ]] || fail 'a temporary file was left'
}

test_remove_keeps_grants_that_are_not_read_only() {
  new_case
  override_has '[Context]' 'filesystems=xdg-config/gtk-3.0;!xdg-config/gtk-4.0;xdg-config/gtk-4.0:ro;'
  assert_eq "$(without_flatpak remove)" 0 'exit status'
  assert_eq "$(< "$OVERRIDE")" $'[Context]\nfilesystems=xdg-config/gtk-3.0;!xdg-config/gtk-4.0;' 'override file'
}

test_remove_drops_the_key_and_keeps_other_keys() {
  new_case
  override_has '[Context]' 'filesystems=xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;' 'sockets=wayland;'
  assert_eq "$(without_flatpak remove)" 0 'exit status'
  assert_eq "$(< "$OVERRIDE")" $'[Context]\nsockets=wayland;' 'override file'
}

test_remove_deletes_a_file_with_only_the_frosty_entries() {
  new_case
  override_has '[Context]' 'filesystems=xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;'
  assert_eq "$(without_flatpak remove)" 0 'exit status'
  [[ ! -e "$OVERRIDE" ]] || fail 'the override file is still there'
  assert_file_has "$CASE/out" 'which had no other settings'
}

test_remove_leaves_a_file_without_frosty_entries_alone() {
  new_case
  override_has '[Context]' 'filesystems=~/Music:ro;' '# a comment'
  touch -d '2020-01-01 00:00:00' -- "$OVERRIDE"
  assert_eq "$(without_flatpak remove)" 0 'exit status'
  assert_eq "$(< "$OVERRIDE")" $'[Context]\nfilesystems=~/Music:ro;\n# a comment' 'override file'
  assert_eq "$(stat -c %Y -- "$OVERRIDE")" "$(date -d '2020-01-01 00:00:00' +%s)" 'file time'
  assert_eq "$(< "$CASE/out")" '' 'output'
}

test_remove_without_a_file_does_nothing() {
  new_case
  assert_eq "$(without_flatpak remove)" 0 'exit status'
  [[ ! -e "$OVERRIDE" ]] || fail 'an override file was written'
  assert_eq "$(< "$CASE/out")" '' 'output'
}

test_add_then_remove_gives_back_the_file_of_the_user() {
  new_case
  override_has '[Context]' 'filesystems=~/Music:ro;' '' '[Environment]' 'FOO=bar'
  cp -- "$OVERRIDE" "$CASE/before"
  assert_eq "$(with_flatpak add)" 0 'add exit status'
  assert_file_has "$OVERRIDE" 'xdg-config/gtk-4.0:ro'
  assert_eq "$(with_flatpak remove)" 0 'remove exit status'
  cmp -s -- "$CASE/before" "$OVERRIDE" || fail 'the override file differs from the one before add'
}

test_wrong_use_exits_with_2() {
  new_case
  assert_eq "$(without_flatpak)" 2 'no command'
  assert_eq "$(without_flatpak delete)" 2 'unknown command'
  assert_file_has "$CASE/out" 'unknown command: delete'
}

test_the_hook_runs_add_after_pacman_installs_flatpak() {
  local hook="$ROOT/flatpak/frosty-flatpak-gtk.hook"
  assert_file_has "$hook" 'Operation = Install'
  assert_file_has "$hook" 'Type = Package'
  assert_file_has "$hook" 'Target = flatpak'
  assert_file_has "$hook" 'When = PostTransaction'
  assert_file_has "$hook" 'Exec = /usr/lib/frosty/frosty-flatpak-gtk add'
  assert_file_lacks "$hook" 'Operation = Upgrade'
  assert_file_has "$ROOT/packaging/aur/PKGBUILD" '/flatpak/frosty-flatpak-gtk" '
  assert_file_has "$ROOT/packaging/aur/PKGBUILD" '/usr/lib/frosty/frosty-flatpak-gtk"'
  assert_file_has "$ROOT/packaging/aur/PKGBUILD" '/libalpm/hooks/frosty-flatpak-gtk.hook"'
  assert_file_lacks "$ROOT/packaging/aur/PKGBUILD" 'overrides/global'
}

test_the_install_script_calls_the_same_script() {
  new_case
  . "$ROOT/packaging/aur/frosty.install"
  [[ "$(declare -f frosty_flatpak_gtk)" == *'/usr/lib/frosty/frosty-flatpak-gtk'* ]] || fail 'frosty_flatpak_gtk does not run /usr/lib/frosty/frosty-flatpak-gtk'
  frosty_flatpak_gtk() { printf 'script %s\n' "$1" >> "$FAKE_STATE/log"; }
  post_install > /dev/null
  post_upgrade > /dev/null
  pre_remove > /dev/null
  assert_eq "$(< "$FAKE_STATE/log")" $'script add\nscript add\nscript remove' 'script calls'
}

make_tools
run_test test_add_without_flatpak_prints_one_line_and_changes_nothing
run_test test_add_asks_flatpak_for_both_folders_read_only
run_test test_add_asks_only_for_the_folder_that_is_missing
run_test test_add_keeps_a_folder_the_user_granted_or_denied
run_test test_add_reads_only_the_context_group
run_test test_add_twice_asks_flatpak_once_and_is_quiet_the_second_time
run_test test_add_reports_a_failing_flatpak
run_test test_remove_takes_out_only_the_frosty_entries
run_test test_remove_keeps_grants_that_are_not_read_only
run_test test_remove_drops_the_key_and_keeps_other_keys
run_test test_remove_deletes_a_file_with_only_the_frosty_entries
run_test test_remove_leaves_a_file_without_frosty_entries_alone
run_test test_remove_without_a_file_does_nothing
run_test test_add_then_remove_gives_back_the_file_of_the_user
run_test test_wrong_use_exits_with_2
run_test test_the_hook_runs_add_after_pacman_installs_flatpak
run_test test_the_install_script_calls_the_same_script
finish_tests frosty_flatpak_gtk_test.sh
