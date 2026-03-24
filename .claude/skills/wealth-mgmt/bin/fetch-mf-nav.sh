#!/bin/bash
# fetch-mf-nav.sh — Fetch mutual fund NAV data from AMFI API
# Usage: fetch-mf-nav.sh <SCHEME_CODE> [SCHEME_CODE_2 ...]
# Example: fetch-mf-nav.sh 120503 119551
# AMFI API: https://api.mfapi.in/mf/<scheme_code>

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: fetch-mf-nav.sh <SCHEME_CODE> [SCHEME_CODE_2 ...]"
    echo ""
    echo "Find scheme codes at: https://www.amfiindia.com/spages/NAVAll.txt"
    echo "Or search: https://api.mfapi.in/mf/search?q=<fund_name>"
    echo ""
    echo "Examples:"
    echo "  fetch-mf-nav.sh 120503          # Parag Parikh Flexi Cap - Direct"
    echo "  fetch-mf-nav.sh 119551 120503   # Multiple funds"
    exit 1
fi

CACHE_DIR="${HOME}/.wealth-mgmt/cache/mf"
mkdir -p "$CACHE_DIR"

for SCHEME_CODE in "$@"; do
    CACHE_FILE="$CACHE_DIR/${SCHEME_CODE}.json"
    CACHE_AGE=3600  # 1 hour cache

    # Use cache if fresh
    if [ -f "$CACHE_FILE" ]; then
        FILE_AGE=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null) ))
        if [ "$FILE_AGE" -lt "$CACHE_AGE" ]; then
            cat "$CACHE_FILE"
            continue
        fi
    fi

    # Fetch from AMFI API
    RESPONSE=$(curl -s "https://api.mfapi.in/mf/${SCHEME_CODE}" 2>/dev/null)

    if echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('meta',{}).get('scheme_name',''))" 2>/dev/null | grep -q .; then
        echo "$RESPONSE" | tee "$CACHE_FILE"
    else
        echo "{\"error\": \"Failed to fetch NAV for scheme $SCHEME_CODE\"}"
    fi
done
