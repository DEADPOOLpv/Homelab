#!/usr/bin/env bash
# Run from the repository root before every commit. Exit code 1 means: fix before committing.
cd "$(dirname "$0")/.." || exit 2
bad=0
check() {
  local label="$1" pattern="$2"
  hits=$(grep -rInE --exclude-dir=.git --exclude=sanitize-check.sh "$pattern" . || true)
  if [ -n "$hits" ]; then echo "FOUND $label:"; echo "$hits"; echo; bad=1; fi
}
check "IPv4 address (use placeholders such as 203.0.113.x or 10.0.0.x only after review)" '([0-9]{1,3}\.){3}[0-9]{1,3}'
check "WireGuard-style key (44 base64 characters ending in =)" '[A-Za-z0-9+/]{43}='
check "private key block" 'PRIVATE KEY'
check "password or token assignment" '(password|passwd|secret|token|api[_-]?key)[[:space:]]*[:=]'
check "MAC address" '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}'
[ $bad -eq 0 ] && echo "Clean: nothing suspicious found."
exit $bad
