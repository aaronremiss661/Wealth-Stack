#!/bin/bash
# Fetch Mutual Fund NAV from AMFI India API
# Usage:
#   fetch-mf-nav.sh SCHEME_CODE [SCHEME_CODE2 ...]   — fetch specific scheme(s)
#   fetch-mf-nav.sh --all                              — download full AMFI NAV file
#   fetch-mf-nav.sh --search "fund name"               — search for scheme codes
#   fetch-mf-nav.sh --cache-hours N                     — set cache validity (default 6)
# Find scheme codes at: https://www.amfiindia.com/spages/NAVAll.txt

CACHE_DIR="$HOME/.wealthstack/data"
CACHE_FILE="$CACHE_DIR/nav-cache.json"
AMFI_BULK_FILE="$CACHE_DIR/amfi-nav-all.txt"
CACHE_HOURS=6

mkdir -p "$CACHE_DIR"

# Parse leading flags
MODE="single"
SEARCH_TERM=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      MODE="all"
      shift
      ;;
    --search)
      MODE="search"
      SEARCH_TERM="$2"
      shift 2
      ;;
    --cache-hours)
      CACHE_HOURS="$2"
      shift 2
      ;;
    --refresh)
      CACHE_HOURS=0
      shift
      ;;
    -*)
      echo "{\"error\": \"Unknown flag: $1. Usage: fetch-mf-nav.sh [--all|--search 'name'|--cache-hours N|SCHEME_CODE ...]\"}"
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

python3 -c "
import json, os, sys, time, urllib.request, urllib.error, re

CACHE_DIR = os.path.expanduser('~/.wealthstack/data')
CACHE_FILE = os.path.join(CACHE_DIR, 'nav-cache.json')
AMFI_BULK_FILE = os.path.join(CACHE_DIR, 'amfi-nav-all.txt')
CACHE_HOURS = $CACHE_HOURS
MODE = '$MODE'
SEARCH_TERM = '''$SEARCH_TERM'''
SCHEME_CODES = '$*'.split()

os.makedirs(CACHE_DIR, exist_ok=True)

def load_cache():
    if os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE, 'r') as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError):
            pass
    return {'_meta': {'created': time.time()}, 'schemes': {}}

def save_cache(cache):
    cache['_meta']['updated'] = time.time()
    with open(CACHE_FILE, 'w') as f:
        json.dump(cache, f, indent=2)

def is_cache_valid(cache, key=None):
    if CACHE_HOURS <= 0:
        return False
    ts = cache.get('_meta', {}).get('updated', 0)
    if key and key in cache.get('schemes', {}):
        entry = cache['schemes'][key]
        ts = entry.get('_fetched_at', ts)
    age_hours = (time.time() - ts) / 3600
    return age_hours < CACHE_HOURS

def fetch_url(url):
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'WealthStack/1.0'})
        with urllib.request.urlopen(req, timeout=30) as resp:
            return resp.read().decode('utf-8', errors='replace')
    except (urllib.error.URLError, urllib.error.HTTPError, OSError) as e:
        return None

def fetch_single_nav(code, cache):
    code_str = str(code)
    if is_cache_valid(cache, code_str):
        return cache['schemes'][code_str]
    raw = fetch_url(f'https://api.mfapi.in/mf/{code}/latest')
    if raw:
        try:
            data = json.loads(raw)
            meta = data.get('meta', {})
            nav_data = data.get('data', [{}])
            latest = nav_data[0] if nav_data else {}
            result = {
                'scheme_code': code_str,
                'scheme_name': meta.get('scheme_name', 'Unknown'),
                'fund_house': meta.get('fund_house', 'Unknown'),
                'scheme_type': meta.get('scheme_type', 'Unknown'),
                'scheme_category': meta.get('scheme_category', 'Unknown'),
                'nav': float(latest.get('nav', 0)) if latest.get('nav') else 0,
                'date': latest.get('date', 'N/A'),
                '_fetched_at': time.time()
            }
            cache.setdefault('schemes', {})[code_str] = result
            save_cache(cache)
            return result
        except (json.JSONDecodeError, KeyError, IndexError, ValueError):
            pass
    return {'scheme_code': code_str, 'error': f'Failed to fetch NAV for scheme {code}'}

def download_bulk_nav():
    \"\"\"Download full AMFI NAV text file.\"\"\"
    # Check if bulk file is fresh enough
    if os.path.exists(AMFI_BULK_FILE) and CACHE_HOURS > 0:
        age_hours = (time.time() - os.path.getmtime(AMFI_BULK_FILE)) / 3600
        if age_hours < CACHE_HOURS:
            with open(AMFI_BULK_FILE, 'r') as f:
                return f.read()
    raw = fetch_url('https://www.amfiindia.com/spages/NAVAll.txt')
    if raw:
        with open(AMFI_BULK_FILE, 'w') as f:
            f.write(raw)
        return raw
    elif os.path.exists(AMFI_BULK_FILE):
        with open(AMFI_BULK_FILE, 'r') as f:
            return f.read()
    return None

def parse_bulk_nav(text):
    \"\"\"Parse AMFI NAV text file into structured data.\"\"\"
    results = {}
    current_category = ''
    current_fund_house = ''
    for line in text.strip().split('\n'):
        line = line.strip()
        if not line or line.startswith('Scheme Code'):
            continue
        parts = line.split(';')
        if len(parts) >= 6:
            try:
                code = parts[0].strip()
                name = parts[1].strip() if len(parts) > 1 else ''
                nav_val = parts[4].strip() if len(parts) > 4 else '0'
                date = parts[5].strip() if len(parts) > 5 else ''
                try:
                    nav_float = float(nav_val)
                except ValueError:
                    nav_float = 0
                results[code] = {
                    'scheme_code': code,
                    'scheme_name': name,
                    'fund_house': current_fund_house,
                    'scheme_category': current_category,
                    'nav': nav_float,
                    'date': date
                }
            except (IndexError, ValueError):
                continue
        elif len(parts) == 1 and line:
            # Category or fund house header line
            if any(kw in line.lower() for kw in ['mutual fund', 'fund -']):
                current_fund_house = line
            else:
                current_category = line
    return results

def mode_all():
    raw = download_bulk_nav()
    if not raw:
        print(json.dumps({'error': 'Failed to download AMFI NAV file', 'source': 'https://www.amfiindia.com/spages/NAVAll.txt'}))
        return
    schemes = parse_bulk_nav(raw)
    result = {
        'total_schemes': len(schemes),
        'source': 'AMFI India (NAVAll.txt)',
        'cached_at': AMFI_BULK_FILE,
        'timestamp': time.strftime('%Y-%m-%d %H:%M:%S')
    }
    # Save parsed data to cache as well
    cache = load_cache()
    for code, data in schemes.items():
        data['_fetched_at'] = time.time()
        cache.setdefault('schemes', {})[code] = data
    save_cache(cache)
    result['sample'] = dict(list(schemes.items())[:5])
    print(json.dumps(result, indent=2))

def mode_search(term):
    # First try from bulk file (faster), then from API
    if os.path.exists(AMFI_BULK_FILE):
        with open(AMFI_BULK_FILE, 'r') as f:
            raw = f.read()
    else:
        raw = download_bulk_nav()
    if not raw:
        # Fallback: search via API
        api_raw = fetch_url(f'https://api.mfapi.in/mf/search?q={term.replace(\" \", \"%20\")}')
        if api_raw:
            try:
                results = json.loads(api_raw)
                print(json.dumps({'query': term, 'results': results[:20], 'total': len(results)}, indent=2))
                return
            except json.JSONDecodeError:
                pass
        print(json.dumps({'error': 'Could not search. Try: fetch-mf-nav.sh --all first'}))
        return
    # Search through bulk data
    term_lower = term.lower()
    matches = []
    for line in raw.strip().split('\n'):
        parts = line.split(';')
        if len(parts) >= 5 and term_lower in line.lower():
            try:
                nav_val = parts[4].strip()
                try:
                    nav_float = float(nav_val)
                except ValueError:
                    nav_float = 0
                matches.append({
                    'scheme_code': parts[0].strip(),
                    'scheme_name': parts[1].strip() if len(parts) > 1 else '',
                    'nav': nav_float,
                    'date': parts[5].strip() if len(parts) > 5 else ''
                })
            except (IndexError, ValueError):
                continue
    matches.sort(key=lambda x: x.get('scheme_name', ''))
    result = {
        'query': term,
        'total_matches': len(matches),
        'results': matches[:25],
        'note': 'Showing top 25 matches.' if len(matches) > 25 else None
    }
    if not result['note']:
        del result['note']
    print(json.dumps(result, indent=2))

def mode_single(codes, cache):
    if not codes:
        print(json.dumps({'error': 'Usage: fetch-mf-nav.sh SCHEME_CODE [SCHEME_CODE2 ...] | --all | --search \"fund name\"'}))
        sys.exit(1)
    results = {}
    for code in codes:
        results[code] = fetch_single_nav(code, cache)
    # If single code, return just that result; if multiple, return dict
    if len(results) == 1:
        print(json.dumps(list(results.values())[0], indent=2))
    else:
        print(json.dumps(results, indent=2))

# Main
cache = load_cache()

if MODE == 'all':
    mode_all()
elif MODE == 'search':
    mode_search(SEARCH_TERM)
else:
    mode_single(SCHEME_CODES, cache)
" 2>/dev/null || echo '{"error": "Python3 execution failed"}'
