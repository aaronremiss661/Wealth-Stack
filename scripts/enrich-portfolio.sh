#!/bin/bash
# Enrich portfolio holdings with current NAVs/prices and compute gains
# Usage: enrich-portfolio.sh [PORTFOLIO_JSON_PATH]
# Default: ~/.wealthstack/portfolios/latest.json
# Fetches current NAV for MF holdings (via AMFI API) and prices for stocks (via yfinance)
# Outputs enriched JSON with current_value, gains, day_change

FILE=${1:-~/.wealthstack/portfolios/latest.json}

if [ ! -f "$FILE" ]; then
  echo "{\"error\": \"Portfolio file not found: $FILE\"}"
  exit 1
fi

mkdir -p ~/.wealthstack/portfolios

python3 -c "
import json, sys, os, re
from datetime import datetime
from urllib.request import urlopen, Request
from urllib.error import URLError

portfolio_path = os.path.expanduser('$FILE')
out_dir = os.path.expanduser('~/.wealthstack/portfolios')

try:
    with open(portfolio_path) as f:
        portfolio = json.load(f)
except FileNotFoundError:
    print(json.dumps({'error': f'Portfolio file not found: {portfolio_path}'}))
    sys.exit(1)
except json.JSONDecodeError:
    print(json.dumps({'error': f'Invalid JSON in file: {portfolio_path}'}))
    sys.exit(1)

holdings = portfolio.get('holdings', [])
if not holdings:
    print(json.dumps({'error': 'No holdings found in portfolio file.'}))
    sys.exit(1)

# ---------------------------------------------------------------------------
# Helper: fetch MF NAV from AMFI API (api.mfapi.in)
# ---------------------------------------------------------------------------
def fetch_mf_nav(scheme_code):
    \"\"\"Fetch latest NAV for a mutual fund scheme code.\"\"\"
    if not scheme_code:
        return None
    try:
        url = f'https://api.mfapi.in/mf/{scheme_code}/latest'
        req = Request(url, headers={'User-Agent': 'WealthStack/1.0'})
        resp = urlopen(req, timeout=10)
        data = json.loads(resp.read().decode())
        if 'data' in data and len(data['data']) > 0:
            nav_str = data['data'][0].get('nav', '0')
            nav_date = data['data'][0].get('date', '')
            return {
                'nav': float(nav_str),
                'date': nav_date,
                'scheme_name': data.get('meta', {}).get('scheme_name', '')
            }
    except Exception:
        pass
    return None

# ---------------------------------------------------------------------------
# Helper: batch-fetch stock prices via yfinance
# ---------------------------------------------------------------------------
def fetch_stock_prices(tickers):
    \"\"\"Fetch current prices for a list of stock tickers via yfinance.\"\"\"
    results = {}
    if not tickers:
        return results
    try:
        import yfinance as yf
        for t in tickers:
            try:
                # Append .NS if no exchange suffix
                symbol = t if ('.' in t) else t + '.NS'
                stock = yf.Ticker(symbol)
                info = stock.info
                price = info.get('currentPrice', info.get('regularMarketPrice', 0))
                prev_close = info.get('previousClose', info.get('regularMarketPreviousClose', 0))
                day_change = 0
                day_change_pct = 0
                if price and prev_close and prev_close > 0:
                    day_change = round(price - prev_close, 2)
                    day_change_pct = round((day_change / prev_close) * 100, 2)
                results[t] = {
                    'current_price': price or 0,
                    'previous_close': prev_close or 0,
                    'day_change': day_change,
                    'day_change_pct': day_change_pct,
                    'name': info.get('shortName', t),
                    'sector': info.get('sector', 'N/A'),
                    'fetched': True
                }
            except Exception as e:
                results[t] = {'current_price': 0, 'fetched': False, 'error': str(e)}
    except ImportError:
        # yfinance not installed — mark all as not fetched
        for t in tickers:
            results[t] = {'current_price': 0, 'fetched': False, 'error': 'yfinance not installed. Run: pip install yfinance'}
    return results

# ---------------------------------------------------------------------------
# Separate holdings by asset type
# ---------------------------------------------------------------------------
mf_holdings = []
stock_holdings = []
other_holdings = []

for h in holdings:
    asset_type = h.get('asset_type', '').lower()
    if asset_type == 'mf' or h.get('scheme_code'):
        mf_holdings.append(h)
    elif asset_type in ('equity', 'stock', '') and h.get('ticker'):
        stock_holdings.append(h)
    else:
        other_holdings.append(h)

# ---------------------------------------------------------------------------
# Enrich MF holdings
# ---------------------------------------------------------------------------
enriched = []
mf_errors = 0

for h in mf_holdings:
    enriched_h = dict(h)
    scheme_code = h.get('scheme_code', '')
    nav_data = fetch_mf_nav(scheme_code) if scheme_code else None

    if nav_data:
        current_nav = nav_data['nav']
        units = h.get('units', 0)
        current_value = round(units * current_nav, 2)
        cost_value = h.get('value', 0) or h.get('cost_basis', 0)
        absolute_gain = round(current_value - cost_value, 2) if cost_value else 0
        pct_gain = round((absolute_gain / cost_value) * 100, 2) if cost_value and cost_value > 0 else 0

        enriched_h.update({
            'current_nav': current_nav,
            'nav_date': nav_data['date'],
            'current_value': current_value,
            'absolute_gain': absolute_gain,
            'percentage_gain': pct_gain,
            'enriched': True,
            'currency': 'INR'
        })
    else:
        enriched_h.update({
            'current_nav': h.get('nav', 0),
            'current_value': h.get('value', 0),
            'absolute_gain': 0,
            'percentage_gain': 0,
            'enriched': False,
            'note': 'Could not fetch current NAV. Ensure scheme_code is set.',
            'currency': 'INR'
        })
        mf_errors += 1

    enriched.append(enriched_h)

# ---------------------------------------------------------------------------
# Enrich stock holdings
# ---------------------------------------------------------------------------
stock_tickers = [h['ticker'] for h in stock_holdings if h.get('ticker')]
stock_prices = fetch_stock_prices(stock_tickers)
stock_errors = 0

for h in stock_holdings:
    enriched_h = dict(h)
    ticker = h.get('ticker', '')
    price_data = stock_prices.get(ticker, {})

    if price_data.get('fetched'):
        current_price = price_data['current_price']
        shares = h.get('shares', 0)
        current_value = round(current_price * shares, 2)
        cost_basis = h.get('cost_basis', 0)
        absolute_gain = round(current_value - cost_basis, 2) if cost_basis else 0
        pct_gain = round((absolute_gain / cost_basis) * 100, 2) if cost_basis and cost_basis > 0 else 0
        day_change_total = round(price_data.get('day_change', 0) * shares, 2)

        enriched_h.update({
            'current_price': current_price,
            'current_value': current_value,
            'absolute_gain': absolute_gain,
            'percentage_gain': pct_gain,
            'day_change': price_data.get('day_change', 0),
            'day_change_pct': price_data.get('day_change_pct', 0),
            'day_change_total': day_change_total,
            'sector': price_data.get('sector', 'N/A'),
            'enriched': True,
            'currency': 'INR'
        })
    else:
        enriched_h.update({
            'current_price': h.get('avg_price', 0),
            'current_value': h.get('cost_basis', 0),
            'absolute_gain': 0,
            'percentage_gain': 0,
            'day_change': 0,
            'day_change_pct': 0,
            'day_change_total': 0,
            'enriched': False,
            'note': price_data.get('error', 'Could not fetch current price.'),
            'currency': 'INR'
        })
        stock_errors += 1

    enriched.append(enriched_h)

# ---------------------------------------------------------------------------
# Pass through other holdings unenriched
# ---------------------------------------------------------------------------
for h in other_holdings:
    enriched_h = dict(h)
    enriched_h.update({
        'enriched': False,
        'note': 'Enrichment not supported for this asset type yet.',
        'currency': 'INR'
    })
    enriched.append(enriched_h)

# ---------------------------------------------------------------------------
# Build summary
# ---------------------------------------------------------------------------
total_current = round(sum(h.get('current_value', 0) for h in enriched), 2)
total_invested = round(
    sum(h.get('value', 0) or h.get('cost_basis', 0) for h in enriched), 2
)
total_gain = round(total_current - total_invested, 2)
total_gain_pct = round((total_gain / total_invested) * 100, 2) if total_invested > 0 else 0
total_day_change = round(sum(h.get('day_change_total', 0) for h in enriched), 2)

result = {
    'holdings': enriched,
    'summary': {
        'total_current_value': total_current,
        'total_invested': total_invested,
        'total_gain': total_gain,
        'total_gain_pct': total_gain_pct,
        'total_day_change': total_day_change,
        'holdings_count': len(enriched),
        'mf_count': len(mf_holdings),
        'stock_count': len(stock_holdings),
        'enrichment_errors': mf_errors + stock_errors,
        'currency': 'INR'
    },
    'enriched_at': datetime.now().isoformat(),
    'source_file': portfolio_path
}

# Save enriched portfolio
out_path = os.path.join(out_dir, 'enriched-latest.json')
with open(out_path, 'w') as f:
    json.dump(result, f, indent=2)

result['saved_to'] = out_path
print(json.dumps(result, indent=2))
" 2>/dev/null
