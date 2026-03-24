# Market Data Connector

## Purpose
Fetch real-time and historical market data for stocks, ETFs, mutual funds, and indices.

## Supported Data Sources

### 1. Yahoo Finance (via yfinance — no API key required)
Primary source for quick quotes and historical data.

```bash
# Install if not present
pip3 install yfinance 2>/dev/null

# Fetch current quote
python3 -c "
import yfinance as yf
import json
ticker = yf.Ticker('AAPL')
info = ticker.info
print(json.dumps({
    'symbol': info.get('symbol'),
    'price': info.get('currentPrice') or info.get('regularMarketPrice'),
    'change': info.get('regularMarketChange'),
    'change_pct': info.get('regularMarketChangePercent'),
    'high_52w': info.get('fiftyTwoWeekHigh'),
    'low_52w': info.get('fiftyTwoWeekLow'),
    'market_cap': info.get('marketCap'),
    'sector': info.get('sector'),
    'industry': info.get('industry'),
    'dividend_yield': info.get('dividendYield'),
    'pe_ratio': info.get('trailingPE'),
    'beta': info.get('beta')
}, indent=2))
"
```

### 2. NSE India (for Indian markets)
For Nifty 50, Sensex, and NSE-listed securities.

```bash
# Fetch NSE data via yfinance (append .NS for NSE, .BO for BSE)
python3 -c "
import yfinance as yf
import json
# Examples: RELIANCE.NS, TCS.NS, HDFCBANK.NS, ^NSEI (Nifty 50), ^BSESN (Sensex)
ticker = yf.Ticker('RELIANCE.NS')
info = ticker.info
print(json.dumps({
    'symbol': info.get('symbol'),
    'price': info.get('currentPrice') or info.get('regularMarketPrice'),
    'currency': info.get('currency'),
    'sector': info.get('sector'),
    'market_cap': info.get('marketCap')
}, indent=2))
"
```

### 3. Historical Data

```bash
python3 -c "
import yfinance as yf
import json
ticker = yf.Ticker('AAPL')
hist = ticker.history(period='1y')
# Returns DataFrame with Date, Open, High, Low, Close, Volume
print(hist.tail(10).to_json(orient='records', date_format='iso'))
"
```

### 4. Multiple Tickers at Once

```bash
python3 -c "
import yfinance as yf
import json
tickers = yf.Tickers('AAPL MSFT GOOGL AMZN')
data = {}
for symbol in ['AAPL', 'MSFT', 'GOOGL', 'AMZN']:
    info = tickers.tickers[symbol].info
    data[symbol] = {
        'price': info.get('currentPrice') or info.get('regularMarketPrice'),
        'change_pct': info.get('regularMarketChangePercent'),
        'sector': info.get('sector'),
        'market_cap': info.get('marketCap')
    }
print(json.dumps(data, indent=2))
"
```

## Fallback: WebSearch
If yfinance is unavailable or rate-limited, use WebSearch to look up:
- "[TICKER] stock price today"
- "[TICKER] market cap sector"
- "Nifty 50 today" / "Sensex today"

## Caching
Cache market data to `~/.wealth-mgmt/cache/` with timestamps:
- Intraday quotes: cache for 15 minutes
- Daily data: cache for 24 hours
- Fundamental data: cache for 7 days

```bash
CACHE_DIR=~/.wealth-mgmt/cache
mkdir -p "$CACHE_DIR"
# Write cache
echo '{"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'","data":{...}}' > "$CACHE_DIR/AAPL.json"
```
