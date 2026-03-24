#!/bin/bash
# Fetch stock/ETF/MF quotes using yfinance via Python
# Usage: fetch-quotes.sh TICKER1.NS TICKER2.NS ...
# Append .NS for NSE, .BO for BSE

if [ $# -eq 0 ]; then
  echo '{"error": "Usage: fetch-quotes.sh TICKER1.NS TICKER2.NS ..."}'
  exit 1
fi

TICKERS="$*"

python3 -c "
import json, sys
try:
    import yfinance as yf
    tickers = '$TICKERS'.split()
    results = {}
    for t in tickers:
        try:
            stock = yf.Ticker(t)
            info = stock.info
            results[t] = {
                'name': info.get('shortName', t),
                'price': info.get('currentPrice', info.get('regularMarketPrice', 0)),
                'change_pct': info.get('regularMarketChangePercent', 0),
                'day_high': info.get('dayHigh', 0),
                'day_low': info.get('dayLow', 0),
                '52w_high': info.get('fiftyTwoWeekHigh', 0),
                '52w_low': info.get('fiftyTwoWeekLow', 0),
                'market_cap': info.get('marketCap', 0),
                'pe_ratio': info.get('trailingPE', 0),
                'sector': info.get('sector', 'N/A'),
                'industry': info.get('industry', 'N/A'),
                'dividend_yield': info.get('dividendYield', 0),
                'currency': 'INR'
            }
        except Exception as e:
            results[t] = {'error': str(e)}
    print(json.dumps(results, indent=2))
except ImportError:
    print(json.dumps({'error': 'yfinance not installed. Run: pip install yfinance'}))
" 2>/dev/null
