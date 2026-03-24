#!/usr/bin/env bash
# fetch-quotes.sh — Fetch stock/ETF/mutual fund quotes
# Usage: fetch-quotes.sh TICKER1 TICKER2 ...
# Returns JSON with current price, change, sector, and key metrics.

set -euo pipefail

CACHE_DIR="$HOME/.wealth-mgmt/cache"
CACHE_TTL=900  # 15 minutes in seconds
mkdir -p "$CACHE_DIR"

if [ $# -eq 0 ]; then
  echo "Usage: fetch-quotes.sh TICKER1 TICKER2 ..." >&2
  exit 1
fi

TICKERS="$*"

# Check if yfinance is available
if ! python3 -c "import yfinance" 2>/dev/null; then
  echo '{"error": "yfinance not installed. Run: pip3 install yfinance"}' >&2
  # Fallback: return cached data if available
  for ticker in $TICKERS; do
    cache_file="$CACHE_DIR/${ticker}.json"
    if [ -f "$cache_file" ]; then
      cat "$cache_file"
    fi
  done
  exit 1
fi

python3 << 'PYEOF'
import yfinance as yf
import json
import sys
import os
from datetime import datetime, timezone

tickers_str = """ + "\"$TICKERS\"" + """
tickers = tickers_str.split()
cache_dir = os.path.expanduser("~/.wealth-mgmt/cache")

results = {}
for symbol in tickers:
    try:
        ticker = yf.Ticker(symbol)
        info = ticker.info
        data = {
            "symbol": symbol,
            "name": info.get("longName") or info.get("shortName", ""),
            "price": info.get("currentPrice") or info.get("regularMarketPrice"),
            "previous_close": info.get("regularMarketPreviousClose"),
            "change": info.get("regularMarketChange"),
            "change_pct": info.get("regularMarketChangePercent"),
            "day_high": info.get("dayHigh"),
            "day_low": info.get("dayLow"),
            "high_52w": info.get("fiftyTwoWeekHigh"),
            "low_52w": info.get("fiftyTwoWeekLow"),
            "market_cap": info.get("marketCap"),
            "sector": info.get("sector"),
            "industry": info.get("industry"),
            "currency": info.get("currency", "USD"),
            "exchange": info.get("exchange"),
            "dividend_yield": info.get("dividendYield"),
            "pe_ratio": info.get("trailingPE"),
            "forward_pe": info.get("forwardPE"),
            "beta": info.get("beta"),
            "volume": info.get("volume"),
            "avg_volume": info.get("averageVolume"),
            "fetched_at": datetime.now(timezone.utc).isoformat()
        }
        results[symbol] = data

        # Cache individual ticker
        cache_file = os.path.join(cache_dir, f"{symbol}.json")
        with open(cache_file, "w") as f:
            json.dump(data, f, indent=2)

    except Exception as e:
        results[symbol] = {"symbol": symbol, "error": str(e)}

print(json.dumps(results, indent=2))
PYEOF
