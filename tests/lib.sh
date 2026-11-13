#!/usr/bin/env bash
TESTS_RUN=0
TESTS_FAILED=0
CURRENT_TEST=''

fail() {
  printf 'not ok: %s: %s\n' "$CURRENT_TEST" "$*" >&2
  exit 1
}

assert_eq() {
  local actual=$1 expected=$2 what=$3
  [[ "$actual" == "$expected" ]] || fail "$what: expected '$expected', got '$actual'"
}

assert_file_has() {
  local file=$1 text=$2
  [[ -f "$file" ]] || fail "$file is missing"
  grep -qF -- "$text" "$file" || fail "$file does not contain '$text'"
}

assert_file_lacks() {
  local file=$1 text=$2
  if [[ -f "$file" ]] && grep -qF -- "$text" "$file"; then
    fail "$file contains '$text'"
  fi
}

assert_order() {
  local file=$1 first=$2 second=$3 first_line second_line
  first_line=$(grep -nF -- "$first" "$file" | head -n 1 | cut -d: -f1)
  second_line=$(grep -nF -- "$second" "$file" | head -n 1 | cut -d: -f1)
  [[ -n "$first_line" ]] || fail "$file does not contain '$first'"
  [[ -n "$second_line" ]] || fail "$file does not contain '$second'"
  (( first_line < second_line )) || fail "in $file '$first' comes after '$second'"
}

write_program() {
  local path=$1 body=$2
  printf '#!/usr/bin/env bash\nset -euo pipefail\n%s\n' "$body" > "$path"
  chmod 755 "$path"
}

run_test() {
  local name=$1 status=0
  TESTS_RUN=$((TESTS_RUN + 1))
  set +e
  (
    set -euo pipefail
    CURRENT_TEST=$name
    "$name"
  )
  status=$?
  set -e
  if (( status == 0 )); then
    printf 'ok: %s\n' "$name"
  else
    printf 'FAILED: %s\n' "$name"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

finish_tests() {
  printf '%s: %d of %d tests passed\n' "$1" "$((TESTS_RUN - TESTS_FAILED))" "$TESTS_RUN"
  (( TESTS_FAILED == 0 ))
}
