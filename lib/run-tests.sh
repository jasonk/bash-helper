#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(dirname "$0")/dev-utils.sh"

cd "$PROJECT_DIR"

if [ ! -d 'test' ]; then die "No test directory"; fi
mkdir -p dev

if command -v kcov &>/dev/null; then
  kcov --clean --bash-dont-parse-binary-dir \
    --bash-parser="$(which bash)" \
    --include-path="$(pwd)/lib,$(pwd)/bin,$(pwd)/builders" \
    coverage bats test 2>/dev/null | tee dev/test-results.tap
else
  bats test | tee dev/test-results.tap
fi
