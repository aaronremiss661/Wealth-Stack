#!/bin/bash
# Portfolio Drift Detection and Rebalancing Trade Generator
# Usage: drift-analyzer.sh [PORTFOLIO_JSON] [TARGET_JSON] [MODE] [THRESHOLD]
# Modes: full-rebalance | cash-only | threshold-only
# Example: drift-analyzer.sh ~/.wealthstack/portfolios/enriched-latest.json ~/.wealthstack/target-allocation.json full-rebalance 5

PORTFOLIO=${1:-~/.wealthstack/portfolios/enriched-latest.json}
TARGET=${2:-~/.wealthstack/target-allocation.json}
MODE=${3:-threshold-only}
THRESHOLD=${4:-5}

python3 -c "
import json, sys, math

mode = '$MODE'
threshold = $THRESHOLD

try:
    with open('$PORTFOLIO') as f:
        portfolio = json.load(f)
except FileNotFoundError:
    print(json.dumps({'error': 'Portfolio file not found: $PORTFOLIO', 'hint': 'Run import-portfolio.sh first'}))
    sys.exit(1)

try:
    with open('$TARGET') as f:
        target_data = json.load(f)
except FileNotFoundError:
    print(json.dumps({'error': 'Target allocation file not found: $TARGET', 'hint': 'Create target-allocation.json with: {allocations: [{asset_class, target_pct, tickers: [{ticker, weight}]}]}'}))
    sys.exit(1)

try:
    holdings = portfolio.get('holdings', [])
    target_allocs = target_data.get('allocations', [])
    new_cash = target_data.get('new_cash', 0)

    # Build ticker-to-asset-class mapping and target percentages
    ticker_to_class = {}
    ticker_to_weight = {}
    target_by_class = {}

    for alloc in target_allocs:
        ac = alloc['asset_class']
        target_by_class[ac] = alloc['target_pct']
        for t in alloc.get('tickers', []):
            ticker_to_class[t['ticker']] = ac
            ticker_to_weight[t['ticker']] = t.get('weight', 0)

    # Calculate current portfolio value and allocation
    total_value = 0
    holdings_by_class = {}
    ticker_values = {}

    for h in holdings:
        ticker = h['ticker']
        shares = h.get('shares', 0)
        price = h.get('current_price', h.get('avg_price', 0))
        value = shares * price
        total_value += value
        ticker_values[ticker] = {'shares': shares, 'price': price, 'value': round(value, 2)}

        ac = ticker_to_class.get(ticker, 'unclassified')
        if ac not in holdings_by_class:
            holdings_by_class[ac] = 0
        holdings_by_class[ac] += value

    if total_value == 0:
        print(json.dumps({'error': 'Portfolio value is zero. Check holdings data.'}))
        sys.exit(1)

    # Compute current allocation percentages
    current_allocation = {}
    for ac in set(list(target_by_class.keys()) + list(holdings_by_class.keys())):
        current_allocation[ac] = round((holdings_by_class.get(ac, 0) / total_value) * 100, 2)

    # Compute drift
    drift = []
    max_drift = 0
    needs_rebalance = False

    for ac in target_by_class:
        target_pct = target_by_class[ac]
        current_pct = current_allocation.get(ac, 0)
        drift_pct = round(current_pct - target_pct, 2)
        abs_drift = abs(drift_pct)
        max_drift = max(max_drift, abs_drift)

        if abs_drift > threshold:
            needs_rebalance = True
            action = 'sell (overweight)' if drift_pct > 0 else 'buy (underweight)'
        else:
            action = 'within threshold'

        drift.append({
            'asset_class': ac,
            'target_pct': target_pct,
            'current_pct': current_pct,
            'drift_pct': drift_pct,
            'abs_drift_pct': abs_drift,
            'action': action
        })

    # Handle unclassified holdings
    unclass_pct = current_allocation.get('unclassified', 0)
    if unclass_pct > 0:
        drift.append({
            'asset_class': 'unclassified',
            'target_pct': 0,
            'current_pct': unclass_pct,
            'drift_pct': unclass_pct,
            'abs_drift_pct': unclass_pct,
            'action': 'review — not in target allocation'
        })

    drift.sort(key=lambda x: x['abs_drift_pct'], reverse=True)

    # Generate rebalancing trades
    trades = []
    rebalance_value = total_value + new_cash if mode == 'cash-only' else total_value

    if mode == 'full-rebalance':
        # Full rebalance: adjust every position to target
        for alloc in target_allocs:
            ac = alloc['asset_class']
            target_value = rebalance_value * (alloc['target_pct'] / 100)
            current_value = holdings_by_class.get(ac, 0)
            diff = target_value - current_value

            for t in alloc.get('tickers', []):
                ticker = t['ticker']
                weight = t.get('weight', 100) / 100
                ticker_diff = diff * weight
                tv = ticker_values.get(ticker, {'shares': 0, 'price': 0, 'value': 0})
                price = tv['price']

                if price > 0 and abs(ticker_diff) > 100:
                    shares_to_trade = ticker_diff / price
                    trades.append({
                        'ticker': ticker,
                        'asset_class': ac,
                        'action': 'BUY' if ticker_diff > 0 else 'SELL',
                        'shares': abs(round(shares_to_trade, 2)),
                        'amount': abs(round(ticker_diff, 2)),
                        'price': price
                    })

    elif mode == 'cash-only':
        # Deploy new cash to underweight asset classes only
        if new_cash <= 0:
            trades.append({'note': 'No new cash specified. Set new_cash in target-allocation.json.'})
        else:
            # Find underweight classes
            underweight = []
            total_under = 0
            for alloc in target_allocs:
                ac = alloc['asset_class']
                target_pct = alloc['target_pct']
                current_pct = current_allocation.get(ac, 0)
                if current_pct < target_pct:
                    gap = target_pct - current_pct
                    underweight.append({'alloc': alloc, 'gap': gap})
                    total_under += gap

            for uw in underweight:
                alloc = uw['alloc']
                # Allocate cash proportional to how underweight each class is
                cash_share = new_cash * (uw['gap'] / total_under) if total_under > 0 else 0

                for t in alloc.get('tickers', []):
                    ticker = t['ticker']
                    weight = t.get('weight', 100) / 100
                    amount = cash_share * weight
                    tv = ticker_values.get(ticker, {'price': 0})
                    price = tv['price']

                    if price > 0 and amount > 100:
                        shares_to_buy = amount / price
                        trades.append({
                            'ticker': ticker,
                            'asset_class': alloc['asset_class'],
                            'action': 'BUY',
                            'shares': round(shares_to_buy, 2),
                            'amount': round(amount, 2),
                            'price': price
                        })

    elif mode == 'threshold-only':
        # Only rebalance asset classes that breach the threshold
        for alloc in target_allocs:
            ac = alloc['asset_class']
            target_pct = alloc['target_pct']
            current_pct = current_allocation.get(ac, 0)
            drift_pct = current_pct - target_pct

            if abs(drift_pct) <= threshold:
                continue

            target_value = rebalance_value * (target_pct / 100)
            current_value = holdings_by_class.get(ac, 0)
            diff = target_value - current_value

            for t in alloc.get('tickers', []):
                ticker = t['ticker']
                weight = t.get('weight', 100) / 100
                ticker_diff = diff * weight
                tv = ticker_values.get(ticker, {'shares': 0, 'price': 0, 'value': 0})
                price = tv['price']

                if price > 0 and abs(ticker_diff) > 100:
                    shares_to_trade = ticker_diff / price
                    trades.append({
                        'ticker': ticker,
                        'asset_class': ac,
                        'action': 'BUY' if ticker_diff > 0 else 'SELL',
                        'shares': abs(round(shares_to_trade, 2)),
                        'amount': abs(round(ticker_diff, 2)),
                        'price': price
                    })

    result = {
        'portfolio_value': round(total_value, 2),
        'current_allocation': {ac: round(pct, 2) for ac, pct in sorted(current_allocation.items())},
        'target_allocation': {ac: pct for ac, pct in sorted(target_by_class.items())},
        'drift': drift,
        'trades': trades,
        'mode': mode,
        'threshold_pct': threshold,
        'summary': {
            'max_drift_pct': round(max_drift, 2),
            'needs_rebalance': needs_rebalance,
            'num_trades': len([t for t in trades if 'action' in t and t['action'] in ('BUY', 'SELL')]),
            'total_buy_amount': round(sum(t['amount'] for t in trades if t.get('action') == 'BUY'), 2),
            'total_sell_amount': round(sum(t['amount'] for t in trades if t.get('action') == 'SELL'), 2)
        },
        'files': {
            'portfolio': '$PORTFOLIO',
            'target': '$TARGET'
        },
        'currency': 'INR'
    }
    print(json.dumps(result, indent=2))

except Exception as e:
    print(json.dumps({'error': str(e)}))
"
