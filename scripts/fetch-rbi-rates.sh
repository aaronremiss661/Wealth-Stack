#!/bin/bash
# Fetch current RBI policy rates and recent rate changes
# Usage:
#   fetch-rbi-rates.sh              — show current rates (cached)
#   fetch-rbi-rates.sh --refresh    — bypass cache and fetch fresh data
#   fetch-rbi-rates.sh --history    — include extended rate change history
# Sources: RBI website, known policy rate data

CACHE_DIR="$HOME/.wealthstack/data"
CACHE_FILE="$CACHE_DIR/rbi-rates-cache.json"
CACHE_HOURS=24
REFRESH=0
HISTORY=0

mkdir -p "$CACHE_DIR"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --refresh)
      REFRESH=1
      shift
      ;;
    --history)
      HISTORY=1
      shift
      ;;
    --cache-hours)
      CACHE_HOURS="$2"
      shift 2
      ;;
    -*)
      echo "{\"error\": \"Unknown flag: $1. Usage: fetch-rbi-rates.sh [--refresh|--history|--cache-hours N]\"}"
      exit 1
      ;;
    *)
      shift
      ;;
  esac
done

python3 -c "
import json, os, sys, time, urllib.request, urllib.error

CACHE_DIR = os.path.expanduser('~/.wealthstack/data')
CACHE_FILE = os.path.join(CACHE_DIR, 'rbi-rates-cache.json')
CACHE_HOURS = $CACHE_HOURS
REFRESH = $REFRESH
HISTORY = $HISTORY

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
        'source': 'RBI / Known policy data'
    }
    with open(CACHE_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def is_cache_valid(cache):
    if REFRESH or CACHE_HOURS <= 0:
        return False
    ts = cache.get('_meta', {}).get('updated', 0)
    age_hours = (time.time() - ts) / 3600
    return age_hours < CACHE_HOURS

def fetch_url(url):
    try:
        req = urllib.request.Request(url, headers={
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
            'Accept': 'text/html,application/json,*/*'
        })
        with urllib.request.urlopen(req, timeout=30) as resp:
            return resp.read().decode('utf-8', errors='replace')
    except (urllib.error.URLError, urllib.error.HTTPError, OSError):
        return None

def try_fetch_rbi_rates():
    \"\"\"Attempt to fetch latest rates from RBI website / known APIs.\"\"\"
    # Try RBI's current rates page
    urls = [
        'https://www.rbi.org.in/Scripts/BS_NSDPDisplay.aspx?param=4',
        'https://rbi.org.in/scripts/WSSView.aspx?TYPE=Section&PARAM=CurrentRates',
    ]
    for url in urls:
        raw = fetch_url(url)
        if raw and ('repo' in raw.lower() or 'policy rate' in raw.lower()):
            return raw
    return None

def parse_rbi_html(html):
    \"\"\"Attempt basic parsing of RBI rate page. Returns dict or None.\"\"\"
    import re
    rates = {}
    # Look for common rate patterns in the HTML
    patterns = {
        'repo_rate': r'[Rr]epo\s*[Rr]ate.*?([\d]+\.[\d]+)\s*%',
        'sdf_rate': r'(?:SDF|Standing Deposit Facility).*?([\d]+\.[\d]+)\s*%',
        'msf_rate': r'(?:MSF|Marginal Standing Facility).*?([\d]+\.[\d]+)\s*%',
        'bank_rate': r'[Bb]ank\s*[Rr]ate.*?([\d]+\.[\d]+)\s*%',
        'crr': r'CRR.*?([\d]+\.[\d]+)\s*%',
        'slr': r'SLR.*?([\d]+\.[\d]+)\s*%',
    }
    for key, pattern in patterns.items():
        match = re.search(pattern, html, re.DOTALL)
        if match:
            try:
                rates[key] = float(match.group(1))
            except ValueError:
                pass
    return rates if rates else None

# Known current RBI rates (as of latest policy decisions)
# These serve as reliable fallback — updated to Feb 2025 MPC decision
KNOWN_RATES = {
    'current_rates': {
        'repo_rate': {
            'value': 6.25,
            'unit': '%',
            'description': 'Policy Repo Rate — rate at which RBI lends to banks overnight',
            'effective_from': '2025-02-07',
            'last_change': 'Cut by 25 bps from 6.50% (Feb 7, 2025 MPC)'
        },
        'sdf_rate': {
            'value': 6.00,
            'unit': '%',
            'description': 'Standing Deposit Facility — floor of the LAF corridor (replaced reverse repo)',
            'effective_from': '2025-02-07',
            'note': 'SDF = Repo Rate - 25 bps'
        },
        'msf_rate': {
            'value': 6.50,
            'unit': '%',
            'description': 'Marginal Standing Facility Rate — ceiling of the LAF corridor',
            'effective_from': '2025-02-07',
            'note': 'MSF = Repo Rate + 25 bps'
        },
        'bank_rate': {
            'value': 6.50,
            'unit': '%',
            'description': 'Bank Rate — aligned with MSF rate',
            'effective_from': '2025-02-07'
        },
        'crr': {
            'value': 4.00,
            'unit': '%',
            'description': 'Cash Reserve Ratio — fraction of deposits banks must hold with RBI',
            'effective_from': '2024-12-14',
            'last_change': 'Cut by 50 bps from 4.50% (Dec 2024, in two tranches)'
        },
        'slr': {
            'value': 18.00,
            'unit': '%',
            'description': 'Statutory Liquidity Ratio — fraction of deposits banks must hold in approved securities',
            'effective_from': '2020-10-01',
            'note': 'Unchanged since Oct 2020'
        }
    },
    'laf_corridor': {
        'floor': 6.00,
        'repo': 6.25,
        'ceiling': 6.50,
        'width': '50 bps symmetric',
        'description': 'Liquidity Adjustment Facility corridor: SDF (floor) — Repo — MSF (ceiling)'
    },
    'recent_changes': [
        {
            'date': '2025-02-07',
            'action': 'Repo rate cut by 25 bps to 6.25%',
            'mpc_vote': '6-0 unanimous',
            'stance': 'Neutral',
            'details': 'First rate cut since May 2020. CPI inflation at 5.22% (Dec 2024). GDP growth forecast 6.7% for FY26.'
        },
        {
            'date': '2024-12-06',
            'action': 'Repo rate held at 6.50%; CRR cut by 50 bps to 4.00%',
            'mpc_vote': '4-2 (hold)',
            'stance': 'Changed to Neutral from Withdrawal of Accommodation',
            'details': 'CRR cut released approx Rs 1.16 lakh crore liquidity. Effective in two tranches (Dec 14 & Dec 28).'
        },
        {
            'date': '2024-10-09',
            'action': 'Repo rate held at 6.50%',
            'mpc_vote': '5-1 (hold)',
            'stance': 'Changed to Neutral from Withdrawal of Accommodation',
            'details': 'Stance change signaled future easing. CPI inflation trending down. GDP growth revised to 7.2% for FY25.'
        },
        {
            'date': '2024-08-08',
            'action': 'Repo rate held at 6.50%',
            'mpc_vote': '4-2 (hold)',
            'stance': 'Withdrawal of Accommodation',
            'details': 'Two members voted for 25 bps cut. Food inflation remained elevated.'
        },
        {
            'date': '2024-06-07',
            'action': 'Repo rate held at 6.50%',
            'mpc_vote': '4-2 (hold)',
            'stance': 'Withdrawal of Accommodation',
            'details': 'GDP growth for FY25 projected at 7.2%. CPI inflation projected at 4.5% for FY25.'
        }
    ],
    'rate_cycle_context': {
        'current_cycle': 'Easing — rate cut cycle began Feb 2025',
        'last_hike': '2023-02-08 (repo raised to 6.50%)',
        'total_hikes_2022_23': '250 bps (4.00% to 6.50%) across 6 hikes from May 2022 to Feb 2023',
        'pre_pandemic_repo': '5.15% (Feb 2020)',
        'pandemic_low': '4.00% (May 2020)',
        'note': 'After the Feb 2025 cut, markets expect further 50-75 bps of cuts through 2025 depending on inflation trajectory.'
    }
}

cache = load_cache()

if is_cache_valid(cache):
    cache['_meta']['from_cache'] = True
    print(json.dumps(cache, indent=2))
    sys.exit(0)

# Start with known rates as base
result = dict(KNOWN_RATES)

# Try to fetch latest from RBI website
rbi_html = try_fetch_rbi_rates()
if rbi_html:
    parsed = parse_rbi_html(rbi_html)
    if parsed:
        result['live_data'] = {}
        for key, val in parsed.items():
            result['live_data'][key] = val
        result['live_data']['fetched_at'] = time.strftime('%Y-%m-%d %H:%M:%S')
        result['live_data']['note'] = 'Parsed from RBI website. Cross-check with known values.'
        # Update known rates if live data differs meaningfully
        rate_map = {
            'repo_rate': 'repo_rate',
            'sdf_rate': 'sdf_rate',
            'msf_rate': 'msf_rate',
            'bank_rate': 'bank_rate',
            'crr': 'crr',
            'slr': 'slr'
        }
        for live_key, known_key in rate_map.items():
            if live_key in parsed and known_key in result['current_rates']:
                if parsed[live_key] != result['current_rates'][known_key]['value']:
                    result['current_rates'][known_key]['live_value'] = parsed[live_key]
                    result['current_rates'][known_key]['discrepancy'] = True
else:
    result['live_fetch'] = {
        'status': 'unavailable',
        'note': 'Could not fetch from RBI website. Using known rate data (last verified: Feb 2025 MPC).',
        'verify_at': 'https://www.rbi.org.in/Scripts/BS_NSDPDisplay.aspx?param=4'
    }

# Trim history if not requested
if not HISTORY:
    result['recent_changes'] = result['recent_changes'][:3]
    if 'rate_cycle_context' in result:
        del result['rate_cycle_context']

save_cache(result)
result.setdefault('_meta', {})
result['_meta']['from_cache'] = False
result['_meta']['updated_at'] = time.strftime('%Y-%m-%d %H:%M:%S')
print(json.dumps(result, indent=2))
" 2>/dev/null || echo '{"error": "Python3 execution failed"}'
