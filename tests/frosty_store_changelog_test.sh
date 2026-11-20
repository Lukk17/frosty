#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
readonly ROOT
. "$ROOT/tests/lib.sh"

SUITE=$(mktemp -d)
readonly SUITE
trap 'rm -rf -- "$SUITE"' EXIT
readonly STORE="$ROOT/packaging/store.sh"
readonly CHANGELOG="$ROOT/packaging/changelog.sh"

store_changelogs() {
  local list
  list=$("$STORE" changelogs) || fail 'packaging/store.sh changelogs failed'
  [[ -n "$list" ]] || fail 'packaging/store.sh changelogs listed no file'
  printf '%s\n' "$list"
}

check_changelogs() {
  local version=$1 file error_text missing=''
  shift
  for file in "$@"; do
    if error_text=$("$CHANGELOG" "$file" "$version" 2>&1 >/dev/null); then
      printf 'checked: %s has a section for %s\n' "$file" "$version"
    else
      printf 'checked: %s has no section for %s: %s\n' "$file" "$version" "$error_text"
      missing+=" $file"
    fi
  done
  [[ -z "$missing" ]] || fail "packaging/store.sh checklist fails at $version, because these changelogs have no section for it:$missing"
}

test_store_lists_only_changelogs_that_exist() {
  local list file
  local -a files
  list=$(store_changelogs)
  mapfile -t files <<< "$list"
  for file in "${files[@]}"; do
    [[ -f "$ROOT/$file" ]] || fail "packaging/store.sh lists $file, which is missing"
  done
}

test_store_changelogs_with_an_argument_exits_with_2() {
  local status=0
  "$STORE" changelogs dist/store > "$SUITE/out" 2>&1 || status=$?
  assert_eq "$status" 2 'exit status'
  assert_file_has "$SUITE/out" 'changelogs takes no folder'
}

test_a_changelog_without_the_version_fails_the_check() {
  local file="$SUITE/CHANGES.md" status=0
  printf '%s\n' '# Changes' '' '### 0.0.1, 2026-10-22, lukk17' '' '1. A change.' > "$file"
  ( check_changelogs 0.0.3 "$file" ) > "$SUITE/out" 2>&1 || status=$?
  assert_eq "$status" 1 'exit status'
  assert_file_has "$SUITE/out" "checked: $file has no section for 0.0.3: changelog.sh: error: $file has no section for 0.0.3"
  assert_file_has "$SUITE/out" "packaging/store.sh checklist fails at 0.0.3, because these changelogs have no section for it: $file"
}

test_every_store_changelog_has_a_section_for_the_current_version() {
  local version list
  local -a files
  version=$("$ROOT/packaging/version.sh") || fail 'packaging/version.sh failed'
  list=$(store_changelogs)
  mapfile -t files <<< "$list"
  cd -- "$ROOT"
  check_changelogs "$version" "${files[@]}"
}

run_test test_store_lists_only_changelogs_that_exist
run_test test_store_changelogs_with_an_argument_exits_with_2
run_test test_a_changelog_without_the_version_fails_the_check
run_test test_every_store_changelog_has_a_section_for_the_current_version
finish_tests frosty_store_changelog_test.sh
