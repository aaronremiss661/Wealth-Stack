#!/bin/bash
# Import portfolio from CSV/JSON/PDF
# Usage: import-portfolio.sh FILE_PATH
# Supports:
#   CSV  — Zerodha Console, Groww, Angel One, ICICI Direct, HDFC Securities, custom (ticker,shares,cost_basis)
#   JSON — WealthStack JSON format, Kite Connect API JSON
#   PDF  — CAMS/KFintech CAS statements (delegates to parse-cas-pdf.sh)
# Auto-detects file format and broker from headers/content

FILE=${1:?"Usage: import-portfolio.sh FILE_PATH"}

if [ ! -f "$FILE" ]; then
  echo "{\"error\": \"File not found: $FILE\"}"
  exit 1
fi

mkdir -p ~/.wealthstack/portfolios

# ---------------------------------------------------------------------------
# Detect file format by extension
# ---------------------------------------------------------------------------
EXT="${FILE##*.}"
EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')

# PDF → delegate to parse-cas-pdf.sh
if [ "$EXT_LOWER" = "pdf" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  if [ -f "$SCRIPT_DIR/parse-cas-pdf.sh" ]; then
    exec bash "$SCRIPT_DIR/parse-cas-pdf.sh" "$FILE"
  else
    echo "{\"error\": \"parse-cas-pdf.sh not found in $SCRIPT_DIR. Cannot parse PDF.\"}"
    exit 1
  fi
fi

# CSV or JSON → handle in Python
python3 -c "
import csv, json, sys, os, re
from datetime import datetime

file_path = '''$FILE'''
ext = '''$EXT_LOWER'''
out_dir = os.path.expanduser('~/.wealthstack/portfolios')

# ---------------------------------------------------------------------------
# JSON import
# ---------------------------------------------------------------------------
if ext == 'json':
    try:
        with open(file_path) as f:
            data = json.load(f)

        holdings = []

        # If it's already in WealthStack format
        if 'holdings' in data and isinstance(data['holdings'], list):
            for h in data['holdings']:
                # Normalise: ensure asset_type exists
                if 'asset_type' not in h:
                    if h.get('scheme_code') or h.get('units'):
                        h['asset_type'] = 'mf'
                    elif h.get('ticker') or h.get('shares'):
                        h['asset_type'] = 'equity'
                    else:
                        h['asset_type'] = 'unknown'
                h['currency'] = 'INR'
                holdings.append(h)

        # Kite Connect API format (list of positions/holdings)
        elif isinstance(data, list):
            for item in data:
                ticker = item.get('tradingsymbol', item.get('symbol', ''))
                qty = float(item.get('quantity', item.get('t1_quantity', 0)) or 0)
                avg = float(item.get('average_price', 0) or 0)
                exchange = item.get('exchange', 'NSE')

                if ticker and qty > 0:
                    asset_type = 'equity'
                    if item.get('product', '') in ('MF', 'MUTUAL_FUND'):
                        asset_type = 'mf'

                    holdings.append({
                        'ticker': ticker,
                        'shares': qty,
                        'avg_price': avg,
                        'cost_basis': round(avg * qty, 2),
                        'exchange': exchange,
                        'asset_type': asset_type,
                        'currency': 'INR'
                    })

        portfolio = {
            'holdings': holdings,
            'imported_from': os.path.basename(file_path),
            'imported_at': datetime.now().isoformat(),
            'format': 'json',
            'count': len(holdings)
        }

        out_path = os.path.join(out_dir, 'latest.json')
        with open(out_path, 'w') as out:
            json.dump(portfolio, out, indent=2)

        print(json.dumps({'status': 'success', 'holdings': len(holdings), 'format': 'json', 'saved_to': out_path}, indent=2))
        sys.exit(0)

    except json.JSONDecodeError:
        print(json.dumps({'error': f'Invalid JSON file: {file_path}'}))
        sys.exit(1)
    except Exception as e:
        print(json.dumps({'error': str(e)}))
        sys.exit(1)

# ---------------------------------------------------------------------------
# CSV import — auto-detect broker from headers
# ---------------------------------------------------------------------------
try:
    with open(file_path, encoding='utf-8-sig') as f:
        # Read first few lines to detect format
        first_lines = []
        for _ in range(5):
            line = f.readline()
            if line:
                first_lines.append(line.strip())

    raw_header = first_lines[0] if first_lines else ''
    header_lower = raw_header.lower()

    # -----------------------------------------------------------------------
    # Detect broker / format
    # -----------------------------------------------------------------------
    broker = 'custom'

    # Zerodha Console: tradingsymbol, qty/quantity, average price
    if 'tradingsymbol' in header_lower:
        broker = 'zerodha'

    # Groww: Symbol, Quantity, Avg Cost / LTP
    elif 'stock symbol' in header_lower or ('symbol' in header_lower and 'avg' in header_lower and 'ltp' in header_lower):
        broker = 'groww'

    # Angel One: Symbol, Qty., Buy Avg., Current Value
    elif 'buy avg' in header_lower or 'angel' in header_lower:
        broker = 'angel_one'

    # ICICI Direct: Stock Symbol, Qty, Avg Buy Price, CMP
    elif 'avg buy price' in header_lower or 'icici' in header_lower:
        broker = 'icici_direct'

    # HDFC Securities: Scrip Name, Net Qty, Avg Cost
    elif 'scrip' in header_lower or 'hdfc' in header_lower:
        broker = 'hdfc_securities'

    # MF CAS CSV: Fund Name, Folio, Units, NAV, Value
    elif 'folio' in header_lower and ('units' in header_lower or 'nav' in header_lower):
        broker = 'mf_cas_csv'

    # Detect if it looks like an MF portfolio (AMFI / scheme / fund keywords)
    full_preview = ' '.join(first_lines).lower()
    is_mf_format = ('fund' in full_preview and 'nav' in full_preview) or 'scheme' in full_preview

    # -----------------------------------------------------------------------
    # Parse CSV
    # -----------------------------------------------------------------------
    with open(file_path, encoding='utf-8-sig') as f:
        reader = csv.DictReader(f)
        if not reader.fieldnames:
            print(json.dumps({'error': 'Empty or invalid CSV file.'}))
            sys.exit(1)

        headers = [h.lower().strip() for h in reader.fieldnames]
        holdings = []

        for row in reader:
            rl = {k.lower().strip(): v.strip() for k, v in row.items() if v}

            def get_val(*keys, default=''):
                for k in keys:
                    v = rl.get(k, '').strip()
                    if v:
                        return v
                return default

            def get_num(*keys, default=0):
                for k in keys:
                    v = rl.get(k, '').strip().replace(',', '')
                    if v:
                        try:
                            return float(v)
                        except ValueError:
                            continue
                return default

            # ---------------------------------------------------------------
            # MF CAS CSV format
            # ---------------------------------------------------------------
            if broker == 'mf_cas_csv' or is_mf_format:
                fund_name = get_val('fund name', 'scheme name', 'scheme', 'fund', 'name')
                folio = get_val('folio', 'folio no', 'folio no.', 'folio number')
                units = get_num('units', 'unit balance', 'closing balance', 'balance units')
                nav = get_num('nav', 'latest nav', 'current nav')
                value = get_num('value', 'market value', 'current value', 'valuation')
                scheme_code = get_val('scheme code', 'amfi code', 'code')

                if value == 0 and units > 0 and nav > 0:
                    value = round(units * nav, 2)

                if fund_name and units > 0:
                    holdings.append({
                        'fund_name': fund_name,
                        'folio': folio,
                        'units': units,
                        'nav': nav,
                        'value': round(value, 2),
                        'scheme_code': scheme_code,
                        'asset_type': 'mf',
                        'currency': 'INR'
                    })
                continue

            # ---------------------------------------------------------------
            # Stock / equity CSV formats (all brokers)
            # ---------------------------------------------------------------
            ticker = ''
            shares = 0
            avg_price = 0
            asset_type = 'equity'

            if broker == 'zerodha':
                ticker = get_val('tradingsymbol', 'instrument')
                shares = get_num('qty', 'quantity')
                avg_price = get_num('average price', 'avg. cost', 'avg cost')

            elif broker == 'groww':
                ticker = get_val('stock symbol', 'symbol', 'ticker')
                shares = get_num('quantity', 'qty', 'shares')
                avg_price = get_num('avg cost', 'avg. cost', 'average cost', 'buy average')

            elif broker == 'angel_one':
                ticker = get_val('symbol', 'scrip', 'stock')
                shares = get_num('qty.', 'qty', 'quantity', 'net qty')
                avg_price = get_num('buy avg.', 'buy avg', 'avg price', 'avg. price', 'average price')

            elif broker == 'icici_direct':
                ticker = get_val('stock symbol', 'stock code', 'symbol', 'nse symbol')
                shares = get_num('qty', 'quantity', 'net qty')
                avg_price = get_num('avg buy price', 'avg. buy price', 'purchase price', 'average price')

            elif broker == 'hdfc_securities':
                ticker = get_val('scrip name', 'scrip code', 'symbol', 'stock')
                shares = get_num('net qty', 'quantity', 'qty')
                avg_price = get_num('avg cost', 'avg. cost', 'buy avg', 'average cost')

            else:
                # Generic / custom CSV
                ticker = get_val('ticker', 'symbol', 'tradingsymbol', 'stock symbol', 'scrip', 'stock', 'name')
                shares = get_num('shares', 'quantity', 'qty', 'qty.', 'net qty', 'units')
                avg_price = get_num('cost_basis', 'avg_cost', 'average price', 'avg. cost',
                                    'avg cost', 'buy avg', 'avg price', 'price')

                # Check if this is actually an MF row
                if get_val('scheme code', 'amfi code', 'folio', 'nav'):
                    asset_type = 'mf'

            # Determine asset type from content heuristics
            ticker_upper = ticker.upper()
            if asset_type == 'equity':
                # SGB (Sovereign Gold Bonds)
                if 'SGB' in ticker_upper or 'GOLD' in ticker_upper:
                    asset_type = 'gold'
                # Government securities / bonds
                elif any(kw in ticker_upper for kw in ['GSEC', 'TBILL', 'SDL', 'BOND', 'NCD', 'DEBENTURE']):
                    asset_type = 'debt'
                # ETFs that track gold
                elif 'GOLDBEES' in ticker_upper or 'GOLDCASE' in ticker_upper:
                    asset_type = 'gold'

            if ticker and shares > 0:
                holding = {
                    'ticker': ticker.replace(' ', ''),
                    'shares': shares,
                    'cost_basis': round(avg_price * shares, 2),
                    'avg_price': avg_price,
                    'asset_type': asset_type,
                    'currency': 'INR'
                }
                holdings.append(holding)

        # -------------------------------------------------------------------
        # Build output
        # -------------------------------------------------------------------
        # Count by asset type
        type_counts = {}
        for h in holdings:
            at = h.get('asset_type', 'unknown')
            type_counts[at] = type_counts.get(at, 0) + 1

        portfolio = {
            'holdings': holdings,
            'imported_from': os.path.basename(file_path),
            'imported_at': datetime.now().isoformat(),
            'broker': broker,
            'format': 'csv',
            'count': len(holdings),
            'asset_type_breakdown': type_counts
        }

        out_path = os.path.join(out_dir, 'latest.json')
        with open(out_path, 'w') as out:
            json.dump(portfolio, out, indent=2)

        print(json.dumps({
            'status': 'success',
            'holdings': len(holdings),
            'broker': broker,
            'format': 'csv',
            'asset_types': type_counts,
            'saved_to': out_path
        }, indent=2))

except FileNotFoundError:
    print(json.dumps({'error': f'File not found: {file_path}'}))
except Exception as e:
    print(json.dumps({'error': str(e)}))
"
