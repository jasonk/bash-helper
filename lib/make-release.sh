#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(dirname "$0")/dev-utils.sh"

cd "$PROJECT_DIR"

# Executable Version
EV="$($VERSION_CMD)"

readarray -t PROBLEMS < <(bash-helper check-release)

if (( ${#PROBLEMS[@]} )); then
  echo "Problems detected, cannot release:" 1>&2
  for P in "${PROBLEMS[@]}"; do echo "  - $P" 1>&2; done
  exit 1
fi
rm -rf "dev/$PROJECT"
mkdir -p "dev/$PROJECT"
TARGET="$(realpath -P "dev/$PROJECT")"

rsync --archive --recursive --files-from=<(
  # shellcheck disable=SC2068
  git ls-files ${PACKAGE_SOURCES[@]}
) . "$TARGET/"
cd dev
TGZ="${PROJECT}-${EV}.tgz"
tar cfz "$TGZ" "$PROJECT"

DRY=''
if [ "$1" = "-n" ]; then DRY="echo"; fi
if [ -n "$DRY" ]; then echo "Dry-run, not really releasing"; fi

$DRY git tag -a "$EV" -m "Release $EV"
$DRY git push origin "$EV"
$DRY gh release create "$EV" -n '' -t '' "$TGZ"
