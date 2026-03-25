#!/bin/bash
# Fetch historical price data using yfinance
# Usage:
#   fetch-historical.sh TICKER START_DATE END_DATE [INTERVAL]
#   fetch-historical.sh --index nifty50 --years 5
#   fetch-historical.sh --index banknifty --start 2020-01-01 --end 2023-12-31
#   fetch-historical.sh ^NSEI 2020-01-01 2024-01-01 1wk
# Intervals: 1d (default), 1wk, 1mo
# Pre-built index aliases: nifty50, banknifty, niftyit, midcap

CACHE_DIR="$HOME/.wealthstack/data/historical"
mkdir -p "$CACHE_DIR"

# Defaults
TICKER=""
START=""
END=""
INTERVAL="1d"
INDEX=""
YEARS=""
REFRESH=0

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    --index)
      INDEX="$2"
      shift 2
      ;;
    --years)
      YEARS="$2"
      shift 2
      ;;
    --start)
      START="$2"
      shift 2
      ;;
    --end)
      END="$2"
      shift 2
      ;;
    --interval)
      INTERVAL="$2"
      shift 2
      ;;
    --refresh)
      REFRESH=1
      shift
      ;;
    -*)
      echo '{"error": "Unknown flag: '"$1"'. Usage: fetch-historical.sh TICKER START END [INTERVAL] | --index NAME --years N"}'
      exit 1
      ;;
    *)
      # Positional args: TICKER START END [INTERVAL]
      if [ -z "$TICKER" ]; then
        TICKER="$1"
      elif [ -z "$START" ]; then
        START="$1"
      elif [ -z "$END" ]; then
        END="$1"
      else
        INTERVAL="$1"
      fi
      shift
      ;;
  esac
done

python3 -c "
import json, os, sys, time
from datetime import datetime, timedelta

CACHE_DIR = os.path.expanduser('~/.wealthstack/data/historical')
os.makedirs(CACHE_DIR, exist_ok=True)

# Pre-built index aliases
INDEX_MAP = {
    'nifty50':   '^NSEI',
    'nifty':     '^NSEI',
    'banknifty': '^NSEBANK',
    'niftyit':   '^CNXIT',
    'midcap':    'NIFTY_MIDCAP_150.NS',
    'smallcap':  'NIFTY_SMLCAP_250.NS',
    'sensex':    '^BSESN'
}

INDEX     = '$INDEX'.strip().lower()
YEARS     = '$YEARS'.strip()
TICKER    = '$TICKER'.strip()
START     = '$START'.strip()
END       = '$END'.strip()
INTERVAL  = '$INTERVAL'.strip() or '1d'
REFRESH   = $REFRESH

# Resolve index alias to ticker
if INDEX:
    if INDEX in INDEX_MAP:
        TICKER = INDEX_MAP[INDEX]
    else:
        print(json.dumps({
            'error': f'Unknown index alias: {INDEX}',
            'available': list(INDEX_MAP.keys())
        }))
        sys.exit(1)

# Resolve --years to start/end dates
if YEARS:
    try:
        y = int(YEARS)
    except ValueError:
        print(json.dumps({'error': f'Invalid --years value: {YEARS}'}))
        sys.exit(1)
    END = END or datetime.now().strftime('%Y-%m-%d')
    START = START or (datetime.now() - timedelta(days=y * 365)).strftime('%Y-%m-%d')

# Validate required params
if not TICKER:
    print(json.dumps({
        'error': 'No ticker specified.',
        'usage': [
            'fetch-historical.sh TICKER START_DATE END_DATE [INTERVAL]',
            'fetch-historical.sh --index nifty50 --years 5',
            'fetch-historical.sh --index banknifty --start 2020-01-01 --end 2023-12-31'
        ],
        'available_indices': list(INDEX_MAP.keys()),
        'intervals': ['1d', '1wk', '1mo']
    }))
    sys.exit(1)

if not START or not END:
    print(json.dumps({
        'error': 'START and END dates required. Use YYYY-MM-DD format or --years N.',
        'usage': 'fetch-historical.sh TICKER 2020-01-01 2024-01-01 [1d|1wk|1mo]'
    }))
    sys.exit(1)

# Validate dates
try:
    start_dt = datetime.strptime(START, '%Y-%m-%d')
    end_dt = datetime.strptime(END, '%Y-%m-%d')
    if start_dt >= end_dt:
        print(json.dumps({'error': 'START date must be before END date'}))
        sys.exit(1)
except ValueError as e:
    print(json.dumps({'error': f'Invalid date format: {e}. Use YYYY-MM-DD.'}))
    sys.exit(1)

if INTERVAL not in ('1d', '1wk', '1mo'):
    print(json.dumps({'error': f'Invalid interval: {INTERVAL}. Use 1d, 1wk, or 1mo.'}))
    sys.exit(1)

# Cache file path
safe_ticker = TICKER.replace('^', '').replace('.', '_')
cache_file = os.path.join(CACHE_DIR, f'{safe_ticker}-{START}-{END}-{INTERVAL}.json')

# Check cache
if not REFRESH and os.path.exists(cache_file):
    try:
        with open(cache_file, 'r') as f:
            cached = json.load(f)
        # Cache valid for 24 hours for recent data, indefinitely for historical
        cache_age_hours = (time.time() - cached.get('_meta', {}).get('fetched_ts', 0)) / 3600
        days_to_end = (datetime.now() - end_dt).days
        if days_to_end > 7 or cache_age_hours < 24:
            cached['_meta']['from_cache'] = True
            print(json.dumps(cached, indent=2))
            sys.exit(0)
    except (json.JSONDecodeError, IOError, KeyError):
        pass

# Fetch via yfinance
try:
    import yfinance as yf
except ImportError:
    print(json.dumps({'error': 'yfinance not installed. Run: pip install yfinance'}))
    sys.exit(1)

try:
    ticker_obj = yf.Ticker(TICKER)
    hist = ticker_obj.history(start=START, end=END, interval=INTERVAL)

    if hist.empty:
        print(json.dumps({
            'error': f'No data returned for {TICKER} from {START} to {END}',
            'hint': 'Check if the ticker is valid and the date range has trading data.'
        }))
        sys.exit(1)

    # Build JSON array of OHLCV
    data_points = []
    for idx, row in hist.iterrows():
        data_points.append({
            'date': idx.strftime('%Y-%m-%d'),
            'open': round(float(row['Open']), 2),
            'high': round(float(row['High']), 2),
            'low': round(float(row['Low']), 2),
            'close': round(float(row['Close']), 2),
            'volume': int(row['Volume'])
        })

    result = {
        'ticker': TICKER,
        'index_alias': INDEX if INDEX else None,
        'period': {'start': START, 'end': END},
        'interval': INTERVAL,
        'total_records': len(data_points),
        'data': data_points,
        '_meta': {
            'fetched_at': time.strftime('%Y-%m-%d %H:%M:%S'),
            'fetched_ts': time.time(),
            'source': 'yfinance',
            'from_cache': False,
            'cache_file': cache_file
        }
    }

    # Remove None values
    if not result['index_alias']:
        del result['index_alias']

    # Save to cache
    with open(cache_file, 'w') as f:
        json.dump(result, f, indent=2)

    print(json.dumps(result, indent=2))

except Exception as e:
    print(json.dumps({
        'error': f'Failed to fetch data: {str(e)}',
        'ticker': TICKER,
        'period': {'start': START, 'end': END}
    }))
    sys.exit(1)
" 2>/dev/null || echo '{"error": "Python3 execution failed. Ensure yfinance is installed: pip install yfinance"}'
