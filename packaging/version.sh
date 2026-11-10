#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() {
  cat <<'EOF'
Usage: packaging/version.sh [--help]

Prints the Frosty version after it checks that every place that states it has
the same value:
  1. pkgver in packaging/aur/PKGBUILD, in PKGBUILD when it sets one, and in
     .SRCINFO when it exists
  2. Version in every metadata.json under look-and-feel and vendor
  3. X-KDE-PluginInfo-Version in every metadata.desktop under vendor
  4. vendor/style/VERSION
  5. the version badge in README.md
  6. a section "### <version>," in CHANGES.md

Run it from anywhere. It reads the project folder that holds this script.

Options:
  -h, --help  Show this help and exit.

Exit status:
  0  every place has the same version, printed on standard output
  1  a place is missing or differs, each one listed on standard error
  2  wrong use: an unknown option, or jq is missing
EOF
  exit "${1:-0}"
}

error() {
  printf 'version.sh: error: %s\n' "$*" >&2
}

pkgbuild_version() {
  sed -n 's/^pkgver=//p' "$1"
}

main() {
  case "${1:-}" in
    '') ;;
    -h | --help) usage 0 ;;
    *) error "unknown option: $1"; usage 2 >&2 ;;
  esac

  if ! command -v jq >/dev/null; then
    error 'jq is needed'
    exit 2
  fi

  local root
  root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
  cd -- "$root"

  local -a places=()
  local -a values=()
  local file value

  places+=('packaging/aur/PKGBUILD pkgver')
  values+=("$(pkgbuild_version packaging/aur/PKGBUILD)")

  value=$(pkgbuild_version PKGBUILD)
  if [[ -n "$value" ]]; then
    places+=('PKGBUILD pkgver')
    values+=("$value")
  fi

  if [[ -f .SRCINFO ]]; then
    places+=('.SRCINFO pkgver')
    values+=("$(sed -n 's/^[[:space:]]*pkgver = //p' .SRCINFO)")
  fi

  while IFS= read -r file; do
    places+=("$file Version")
    values+=("$(jq -r '.KPlugin.Version // empty' "$file")")
  done < <(find look-and-feel vendor -name metadata.json -type f | sort)

  while IFS= read -r file; do
    places+=("$file X-KDE-PluginInfo-Version")
    values+=("$(sed -n 's/^X-KDE-PluginInfo-Version=//p' "$file")")
  done < <(find vendor -name metadata.desktop -type f | sort)

  places+=('vendor/style/VERSION')
  values+=("$(tr -d '[:space:]' < vendor/style/VERSION)")

  places+=('README.md version badge')
  values+=("$(sed -n 's|.*img.shields.io/badge/version-\([^-]*\)-.*|\1|p' README.md | head -n 1)")

  local version=${values[0]}
  local ok=0 i
  if [[ -z "$version" ]]; then
    error 'packaging/aur/PKGBUILD has no pkgver'
    exit 1
  fi
  for i in "${!places[@]}"; do
    if [[ "${values[$i]}" != "$version" ]]; then
      error "${places[$i]} is '${values[$i]}', not '$version'"
      ok=1
    fi
  done

  if ! grep -q "^### ${version//./\\.}, " CHANGES.md; then
    error "CHANGES.md has no section '### $version, '"
    ok=1
  fi

  if (( ok != 0 )); then
    exit 1
  fi
  printf '%s\n' "$version"
}

main "$@"
