#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

REPO="https://github.com/SimonKagstrom/kcov"

DIR="$(basename "$REPO")"
if [ ! -d 'kcov' ]; then git clone "$REPO" kcov; fi
cd kcov
git fetch origin
git reset --hard "origin/$(git rev-parse --abbrev-ref HEAD)"

rm -rf build
mkdir build
cd build

if [ "$(uname)" = "Darwin" ]; then
  eval "$(brew shellenv)"
  cmake -G Xcode \
    -DOPENSSL_ROOT_DIR="${HOMEBREW_PREFIX}/opt/openssl" \
    -DOPENSSL_LIBRARIES="${HOMEBREW_PREFIX}/opt/openssl/lib" \
    ..
  xcodebuild -target kcov -configuration Release
else
  cmake \
    -DCMAKE_C_FLAGS:STRING='-O3' \
    -DCMAKE_BUILD_TYPE='Release' \
    ..
  make -j2
fi
