#!/bin/bash
# XIRR Calculator for portfolio returns
# Usage: portfolio-xirr.sh PORTFOLIO_JSON_PATH

FILE=${1:-~/.wealthstack/portfolios/latest.json}

python3 -c "
import json, sys
from datetime import datetime

try:
    from scipy.optimize import brentq
except ImportError:
    print(json.dumps({'error': 'scipy not installed. Run: pip install scipy'}))
    sys.exit(1)

def xirr(cashflows):
    # cashflows: list of (date, amount) tuples
    if not cashflows:
        return 0
    dates = [cf[0] for cf in cashflows]
    amounts = [cf[1] for cf in cashflows]
    years = [(d - dates[0]).days / 365.0 for d in dates]
    
    def npv(rate):
        return sum(a / (1 + rate) ** y for a, y in zip(amounts, years))
    
    try:
        return round(brentq(npv, -0.99, 10.0) * 100, 2)
    except:
        return 0

try:
    with open('$FILE') as f:
        portfolio = json.load(f)
    # Expect: {cashflows: [{date: 'YYYY-MM-DD', amount: -10000}, ...]}
    cfs = [(datetime.strptime(cf['date'], '%Y-%m-%d'), cf['amount']) for cf in portfolio.get('cashflows', [])]
    result = {'xirr_pct': xirr(cfs), 'file': '$FILE'}
    print(json.dumps(result, indent=2))
except FileNotFoundError:
    print(json.dumps({'error': 'Portfolio file not found: $FILE'}))
except Exception as e:
    print(json.dumps({'error': str(e)}))
"
