# shellcheck shell=bash

warn() { echo "$@" 1>&2; }
die() { warn "$@"; exit 1; }
is-debug() { [ -n "${BASH_HELPER_DEBUG:-}" ]; }
debug() { if is-debug; then echo "${FUNCNAME[1]}:" "$@" 1>&2; fi; }
dump-payload() { jq -C . 1>&2 <<<"${1:-$(cat -)}"; }

show-help-file() {
  local FILE="${1:-}"
  FILE="$(realpath -P "$FILE").md"
  if [ -f "$FILE" ]; then
    if command -v bat &>/dev/null; then
      bat -p "$FILE"
    else
      cat "$FILE"
    fi
  else
    die "No help found for $1 ($FILE)"
  fi
}

# Remove leading and trailing whitespace from a string
trim() {
  local MSG="$1"
  MSG="${MSG## }"
  MSG="${MSG%% }"
  echo "$MSG"
}

urlencode() {
  local string="${1}"
  local length=${#string}
  local encoded=""
  local pos char

  for (( pos = 0 ; pos < length ; pos++ )); do
     char=${string:$pos:1}
     case "$char" in
        [-_.~a-zA-Z0-9]) encoded+="$char"                       ;;
        *)               encoded+="$(printf '%%%02x' "'$char")" ;;
     esac
  done
  echo "$encoded"
}
