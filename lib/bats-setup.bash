# shellcheck disable=SC1091
# THIS_DIR="$(realpath -Pe "$(dirname "${BASH_SOURCE[0]}")")"

source "$BASH_HELPER_DIR/repos/bats-support/load.bash"
source "$BASH_HELPER_DIR/repos/bats-assert/load.bash"
source "$BASH_HELPER_DIR/repos/bats-file/load.bash"
source "$BASH_HELPER_DIR/repos/bats-mock/stub.bash"

TEST_DIR="$(realpath -Pe "$(dirname "$BATS_TEST_FILENAME")")"
PATH="$(realpath -Pm "$TEST_DIR/../bin"):$PATH"
DEV_DIR="$(git rev-parse --show-toplevel)/dev"

assert_json() {
  strip-ansi-from-output
  normalize-json-output
  assert_output "$(normalize-json "${1:-$(cat)}")"
}

strip-ansi-from-output() { output="$(strip-ansi <<<"$output")"; }
strip-ansi() { sed 's/\x1b\[[0-9;]*m//g'; }
normalize-json() {
  local OUT;
  if OUT="$(jq -SM . <<<"$1")"; then
    echo "$OUT"
  else
    echo "FAILED TO PARSE JSON: $1"
    exit 1
  fi
}
normalize-json-output() { output="$(normalize-json "$output")"; }

without_stdout() { "$@" 1>/dev/null; }
without_stderr() { "$@" 2>/dev/null; }
