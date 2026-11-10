#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly TICK=$'\x60'
readonly PRODUCTS=(
  "plasma-style|Frosty Plasma Style|vendor/plasma-style/frosty|frosty|vendor/plasma-style/LICENSE|Plasma Themes|104|vendor/plasma-style/CHANGES.md"
  "color-scheme|Frosty color scheme|vendor/color-scheme/Frosty.colors||vendor/color-scheme/LICENSE|Plasma Color Schemes|112|vendor/color-scheme/CHANGES.md"
  "icons|Frosty icons|vendor/icons/frosty|frosty|LICENSE|Full Icon Themes|132|vendor/icons/CHANGES.md"
  "cursors|Sweet cursors|vendor/cursors/Sweet-cursors|Sweet-cursors|vendor/cursors/LICENSE|Cursors|107|vendor/cursors/CHANGES.md"
  "global-theme|Frosty global theme|look-and-feel/com.github.lukk17.frosty|com.github.lukk17.frosty|LICENSE|Global Themes (Plasma 6)|722|look-and-feel/CHANGES.md"
)

usage() {
  cat <<'EOF'
Usage: packaging/store.sh archives OUTDIR
       packaging/store.sh checklist ARCHIVEDIR
       packaging/store.sh --help

Makes the KDE Store archives of Frosty and the checklist for uploading them.

Commands:
  archives OUTDIR      Writes one archive per store product into OUTDIR, named
                       frosty-<product>-<version>.tar.gz, and prints their
                       paths. Each archive carries the GPL text and a short
                       credits file from packaging/store, laid out the way Get
                       New installs that kind of product:
                         plasma-style  frosty/ with metadata.json, LICENSE and
                                       CREDITS.md (plasma-themes.knsrc,
                                       installed by KPackage)
                         color-scheme  Frosty.colors, Frosty.LICENSE and
                                       Frosty.CREDITS.md at the top
                                       (colorschemes.knsrc, Uncompress=archive)
                         icons         frosty/ with index.theme, LICENSE and
                                       CREDITS.md (icons.knsrc, Uncompress=true)
                         cursors       Sweet-cursors/ with index.theme, LICENSE
                                       and CREDITS.md (xcursor.knsrc,
                                       Uncompress=subdir-archive)
                         global-theme  com.github.lukk17.frosty/ with
                                       metadata.json, contents/colors, LICENSE
                                       and CREDITS.md (lookandfeel.knsrc,
                                       installed by KPackage)
                       It then checks the top level and the license and credits
                       files of every archive.
  checklist ARCHIVEDIR Prints a Markdown checklist for the manual upload: for
                       every product the archive in ARCHIVEDIR, the store
                       category, the version and the changelog to paste.

The version comes from packaging/version.sh.

Options:
  -h, --help  Show this help and exit.

Exit status:
  0  done
  1  the version check failed, an archive could not be made, an archive has
     the wrong layout, or an archive is missing for the checklist
  2  wrong use: an unknown command, a missing argument, or a needed program is
     missing
EOF
  exit "${1:-0}"
}

WORK=''

cleanup() {
  if [[ -n "$WORK" ]]; then
    rm -rf -- "$WORK"
  fi
}

say() {
  printf 'store.sh: %s\n' "$*" >&2
}

error() {
  printf 'store.sh: error: %s\n' "$*" >&2
}

archive_name() {
  printf 'frosty-%s-%s.tar.gz\n' "$1" "$2"
}

pack() {
  local stage=$1 out=$2
  tar --sort=name --owner=0 --group=0 --numeric-owner --mtime="@${SOURCE_DATE_EPOCH:-0}" \
    -C "$stage" -cf - . | gzip -9n > "$out"
}

check_archive() {
  local archive=$1 top=$2 product=$3
  local -a expected actual
  local listing license_text entry

  if [[ -n "$top" ]]; then
    expected=("$top")
  else
    expected=(Frosty.CREDITS.md Frosty.LICENSE Frosty.colors)
  fi
  listing=$(tar -tzf "$archive" | sed -e 's|^\./||' -e 's|/$||' | grep -v '^$')
  mapfile -t actual < <(cut -d/ -f1 <<< "$listing" | LC_ALL=C sort -u)
  if [[ "${actual[*]}" != "${expected[*]}" ]]; then
    error "$archive has '${actual[*]}' at the top, not '${expected[*]}'"
    return 1
  fi

  if [[ -n "$top" ]]; then
    case "$product" in
      plasma-style) entry="$top/metadata.json" ;;
      global-theme) entry="$top/contents/colors" ;;
      *) entry="$top/index.theme" ;;
    esac
    for entry in "$top/LICENSE" "$top/CREDITS.md" "$entry"; do
      if ! grep -qx -- "$entry" <<< "$listing"; then
        error "$archive has no $entry"
        return 1
      fi
    done
  fi

  license_text=$(tar -xzOf "$archive" --wildcards '*LICENSE')
  if ! grep -q 'GNU GENERAL PUBLIC LICENSE' <<< "$license_text"; then
    error "$archive has no GPL text"
    return 1
  fi
  return 0
}

make_archives() {
  local root=$1 outdir=$2 version=$3
  local product id title source top license stage out

  WORK=$(mktemp -d)
  mkdir -p -- "$outdir"
  outdir=$(cd -- "$outdir" && pwd)

  for product in "${PRODUCTS[@]}"; do
    IFS='|' read -r id title source top license _ _ _ <<< "$product"
    stage="$WORK/$id"
    mkdir -p -- "$stage"
    if [[ -n "$top" ]]; then
      cp -a -- "$root/$source" "$stage/$top"
      install -m644 -- "$root/$license" "$stage/$top/LICENSE"
      install -m644 -- "$root/packaging/store/$id.md" "$stage/$top/CREDITS.md"
      if [[ "$id" == global-theme ]]; then
        install -m644 -- "$root/vendor/color-scheme/Frosty.colors" "$stage/$top/contents/colors"
      fi
    else
      install -m644 -- "$root/$source" "$stage/${source##*/}"
      install -m644 -- "$root/$license" "$stage/Frosty.LICENSE"
      install -m644 -- "$root/packaging/store/$id.md" "$stage/Frosty.CREDITS.md"
    fi
    find "$stage" -type d -exec chmod 755 {} +
    find "$stage" -type f -exec chmod 644 {} +

    out="$outdir/$(archive_name "$id" "$version")"
    pack "$stage" "$out"
    check_archive "$out" "$top" "$id" || return 1
    say "$title: $out"
    printf '%s\n' "$out"
  done
}

print_checklist() {
  local root=$1 archivedir=$2 version=$3
  local product id title category category_id changes archive notes

  printf '### KDE Store checklist for Frosty %s\n\n' "$version"
  printf 'Upload each archive by hand on https://store.kde.org with the category, version and changelog below. Every archive is attached to the GitHub release v%s too.\n\n' "$version"
  for product in "${PRODUCTS[@]}"; do
    IFS='|' read -r id title _ _ _ category category_id changes <<< "$product"
    archive=$(archive_name "$id" "$version")
    if [[ ! -f "$archivedir/$archive" ]]; then
      error "$archivedir/$archive is missing"
      return 1
    fi
    notes=$("$root/packaging/changelog.sh" "$root/$changes" "$version") || return 1
    printf -- '- [ ] %s\n' "$title"
    printf '  1. Archive: %s%s%s\n' "$TICK" "$archive" "$TICK"
    printf '  2. Category: %s (category id %s)\n' "$category" "$category_id"
    printf '  3. Version: %s%s%s\n' "$TICK" "$version" "$TICK"
    printf '  4. Changelog to paste, from %s%s%s:\n\n' "$TICK" "$changes" "$TICK"
    printf '%s\n' "$TICK$TICK${TICK}markdown" "$notes" "$TICK$TICK$TICK" ''
  done
}

main() {
  local command=${1:-}
  case "$command" in
    -h | --help) usage 0 ;;
    archives | checklist) ;;
    '') error 'a command is needed'; usage 2 >&2 ;;
    *) error "unknown command: $command"; usage 2 >&2 ;;
  esac
  if (( $# != 2 )); then
    error "$command needs one folder"
    usage 2 >&2
  fi

  local tool
  for tool in tar gzip jq; do
    if ! command -v "$tool" >/dev/null; then
      error "$tool is needed"
      exit 2
    fi
  done

  local root version
  root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
  version=$("$root/packaging/version.sh")

  case "$command" in
    archives) make_archives "$root" "$2" "$version" ;;
    checklist) print_checklist "$root" "$2" "$version" ;;
  esac
}

trap cleanup EXIT
main "$@"
