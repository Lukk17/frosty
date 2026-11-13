#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly THEME_NAME=Frosty-Dark

usage() {
  cat <<'EOF'
Usage: packaging/gtk-theme.sh build COLORS SRC OUTDIR
       packaging/gtk-theme.sh check COLORS OUTDIR
       packaging/gtk-theme.sh --help

Builds and checks the GTK 3 and GTK 4 theme Frosty-Dark from the breeze-gtk
source and a KDE color scheme. packaging/aur/PKGBUILD runs build in build()
and check in check().

Commands:
  build COLORS SRC OUTDIR  Copies the color scheme COLORS without the alpha
                           of its four-part colors, renders the breeze-gtk
                           assets with it, compiles gtk3/gtk.scss and
                           gtk4/gtk.scss of the breeze-gtk source folder SRC
                           with sassc and copies the breeze-gtk assets. It
                           writes OUTDIR/Frosty-Dark with gtk-3.0, gtk-4.0 and
                           assets, and OUTDIR/flatpak, the GTK 3 style sheet
                           and the assets for the Flatpak extension, where the
                           style sheet links ./assets instead of ../assets.
  check COLORS OUTDIR      Checks what build wrote: every url() of every style
                           sheet names a file that exists, the Flatpak style
                           sheet has no ../assets link, and
                           theme_bg_color_breeze and
                           theme_selected_bg_color_breeze of every style sheet
                           are the BackgroundNormal of [Colors:Window] and of
                           [Colors:Selection] in COLORS, without alpha.

Options:
  -h, --help  Show this help and exit.

Exit status:
  0  done
  1  a step or a check failed
  2  wrong use: an unknown command, a wrong number of arguments, or python3
     or sassc is missing
EOF
  exit "${1:-0}"
}

say() {
  printf 'gtk-theme.sh: %s\n' "$*"
}

error() {
  printf 'gtk-theme.sh: error: %s\n' "$*" >&2
}

WORK=''

cleanup() {
  if [[ -n "$WORK" ]]; then
    rm -rf -- "$WORK"
  fi
}

require_programs() {
  local program
  for program in "$@"; do
    if ! command -v "$program" >/dev/null; then
      error "$program is missing"
      return 2
    fi
  done
}

opaque_colors() {
  sed -E 's/^([A-Za-z]+=[0-9]+,[0-9]+,[0-9]+),[0-9]+$/\1/' "$1"
}

style_sheets() {
  local outdir=$1
  printf '%s\n' "$outdir/$THEME_NAME/gtk-3.0/gtk.css" "$outdir/$THEME_NAME/gtk-4.0/gtk.css" "$outdir/flatpak/gtk.css"
}

build_theme() {
  local colors=$1 source=$2 outdir=$3 theme flatpak
  require_programs python3 sassc || return 2
  if [[ ! -f "$colors" ]]; then
    error "the color scheme $colors is missing"
    return 1
  fi
  if [[ ! -f "$source/src/render_assets.py" ]]; then
    error "$source is not a breeze-gtk source folder: src/render_assets.py is missing"
    return 1
  fi
  theme="$outdir/$THEME_NAME"
  flatpak="$outdir/flatpak"
  WORK=$(mktemp -d)
  rm -rf -- "$theme" "$flatpak"
  mkdir -p -- "$WORK/gtk2" "$WORK/scss" "$theme/gtk-3.0" "$theme/gtk-4.0" "$flatpak"
  opaque_colors "$colors" > "$WORK/colors"

  say "rendering the assets with the colors of $colors"
  (
    cd -- "$source/src"
    python3 render_assets.py -c "$WORK/colors" -b "$WORK/colors" -a "$theme/assets" -g "$WORK/gtk2" -G "$WORK/scss"
    say "compiling the GTK 3 and GTK 4 style sheets"
    sassc -I "$WORK/scss" gtk3/gtk.scss "$theme/gtk-3.0/gtk.css"
    sassc -I "$WORK/scss" gtk4/gtk.scss "$theme/gtk-4.0/gtk.css"
  )
  cp -r -- "$source/src/assets/." "$theme/assets/"

  say "making the Flatpak copy in $flatpak"
  sed 's#url("\.\./assets/#url("./assets/#g' "$theme/gtk-3.0/gtk.css" > "$flatpak/gtk.css"
  cp -r -- "$theme/assets" "$flatpak/assets"
  say "built $theme and $flatpak"
}

opaque_background() {
  local colors=$1 set=$2 value
  value=$(awk -F= -v group="[Colors:$set]" '
    /^\[/ { inside = ($0 == group); next }
    inside && $1 == "BackgroundNormal" { print $2; exit }
  ' "$colors")
  if [[ ! "$value" =~ ^([0-9]+),([0-9]+),([0-9]+)(,[0-9]+)?$ ]]; then
    error "$colors has no BackgroundNormal of three or four numbers in [Colors:$set]"
    return 1
  fi
  printf '#%02x%02x%02x\n' "$((10#${BASH_REMATCH[1]}))" "$((10#${BASH_REMATCH[2]}))" "$((10#${BASH_REMATCH[3]}))"
}

check_links() {
  local css=$1 dir link count=0 failed=0
  dir=${css%/*}
  while IFS= read -r link; do
    count=$((count + 1))
    if [[ ! -f "$dir/$link" ]]; then
      error "$css links $link, which is not a file"
      failed=1
    fi
  done < <(grep -o 'url("[^"]*")' "$css" | sed -e 's/^url("//' -e 's/")$//' | sort -u)
  if (( count == 0 )); then
    error "$css has no url() link, so it is not a breeze-gtk style sheet"
    return 1
  fi
  if (( $(grep -o 'url(' "$css" | wc -l) != $(grep -o 'url("' "$css" | wc -l) )); then
    error "$css has a url() without double quotes, which this check does not read"
    failed=1
  fi
  return "$failed"
}

check_color() {
  local css=$1 name=$2 wanted=$3 found
  found=$(sed -n "s/^@define-color $name \\(.*\\);\$/\\1/p" "$css")
  if [[ "${found,,}" != "$wanted" ]]; then
    error "$css defines $name as '${found//$'\n'/ and }', not $wanted"
    return 1
  fi
}

check_theme() {
  local colors=$1 outdir=$2 css window selection failed=0
  local -a sheets=()
  mapfile -t sheets < <(style_sheets "$outdir")
  window=$(opaque_background "$colors" Window) || return 1
  selection=$(opaque_background "$colors" Selection) || return 1
  for css in "${sheets[@]}"; do
    if [[ ! -s "$css" ]]; then
      error "the style sheet $css is missing or empty"
      failed=1
      continue
    fi
    check_links "$css" || failed=1
    check_color "$css" theme_bg_color_breeze "$window" || failed=1
    check_color "$css" theme_selected_bg_color_breeze "$selection" || failed=1
  done
  if grep -q '\.\./assets' "$outdir/flatpak/gtk.css" 2>/dev/null; then
    error "$outdir/flatpak/gtk.css still links ../assets"
    failed=1
  fi
  if (( failed == 0 )); then
    say "every link resolves, the Flatpak copy links ./assets, theme_bg_color_breeze is $window and theme_selected_bg_color_breeze is $selection in ${#sheets[@]} style sheets"
  fi
  return "$failed"
}

main() {
  local command=${1:-}
  case "$command" in
    -h | --help) usage 0 ;;
    build) (( $# == 4 )) || { error 'build needs COLORS, SRC and OUTDIR'; usage 2 >&2; } ;;
    check) (( $# == 3 )) || { error 'check needs COLORS and OUTDIR'; usage 2 >&2; } ;;
    '') error 'a command is needed'; usage 2 >&2 ;;
    *) error "unknown command: $command"; usage 2 >&2 ;;
  esac

  case "$command" in
    build) build_theme "$(realpath -m -- "$2")" "$(realpath -m -- "$3")" "$(realpath -m -- "$4")" ;;
    check) check_theme "$(realpath -m -- "$2")" "$(realpath -m -- "$3")" ;;
  esac
}

trap cleanup EXIT
main "$@"
