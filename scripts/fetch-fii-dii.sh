#!/bin/bash
# Fetch FII/DII daily cash market activity data
# Usage:
#   fetch-fii-dii.sh              — fetch latest day's data (cached)
#   fetch-fii-dii.sh --days N     — fetch last N trading days
#   fetch-fii-dii.sh --refresh    — bypass cache and fetch fresh data
# Sources: NSE India / NSDL / Moneycontrol

CACHE_DIR="$HOME/.wealthstack/data"
CACHE_FILE="$CACHE_DIR/fii-dii-cache.json"
CACHE_HOURS=4
DAYS=1
REFRESH=0

mkdir -p "$CACHE_DIR"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --days)
      DAYS="$2"
      shift 2
      ;;
    --refresh)
      REFRESH=1
      shift
      ;;
    --cache-hours)
      CACHE_HOURS="$2"
      shift 2
      ;;
    -*)
      echo "{\"error\": \"Unknown flag: $1. Usage: fetch-fii-dii.sh [--days N|--refresh|--cache-hours N]\"}"
      exit 1
      ;;
    *)
      shift
      ;;
  esac
done

python3 -c "
import json, os, sys, time, urllib.request, urllib.error
from datetime import datetime, timedelta

CACHE_DIR = os.path.expanduser('~/.wealthstack/data')
CACHE_FILE = os.path.join(CACHE_DIR, 'fii-dii-cache.json')
CACHE_HOURS = $CACHE_HOURS
DAYS = $DAYS
REFRESH = $REFRESH

os.makedirs(CACHE_DIR, exist_ok=True)

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
        'source': 'NSE India',
        'days_requested': DAYS
    }
    with open(CACHE_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def is_cache_valid(cache):
    if REFRESH or CACHE_HOURS <= 0:
        return False
    ts = cache.get('_meta', {}).get('updated', 0)
    age_hours = (time.time() - ts) / 3600
    cached_days = cache.get('_meta', {}).get('days_requested', 1)
    return age_hours < CACHE_HOURS and cached_days >= DAYS

def fetch_url(url, headers=None):
    default_headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'en-US,en;q=0.9',
        'Referer': 'https://www.nseindia.com/',
    }
    if headers:
        default_headers.update(headers)
    try:
        req = urllib.request.Request(url, headers=default_headers)
        with urllib.request.urlopen(req, timeout=30) as resp:
            return resp.read().decode('utf-8', errors='replace')
    except (urllib.error.URLError, urllib.error.HTTPError, OSError) as e:
        return None

def fetch_nse_fii_dii():
    \"\"\"Try fetching FII/DII data from NSE India API.\"\"\"
    # NSE requires a session cookie — first hit the main page
    cookie_url = 'https://www.nseindia.com/'
    _ = fetch_url(cookie_url)

    # Then try the FII/DII API endpoint
    api_url = 'https://www.nseindia.com/api/fiidiiActivity'
    raw = fetch_url(api_url)
    if raw:
        try:
            data = json.loads(raw)
            return data
        except json.JSONDecodeError:
            pass
    return None

def parse_nse_response(data):
    \"\"\"Parse the NSE FII/DII API response into clean format.\"\"\"
    results = []
    if isinstance(data, list):
        for entry in data:
            try:
                category = entry.get('category', '')
                buy = float(str(entry.get('buyValue', 0)).replace(',', ''))
                sell = float(str(entry.get('sellValue', 0)).replace(',', ''))
                net = round(buy - sell, 2)
                results.append({
                    'category': category,
                    'buy': buy,
                    'sell': sell,
                    'net': net,
                    'date': entry.get('date', '')
                })
            except (ValueError, TypeError):
                continue
    return results

def get_fallback_data():
    \"\"\"Provide structured fallback using known approximate values.
    Returned when live API is unreachable (NSE blocks automated requests).
    \"\"\"
    today = datetime.now()
    results = []

    for day_offset in range(DAYS):
        d = today - timedelta(days=day_offset)
        # Skip weekends
        if d.weekday() >= 5:
            continue
        date_str = d.strftime('%d-%b-%Y')
        results.append({
            'date': date_str,
            'fii': {
                'buy': 0,
                'sell': 0,
                'net': 0,
                'note': 'Live data unavailable — NSE blocks automated requests'
            },
            'dii': {
                'buy': 0,
                'sell': 0,
                'net': 0,
                'note': 'Live data unavailable — NSE blocks automated requests'
            },
            'net_total': 0,
            'data_available': False
        })

    return results

cache = load_cache()

if is_cache_valid(cache) and not REFRESH:
    cache['_meta']['from_cache'] = True
    print(json.dumps(cache, indent=2))
    sys.exit(0)

# Try NSE API
nse_data = fetch_nse_fii_dii()
results = {'days': []}

if nse_data:
    parsed = parse_nse_response(nse_data)
    # Group by date
    by_date = {}
    for entry in parsed:
        date = entry.get('date', 'Unknown')
        if date not in by_date:
            by_date[date] = {'date': date, 'fii': {}, 'dii': {}}
        cat = entry['category'].upper()
        record = {'buy': entry['buy'], 'sell': entry['sell'], 'net': entry['net']}
        if 'FII' in cat or 'FPI' in cat:
            by_date[date]['fii'] = record
        elif 'DII' in cat:
            by_date[date]['dii'] = record

    for date, data in sorted(by_date.items(), reverse=True)[:DAYS]:
        fii_net = data.get('fii', {}).get('net', 0)
        dii_net = data.get('dii', {}).get('net', 0)
        data['net_total'] = round(fii_net + dii_net, 2)
        data['data_available'] = True
        results['days'].append(data)

    if results['days']:
        results['summary'] = {
            'period': f'Last {len(results[\"days\"])} trading day(s)',
            'total_fii_net': round(sum(d.get('fii', {}).get('net', 0) for d in results['days']), 2),
            'total_dii_net': round(sum(d.get('dii', {}).get('net', 0) for d in results['days']), 2),
            'values_in': 'Crores (INR)'
        }
else:
    # Fallback: try alternate approach with requests if available
    try:
        import requests
        session = requests.Session()
        session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
            'Accept': '*/*',
            'Accept-Language': 'en-US,en;q=0.9',
        })
        # Establish session with NSE
        session.get('https://www.nseindia.com/', timeout=10)
        resp = session.get('https://www.nseindia.com/api/fiidiiActivity', timeout=10)
        if resp.status_code == 200:
            data = resp.json()
            parsed = parse_nse_response(data)
            by_date = {}
            for entry in parsed:
                date = entry.get('date', 'Unknown')
                if date not in by_date:
                    by_date[date] = {'date': date, 'fii': {}, 'dii': {}}
                cat = entry['category'].upper()
                record = {'buy': entry['buy'], 'sell': entry['sell'], 'net': entry['net']}
                if 'FII' in cat or 'FPI' in cat:
                    by_date[date]['fii'] = record
                elif 'DII' in cat:
                    by_date[date]['dii'] = record
            for date, d in sorted(by_date.items(), reverse=True)[:DAYS]:
                fii_net = d.get('fii', {}).get('net', 0)
                dii_net = d.get('dii', {}).get('net', 0)
                d['net_total'] = round(fii_net + dii_net, 2)
                d['data_available'] = True
                results['days'].append(d)
    except Exception:
        pass

    if not results['days']:
        results['days'] = get_fallback_data()
        results['note'] = 'NSE API is not accessible via automated scripts (anti-bot protection). Use the NSE website directly or check moneycontrol.com/stocks/marketstats/fii_dii_activity/index.php for live data.'
        results['manual_sources'] = [
            'https://www.nseindia.com/reports/fii-dii',
            'https://www.moneycontrol.com/stocks/marketstats/fii_dii_activity/index.php',
            'https://trendlyne.com/macro/fii-dii/'
        ]

    if results.get('days') and results['days'][0].get('data_available', False):
        results['summary'] = {
            'period': f'Last {len(results[\"days\"])} trading day(s)',
            'total_fii_net': round(sum(d.get('fii', {}).get('net', 0) for d in results['days']), 2),
            'total_dii_net': round(sum(d.get('dii', {}).get('net', 0) for d in results['days']), 2),
            'values_in': 'Crores (INR)'
        }

save_cache(results)
results.setdefault('_meta', {})
results['_meta']['from_cache'] = False
print(json.dumps(results, indent=2))
" 2>/dev/null || echo '{"error": "Python3 execution failed"}'
