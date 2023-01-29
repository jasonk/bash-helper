#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

REPOS=(
  https://github.com/bats-core/bats-core.git
  https://github.com/bats-core/bats-assert.git
  https://github.com/bats-core/bats-support.git
  https://github.com/bats-core/bats-file.git
  https://github.com/jasonkarns/bats-mock.git
)

for URL in "${REPOS[@]}"; do
  REPO="$(basename "$URL" .git)"
  if [ ! -d "$REPO" ]; then git clone "$URL" "./$REPO"; fi
  (
    cd "$REPO"
    git fetch origin
    git reset --hard "origin/$(git rev-parse --abbrev-ref HEAD)"
  )
done
