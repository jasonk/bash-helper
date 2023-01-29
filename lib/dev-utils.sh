# shellcheck shell=bash disable=SC1091
source "$(dirname "$(realpath -P "${BASH_SOURCE[0]}")")/bash-utils.sh"
PROJECT_DIR="$(git rev-parse --show-toplevel)"

REPO_URL="$(git remote get-url origin | sed 's/\.git$//')"
PROJECT="$(basename "$REPO_URL")"
# shellcheck disable=SC2034
VERSION_CMD="$PROJECT --version"
# shellcheck disable=SC2034
PACKAGE_SOURCES=( '*.md' 'LICENSE' 'bin' 'lib' )

if [ -f "$PROJECT_DIR/bash-helper-config.sh" ]; then
  # shellcheck disable=SC1091
  source "$PROJECT_DIR/bash-helper-config.sh"
fi
