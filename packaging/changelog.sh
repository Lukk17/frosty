#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() {
  cat <<'EOF'
Usage: packaging/changelog.sh FILE VERSION
       packaging/changelog.sh --help

Prints the section of one version from a CHANGES.md file: the lines after the
heading "### VERSION, <date>, <author>" up to the next "### " heading, without
leading and trailing empty lines.

Options:
  -h, --help  Show this help and exit.

Exit status:
  0  the section was printed
  1  FILE has no section for VERSION, or the section is empty
  2  wrong use: a missing argument, or FILE cannot be read
EOF
  exit "${1:-0}"
}

error() {
  printf 'changelog.sh: error: %s\n' "$*" >&2
}

main() {
  case "${1:-}" in
    -h | --help) usage 0 ;;
  esac
  if (( $# != 2 )); then
    error 'FILE and VERSION are needed'
    usage 2 >&2
  fi

  local file=$1 version=$2
  if [[ ! -r "$file" ]]; then
    error "cannot read $file"
    exit 2
  fi

  local section
  section=$(awk -v heading="### ${version}, " '
    index($0, "### ") == 1 { if (inside) exit; if (index($0, heading) == 1) { inside = 1; next } }
    inside { print }
  ' "$file" | sed -e '/./,$!d')

  if [[ -z "$section" ]]; then
    error "$file has no section for $version"
    exit 1
  fi
  printf '%s\n' "$section"
}

main "$@"
