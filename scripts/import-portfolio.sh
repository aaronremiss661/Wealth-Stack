#!/bin/bash
# Import portfolio from CSV/JSON
# Usage: import-portfolio.sh FILE_PATH
# Supports: Zerodha Console CSV, Groww CSV, custom CSV (ticker,shares,cost_basis)

FILE=${1:?"Usage: import-portfolio.sh FILE_PATH"}
mkdir -p ~/.wealthstack/portfolios

python3 -c "
import csv, json, sys, os
from datetime import datetime

file_path = '$FILE'
try:
    with open(file_path) as f:
        reader = csv.DictReader(f)
        headers = [h.lower().strip() for h in reader.fieldnames]
        
        holdings = []
        for row in reader:
            row_lower = {k.lower().strip(): v.strip() for k, v in row.items()}
            
            # Try common CSV formats
            ticker = row_lower.get('ticker') or row_lower.get('symbol') or row_lower.get('tradingsymbol') or row_lower.get('stock symbol', '')
            shares = float(row_lower.get('shares') or row_lower.get('quantity') or row_lower.get('qty') or 0)
            cost = float(row_lower.get('cost_basis') or row_lower.get('avg_cost') or row_lower.get('average price') or row_lower.get('avg. cost') or 0)
            
            if ticker and shares > 0:
                holdings.append({
                    'ticker': ticker.replace(' ', ''),
                    'shares': shares,
                    'cost_basis': round(cost * shares, 2),
                    'avg_price': cost
                })
        
        portfolio = {
            'holdings': holdings,
            'imported_from': os.path.basename(file_path),
            'imported_at': datetime.now().isoformat(),
            'count': len(holdings)
        }
        
        out_path = os.path.expanduser('~/.wealthstack/portfolios/latest.json')
        with open(out_path, 'w') as out:
            json.dump(portfolio, out, indent=2)
        
        print(json.dumps({'status': 'success', 'holdings': len(holdings), 'saved_to': out_path}, indent=2))

except FileNotFoundError:
    print(json.dumps({'error': f'File not found: {file_path}'}))
except Exception as e:
    print(json.dumps({'error': str(e)}))
"
