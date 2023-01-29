#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(dirname "$0")/dev-utils.sh"

cd "$BASH_HELPER_DIR/repos"
for I in setup-*.sh; do "./$I"; done

if [ "$(uname)" = "Darwin" ]; then
  brew install -y bash coreutils zlib cmake pkgconfig
elif command -v apt &>/dev/null; then
  sudo apt install -y build-essential cmake binutils-dev \
    libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev \
    libssl-dev
fi
