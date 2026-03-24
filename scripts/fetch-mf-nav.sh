#!/bin/bash
# Fetch Mutual Fund NAV from AMFI India API
# Usage: fetch-mf-nav.sh SCHEME_CODE [SCHEME_CODE2 ...]
# Find scheme codes at: https://www.amfiindia.com/spages/NAVAll.txt

if [ $# -eq 0 ]; then
  echo '{"error": "Usage: fetch-mf-nav.sh SCHEME_CODE [SCHEME_CODE2 ...]"}'
  exit 1
fi

for CODE in "$@"; do
  curl -s "https://api.mfapi.in/mf/$CODE/latest" 2>/dev/null || echo "{\"error\": \"Failed to fetch NAV for scheme $CODE\"}"
done
