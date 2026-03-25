#!/bin/bash
# Fetch major Indian market indices using yfinance
# Usage:
#   fetch-indices.sh                — fetch all major indices (cached)
#   fetch-indices.sh --refresh      — bypass cache and fetch fresh data
#   fetch-indices.sh SYMBOL         — fetch specific index (e.g., ^NSEI)

CACHE_DIR="$HOME/.wealthstack/data"
CACHE_FILE="$CACHE_DIR/indices-cache.json"
CACHE_HOURS=1
REFRESH=0
SPECIFIC=""

mkdir -p "$CACHE_DIR"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --refresh)
      REFRESH=1
      shift
      ;;
    --cache-hours)
      CACHE_HOURS="$2"
      shift 2
      ;;
    -*)
      echo "{\"error\": \"Unknown flag: $1. Usage: fetch-indices.sh [--refresh|--cache-hours N|SYMBOL]\"}"
      exit 1
      ;;
    *)
      SPECIFIC="$1"
      shift
      ;;
  esac
done

python3 -c "
import json, os, sys, time

CACHE_DIR = os.path.expanduser('~/.wealthstack/data')
CACHE_FILE = os.path.join(CACHE_DIR, 'indices-cache.json')
CACHE_HOURS = $CACHE_HOURS
REFRESH = $REFRESH
SPECIFIC = '$SPECIFIC'

os.makedirs(CACHE_DIR, exist_ok=True)

# Index definitions: display_name -> yfinance symbol
INDICES = {
    'Nifty 50':           '^NSEI',
    'Bank Nifty':         '^NSEBANK',
    'Nifty IT':           '^CNXIT',
    'Nifty Midcap 150':   'NIFTY_MIDCAP_150.NS',
    'Nifty Smallcap 250': 'NIFTY_SMLCAP_250.NS',
    'Nifty Next 50':      '^NSMIDCP'
}

def load_cache():
    if os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE, 'r') as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError):
            pass
    return {}

def save_cache(data):
    data['_meta'] = {
        'updated': time.time(),
        'updated_at': time.strftime('%Y-%m-%d %H:%M:%S'),
        'source': 'yfinance'
    }
    with open(CACHE_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def is_cache_valid(cache):
    if REFRESH or CACHE_HOURS <= 0:
        return False
    ts = cache.get('_meta', {}).get('updated', 0)
    age_hours = (time.time() - ts) / 3600
    return age_hours < CACHE_HOURS

cache = load_cache()

# Return cache if valid and no specific symbol requested
if is_cache_valid(cache) and not SPECIFIC:
    cache['_meta']['from_cache'] = True
    print(json.dumps(cache, indent=2))
    sys.exit(0)

try:
    import yfinance as yf
except ImportError:
    print(json.dumps({'error': 'yfinance not installed. Run: pip install yfinance'}))
    sys.exit(1)

def fetch_index(symbol, name):
    try:
        ticker = yf.Ticker(symbol)
        info = ticker.info
        hist = ticker.history(period='1d')

        price = info.get('regularMarketPrice', info.get('currentPrice', 0))
        prev_close = info.get('regularMarketPreviousClose', info.get('previousClose', 0))

        # Try to get price from history if info fails
        if not price and not hist.empty:
            price = float(hist['Close'].iloc[-1])
        if not prev_close:
            prev_close = price

        change = round(price - prev_close, 2) if price and prev_close else 0
        change_pct = round((change / prev_close) * 100, 2) if prev_close else 0

        day_high = info.get('dayHigh', info.get('regularMarketDayHigh', 0))
        day_low = info.get('dayLow', info.get('regularMarketDayLow', 0))

        if not day_high and not hist.empty:
            day_high = float(hist['High'].iloc[-1])
        if not day_low and not hist.empty:
            day_low = float(hist['Low'].iloc[-1])

        return {
            'symbol': symbol,
            'value': round(price, 2) if price else 0,
            'change': change,
            'change_pct': change_pct,
            'prev_close': round(prev_close, 2) if prev_close else 0,
            'day_high': round(day_high, 2) if day_high else 0,
            'day_low': round(day_low, 2) if day_low else 0,
            '52w_high': round(info.get('fiftyTwoWeekHigh', 0) or 0, 2),
            '52w_low': round(info.get('fiftyTwoWeekLow', 0) or 0, 2),
            'fetched_at': time.strftime('%Y-%m-%d %H:%M:%S')
        }
    except Exception as e:
        return {
            'symbol': symbol,
            'error': str(e),
            'fetched_at': time.strftime('%Y-%m-%d %H:%M:%S')
        }

results = {}

if SPECIFIC:
    # Fetch a single specific symbol
    name = SPECIFIC
    symbol = SPECIFIC
    # Check if it matches a known index name
    for n, s in INDICES.items():
        if SPECIFIC.upper() in s.upper() or SPECIFIC.lower() in n.lower():
            name = n
            symbol = s
            break
    results[name] = fetch_index(symbol, name)
else:
    # Fetch all indices
    for name, symbol in INDICES.items():
        results[name] = fetch_index(symbol, name)
    save_cache(results)

results.setdefault('_meta', {})
results['_meta']['updated_at'] = time.strftime('%Y-%m-%d %H:%M:%S')
results['_meta']['source'] = 'yfinance'
results['_meta']['from_cache'] = False

print(json.dumps(results, indent=2))
" 2>/dev/null || echo '{"error": "Python3 execution failed. Ensure yfinance is installed: pip install yfinance"}'
