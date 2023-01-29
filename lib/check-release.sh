#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(dirname "$0")/dev-utils.sh"

cd "$PROJECT_DIR"

# Executable Version
EV="$($VERSION_CMD)"

if [ -n "$(git status --porcelain=v1 2>/dev/null)" ]; then
  echo "The repo has uncommitted changes"
fi

if git rev-parse -q --verify "refs/tags/$EV" >/dev/null; then
  echo "Version $EV already tagged, did you forget to increment it?"
fi

if [ -f CHANGELOG.md ]; then
  # Changelog Info
  CI="$(grep -E '^## \[v([0-9\.]+)\]' CHANGELOG.md | head -1 | tr -d '\[\]#')"
  # Changelog Version
  CV="$(awk '{print $1}' <<<"$CI")"
  # Changelog Date
  CD="$(awk '{print $3}' <<<"$CI")"
  # Today's Date
  TD="$(date +%F)"

  if [ "$CV" != "$EV" ]; then
    echo "Executable version is $EV, but Changelog version is $CV"
  fi
  if ! grep -qE "^\[$EV\]: $REPO_URL/releases/tag/$EV$" CHANGELOG.md; then
    echo "No [$EV] tag in CHANGELOG"
  fi
  if [ "$TD" != "$CD" ]; then
    echo "Today is $TD, but latest Changelog entry is $CD"
  fi
  UR="$(grep -E '^\[Unreleased\]:' CHANGELOG.md)"
  if [ -z "$UR" ]; then
    echo "No [Unreleased] URL in CHANGELOG"
  fi
  if [ "$(basename "$UR")" != "${EV}...HEAD" ]; then
    echo "Wrong [Unreleased] URL in CHANGELOG"
  fi
else
  echo "The repo has no CHANGELOG.md file"
fi
