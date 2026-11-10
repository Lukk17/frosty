#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly BUILDER=builder
readonly TOOLS=(git jq namcap pacman-contrib reuse)

usage() {
  cat <<'EOF'
Usage: packaging/ci.sh deps
       packaging/ci.sh test BUILDDIR
       packaging/ci.sh reuse
       packaging/ci.sh package OUTDIR
       packaging/ci.sh aur-check OUTDIR
       packaging/ci.sh --help

The release checks of Frosty, run as root in an Arch Linux container by
.github/workflows/release.yml and the same way by hand.

Commands:
  deps              Updates the container and installs the tools (git, jq,
                    namcap, pacman-contrib, reuse), the makedepends of
                    packaging/aur/PKGBUILD and every depends that is in the
                    Arch repositories.
  test BUILDDIR     Builds vendor/style with BUILD_TESTING=ON in BUILDDIR and
                    runs its tests on the offscreen Qt platform.
  reuse             Runs reuse lint on the project.
  package OUTDIR    Builds the package from PKGBUILD in this folder with
                    makepkg -f --nodeps as the user builder, copies it to
                    OUTDIR without the debug package, and runs namcap on
                    packaging/aur/PKGBUILD and on the package.
  aur-check OUTDIR  Makes frosty-<version>.tar.gz with git archive from HEAD,
                    the way GitHub makes the tag archive, copies
                    packaging/aur to a new folder, fills sha256sums with
                    updpkgsums, builds the package from the archive as the
                    user builder, copies it to OUTDIR without the debug
                    package, and runs namcap on the recipe and the package.

Options:
  -h, --help  Show this help and exit.

Exit status:
  0  done
  1  a step failed
  2  wrong use: an unknown command, a missing argument, or not run as root
EOF
  exit "${1:-0}"
}

say() {
  printf 'ci.sh: %s\n' "$*"
}

error() {
  printf 'ci.sh: error: %s\n' "$*" >&2
}

WORK=''

cleanup() {
  if [[ -n "$WORK" ]]; then
    rm -rf -- "$WORK"
  fi
}

recipe_srcinfo() {
  cd -- packaging/aur &&
    as_builder env BUILDDIR="$WORK" SRCDEST="$WORK" PKGDEST="$WORK" makepkg --printsrcinfo
}

as_builder() {
  runuser -u "$BUILDER" -- "$@"
}

ensure_builder() {
  if ! id "$BUILDER" >/dev/null 2>&1; then
    useradd --create-home "$BUILDER"
  fi
}

run_namcap() {
  local output
  output=$(namcap "$@" 2>&1)
  printf '%s\n' "$output"
  if grep -qE '( E: |^Error: )' <<< "$output"; then
    error "namcap reported errors for $*"
    return 1
  fi
}

keep_packages() {
  local from=$1 to=$2 file
  for file in "$from"/*.pkg.tar.zst; do
    case "${file##*/}" in
      *-debug-*) say "debug package not kept: ${file##*/}" ;;
      *) install -m644 -- "$file" "$to/" ;;
    esac
  done
}

install_deps() {
  local -a wanted=() names=()
  local name srcinfo
  ensure_builder
  pacman -Sy --noconfirm --needed archlinux-keyring
  pacman -Su --noconfirm
  WORK=$(mktemp -d)
  chown "$BUILDER:" "$WORK"
  srcinfo=$(recipe_srcinfo)
  mapfile -t names < <(sed -n -e 's/^\tmakedepends = //p' -e 's/^\tdepends = //p' <<< "$srcinfo")
  if (( ${#names[@]} == 0 )); then
    error 'packaging/aur/PKGBUILD lists no depends'
    return 1
  fi
  for name in "${names[@]}"; do
    if pacman -Si -- "$name" >/dev/null 2>&1; then
      wanted+=("$name")
    else
      say "not in the Arch repositories, skipped: $name"
    fi
  done
  pacman -S --noconfirm --needed "${TOOLS[@]}" "${wanted[@]}"
}

run_tests() {
  local builddir=$1
  cmake -B "$builddir" -S vendor/style \
    -DCMAKE_BUILD_TYPE=None \
    -DBUILD_TESTING=ON \
    -DBUILD_QT6=ON \
    -DBUILD_QT5=OFF \
    -Wno-dev
  cmake --build "$builddir"
  QT_QPA_PLATFORM=offscreen ctest --test-dir "$builddir/kstyle6" --output-on-failure --no-tests=error
}

build_package() {
  local outdir=$1
  ensure_builder
  WORK=$(mktemp -d)
  mkdir -p -- "$outdir" "$WORK/build" "$WORK/src" "$WORK/pkg"
  chown "$BUILDER:" "$WORK" "$WORK/build" "$WORK/src" "$WORK/pkg"
  as_builder env BUILDDIR="$WORK/build" SRCDEST="$WORK/src" PKGDEST="$WORK/pkg" makepkg -f --nodeps
  keep_packages "$WORK/pkg" "$outdir"
  run_namcap packaging/aur/PKGBUILD
  run_namcap "$outdir"/*.pkg.tar.zst
}

check_aur_recipe() {
  local outdir=$1 version recipe
  version=$(packaging/version.sh)
  ensure_builder
  WORK=$(mktemp -d)
  recipe="$WORK/recipe"
  mkdir -p -- "$outdir" "$WORK/build" "$WORK/src" "$WORK/pkg" "$recipe"
  git -c safe.directory="$PWD" archive --format=tar.gz --prefix="frosty-$version/" -o "$WORK/src/frosty-$version.tar.gz" HEAD
  cp -- packaging/aur/PKGBUILD packaging/aur/frosty.install "$recipe/"
  chown -R "$BUILDER:" "$WORK"
  (
    cd -- "$recipe"
    as_builder env BUILDDIR="$WORK/build" SRCDEST="$WORK/src" updpkgsums
    say "sha256sums after updpkgsums: $(sed -n 's/^sha256sums=//p' PKGBUILD)"
    say "sha256 of the archive:       $(sha256sum "$WORK/src/frosty-$version.tar.gz" | cut -d' ' -f1)"
    as_builder env BUILDDIR="$WORK/build" SRCDEST="$WORK/src" PKGDEST="$WORK/pkg" makepkg -f --nodeps
    run_namcap PKGBUILD
  )
  keep_packages "$WORK/pkg" "$outdir"
  run_namcap "$outdir"/*.pkg.tar.zst
}

main() {
  local command=${1:-}
  case "$command" in
    -h | --help) usage 0 ;;
    deps | reuse) (( $# == 1 )) || usage 2 >&2 ;;
    test | package | aur-check) (( $# == 2 )) || { error "$command needs one folder"; usage 2 >&2; } ;;
    '') error 'a command is needed'; usage 2 >&2 ;;
    *) error "unknown command: $command"; usage 2 >&2 ;;
  esac
  if (( EUID != 0 )); then
    error 'run it as root in a container'
    exit 2
  fi

  cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

  case "$command" in
    deps) install_deps ;;
    test) run_tests "$2" ;;
    reuse) reuse lint ;;
    package) build_package "$(realpath -m -- "$2")" ;;
    aur-check) check_aur_recipe "$(realpath -m -- "$2")" ;;
  esac
}

trap cleanup EXIT
main "$@"
