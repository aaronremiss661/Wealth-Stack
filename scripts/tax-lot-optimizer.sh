#!/bin/bash
# Tax-Lot Capital Gains Optimizer for Indian investors
# Analyzes FIFO, LIFO, and specific-lot methods to minimize capital gains tax
# Usage: tax-lot-optimizer.sh [PORTFOLIO_JSON_PATH]
# Portfolio JSON format: {holdings: [{ticker, asset_type, lots: [{buy_date, buy_price, shares}], current_price}]}

FILE=${1:-~/.wealthstack/portfolios/latest.json}

python3 -c "
import json, sys
from datetime import datetime, timedelta

today = datetime.now()

def holding_months(buy_date_str):
    buy = datetime.strptime(buy_date_str, '%Y-%m-%d')
    return (today.year - buy.year) * 12 + (today.month - buy.month)

def classify_lot(lot, asset_type):
    months = holding_months(lot['buy_date'])
    if asset_type == 'debt':
        return ('LTCG', months) if months > 24 else ('STCG', months)
    else:
        # equity, mutual_fund (equity-oriented)
        return ('LTCG', months) if months > 12 else ('STCG', months)

def calc_tax(gain, tax_type, asset_type, cumulative_ltcg):
    if gain <= 0:
        return 0, cumulative_ltcg
    if tax_type == 'LTCG':
        if asset_type in ('equity', 'mutual_fund'):
            # LTCG equity: 12.5% above Rs 1.25L exemption
            exempt = max(0, 125000 - cumulative_ltcg)
            taxable = max(0, gain - exempt)
            cumulative_ltcg += gain
            return round(taxable * 0.125), cumulative_ltcg
        else:
            # Debt LTCG: taxed at slab (approximate 30% for high bracket)
            cumulative_ltcg += gain
            return round(gain * 0.20), cumulative_ltcg
    else:
        # STCG
        if asset_type in ('equity', 'mutual_fund'):
            return round(gain * 0.20), cumulative_ltcg
        else:
            # Debt STCG: at slab rate (approximate 30%)
            return round(gain * 0.30), cumulative_ltcg

def detect_wash_sales(holdings):
    \"\"\"Detect lots where a repurchase happened within 30 days of a loss sale.\"\"\"
    wash = []
    for h in holdings:
        lots = sorted(h.get('lots', []), key=lambda x: x['buy_date'])
        for i, lot in enumerate(lots):
            gain = (h['current_price'] - lot['buy_price']) * lot['shares']
            if gain < 0:
                sell_date = today
                for j, other in enumerate(lots):
                    if i == j:
                        continue
                    buy_dt = datetime.strptime(other['buy_date'], '%Y-%m-%d')
                    days_diff = abs((buy_dt - sell_date).days)
                    if days_diff <= 30 and buy_dt >= sell_date - timedelta(days=30):
                        wash.append({
                            'ticker': h['ticker'],
                            'loss_lot_date': lot['buy_date'],
                            'repurchase_date': other['buy_date'],
                            'disallowed_loss': round(abs(gain), 2)
                        })
    return wash

def process_method(holdings, method):
    all_lots = []
    cumulative_ltcg = 0
    total_ltcg = 0
    total_stcg = 0
    total_tax = 0

    for h in holdings:
        ticker = h['ticker']
        asset_type = h.get('asset_type', 'equity')
        current_price = h['current_price']
        lots = list(h.get('lots', []))

        if method == 'FIFO':
            lots.sort(key=lambda x: x['buy_date'])
        elif method == 'LIFO':
            lots.sort(key=lambda x: x['buy_date'], reverse=True)
        elif method == 'SPECIFIC':
            # Specific-lot: sell LTCG lots first (lower tax), then loss lots, then STCG
            def sort_key(lot):
                tax_type, months = classify_lot(lot, asset_type)
                gain = (current_price - lot['buy_price']) * lot['shares']
                # Priority: 1) losses first (gain < 0), 2) LTCG, 3) STCG
                if gain < 0:
                    return (0, gain)
                elif tax_type == 'LTCG':
                    return (1, gain)
                else:
                    return (2, -gain)
            lots.sort(key=sort_key)

        for lot in lots:
            tax_type, months = classify_lot(lot, asset_type)
            gain = round((current_price - lot['buy_price']) * lot['shares'], 2)
            tax_amount, cumulative_ltcg = calc_tax(gain, tax_type, asset_type, cumulative_ltcg)

            if tax_type == 'LTCG':
                total_ltcg += gain
            else:
                total_stcg += gain
            total_tax += tax_amount

            all_lots.append({
                'ticker': ticker,
                'asset_type': asset_type,
                'buy_date': lot['buy_date'],
                'buy_price': lot['buy_price'],
                'shares': lot['shares'],
                'current_price': current_price,
                'holding_months': months,
                'gain': gain,
                'tax_type': tax_type,
                'tax_amount': tax_amount
            })

    return {
        'lots': all_lots,
        'total_ltcg': round(total_ltcg, 2),
        'total_stcg': round(total_stcg, 2),
        'total_tax': round(total_tax, 2)
    }

try:
    with open('$FILE') as f:
        portfolio = json.load(f)

    holdings = portfolio.get('holdings', [])

    # Run all three methods
    fifo = process_method(holdings, 'FIFO')
    lifo = process_method(holdings, 'LIFO')
    specific = process_method(holdings, 'SPECIFIC')

    # Find optimal
    methods = {'FIFO': fifo, 'LIFO': lifo, 'SPECIFIC': specific}
    optimal = min(methods, key=lambda m: methods[m]['total_tax'])

    # Detect wash sales
    wash_sales = detect_wash_sales(holdings)

    result = {
        'method': optimal,
        'lots': methods[optimal]['lots'],
        'summary': {
            'total_ltcg': methods[optimal]['total_ltcg'],
            'total_stcg': methods[optimal]['total_stcg'],
            'total_tax': methods[optimal]['total_tax'],
            'savings_vs_fifo': round(fifo['total_tax'] - methods[optimal]['total_tax'], 2)
        },
        'comparison': {
            'FIFO_tax': fifo['total_tax'],
            'LIFO_tax': lifo['total_tax'],
            'SPECIFIC_tax': specific['total_tax']
        },
        'wash_sales': wash_sales,
        'file': '$FILE',
        'note': 'LTCG equity: 12.5% above Rs 1.25L exemption. STCG equity: 20%. Debt at slab rates.'
    }
    print(json.dumps(result, indent=2))

except FileNotFoundError:
    print(json.dumps({'error': 'Portfolio file not found: $FILE', 'hint': 'Create portfolio JSON with holdings array containing lots'}))
except Exception as e:
    print(json.dumps({'error': str(e)}))
"
