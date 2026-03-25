#!/bin/bash
# Portfolio Alert Scanner — Automated health checks with actionable alerts
# Usage: check-alerts.sh [PORTFOLIO_JSON] [--threshold PCT] [--output FILE]
# Scans for: drift, concentration, tax harvesting, NAV drops, SIP reminders

PORTFOLIO=${1:-~/.wealthstack/portfolios/enriched-latest.json}
THRESHOLD=${2:-5}

python3 -c "
import json, sys, os
from datetime import datetime, timedelta

portfolio_path = os.path.expanduser('$PORTFOLIO')
drift_threshold = $THRESHOLD

def load_json(path):
    try:
        with open(os.path.expanduser(path)) as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return None

portfolio = load_json(portfolio_path)
if not portfolio:
    print(json.dumps({'error': f'Portfolio not found: {portfolio_path}', 'hint': 'Run import-portfolio.sh and enrich-portfolio.sh first'}))
    sys.exit(1)

target = load_json('~/.wealthstack/target-allocation.json')
alerts = []

holdings = portfolio.get('holdings', [])
total_value = sum(h.get('current_value', h.get('cost_basis', 0)) for h in holdings)

# === ALERT 1: Concentration Risk ===
for h in holdings:
    value = h.get('current_value', h.get('cost_basis', 0))
    if total_value > 0:
        weight = (value / total_value) * 100
        if weight > 20:
            alerts.append({
                'type': 'CONCENTRATION_CRITICAL',
                'severity': 'high',
                'ticker': h.get('ticker', 'Unknown'),
                'message': f\"{h.get('ticker', 'Unknown')} is {weight:.1f}% of portfolio (limit: 20%)\",
                'weight_pct': round(weight, 1),
                'action': f\"Consider trimming {h.get('ticker', 'Unknown')} to below 20% — sell {round(value - total_value * 0.20)} worth\"
            })
        elif weight > 10:
            alerts.append({
                'type': 'CONCENTRATION_WARNING',
                'severity': 'medium',
                'ticker': h.get('ticker', 'Unknown'),
                'message': f\"{h.get('ticker', 'Unknown')} is {weight:.1f}% of portfolio (watch: 10%)\",
                'weight_pct': round(weight, 1),
                'action': f\"Monitor {h.get('ticker', 'Unknown')} — approaching concentration limit\"
            })

# === ALERT 2: Top 5 Concentration ===
sorted_holdings = sorted(holdings, key=lambda h: h.get('current_value', h.get('cost_basis', 0)), reverse=True)
if len(sorted_holdings) >= 5 and total_value > 0:
    top5_value = sum(h.get('current_value', h.get('cost_basis', 0)) for h in sorted_holdings[:5])
    top5_pct = (top5_value / total_value) * 100
    if top5_pct > 50:
        alerts.append({
            'type': 'TOP5_CONCENTRATION',
            'severity': 'medium',
            'message': f'Top 5 holdings are {top5_pct:.1f}% of portfolio (limit: 50%)',
            'top5_pct': round(top5_pct, 1),
            'action': 'Diversify into additional holdings to reduce top-heavy risk'
        })

# === ALERT 3: Drift from Target Allocation ===
if target:
    # Group holdings by asset class
    current_alloc = {}
    for h in holdings:
        asset_type = h.get('asset_type', 'equity')
        value = h.get('current_value', h.get('cost_basis', 0))
        current_alloc[asset_type] = current_alloc.get(asset_type, 0) + value

    for asset_class, target_pct in target.items():
        current_value = current_alloc.get(asset_class, 0)
        current_pct = (current_value / total_value * 100) if total_value > 0 else 0
        drift = abs(current_pct - target_pct)
        if drift > drift_threshold:
            direction = 'overweight' if current_pct > target_pct else 'underweight'
            alerts.append({
                'type': 'ALLOCATION_DRIFT',
                'severity': 'high' if drift > 10 else 'medium',
                'asset_class': asset_class,
                'message': f'{asset_class} is {direction} by {drift:.1f}% (target: {target_pct}%, current: {current_pct:.1f}%)',
                'target_pct': target_pct,
                'current_pct': round(current_pct, 1),
                'drift_pct': round(drift, 1),
                'action': f\"{'Sell' if direction == 'overweight' else 'Buy'} {asset_class} to rebalance\"
            })

# === ALERT 4: Tax-Loss Harvesting Opportunities ===
for h in holdings:
    cost = h.get('cost_basis', 0)
    current = h.get('current_value', cost)
    gain_pct = ((current - cost) / cost * 100) if cost > 0 else 0
    if gain_pct < -10:
        buy_date = h.get('buy_date', '')
        holding_months = 0
        if buy_date:
            try:
                bd = datetime.strptime(buy_date, '%Y-%m-%d')
                holding_months = (datetime.now() - bd).days / 30
            except:
                pass

        alerts.append({
            'type': 'TAX_HARVEST_OPPORTUNITY',
            'severity': 'low',
            'ticker': h.get('ticker', 'Unknown'),
            'message': f\"{h.get('ticker', 'Unknown')} is down {abs(gain_pct):.1f}% — potential tax-loss harvest\",
            'loss_amount': round(current - cost),
            'loss_pct': round(gain_pct, 1),
            'action': f\"Sell {h.get('ticker', 'Unknown')} to book loss of Rs {abs(round(current - cost)):,}, buy back after 30 days or switch to similar fund\"
        })

# === ALERT 5: NAV Drop Alert (>10% from recent high) ===
for h in holdings:
    high_52w = h.get('52w_high', 0)
    current_price = h.get('current_price', h.get('nav', 0))
    if high_52w > 0 and current_price > 0:
        drop_pct = ((current_price - high_52w) / high_52w) * 100
        if drop_pct < -10:
            alerts.append({
                'type': 'NAV_DROP',
                'severity': 'medium' if drop_pct > -20 else 'high',
                'ticker': h.get('ticker', 'Unknown'),
                'message': f\"{h.get('ticker', 'Unknown')} is {abs(drop_pct):.1f}% below 52-week high\",
                'drop_from_high_pct': round(drop_pct, 1),
                'action': 'Review if fundamentals have changed — could be buying opportunity or exit signal'
            })

# === ALERT 6: SIP Date Reminder ===
today = datetime.now()
if today.day <= 5 or today.day >= 28:
    alerts.append({
        'type': 'SIP_REMINDER',
        'severity': 'info',
        'message': f'SIP processing window — ensure sufficient balance in bank account',
        'action': 'Check bank balance for upcoming SIP debits (typically 1st-5th of month)'
    })

# === ALERT 7: Portfolio Age / Staleness ===
imported_at = portfolio.get('imported_at', portfolio.get('enriched_at', ''))
if imported_at:
    try:
        import_date = datetime.fromisoformat(imported_at.replace('Z', '+00:00').replace('+00:00', ''))
        days_old = (datetime.now() - import_date).days
        if days_old > 30:
            alerts.append({
                'type': 'STALE_DATA',
                'severity': 'medium',
                'message': f'Portfolio data is {days_old} days old — prices may be outdated',
                'days_old': days_old,
                'action': 'Run enrich-portfolio.sh to refresh current prices'
            })
    except:
        pass

# === Summary ===
high_alerts = [a for a in alerts if a.get('severity') == 'high']
medium_alerts = [a for a in alerts if a.get('severity') == 'medium']
low_alerts = [a for a in alerts if a.get('severity') == 'low']
info_alerts = [a for a in alerts if a.get('severity') == 'info']

result = {
    'scan_date': datetime.now().isoformat(),
    'portfolio_file': portfolio_path,
    'total_value': round(total_value),
    'holdings_count': len(holdings),
    'alerts': alerts,
    'summary': {
        'total_alerts': len(alerts),
        'high': len(high_alerts),
        'medium': len(medium_alerts),
        'low': len(low_alerts),
        'info': len(info_alerts),
        'health_score': max(0, 100 - len(high_alerts) * 20 - len(medium_alerts) * 10 - len(low_alerts) * 5),
        'needs_attention': len(high_alerts) > 0
    }
}

# Save alert report
os.makedirs(os.path.expanduser('~/.wealthstack/reports'), exist_ok=True)
report_path = os.path.expanduser('~/.wealthstack/reports/alerts-latest.json')
with open(report_path, 'w') as f:
    json.dump(result, f, indent=2)

print(json.dumps(result, indent=2))
"
