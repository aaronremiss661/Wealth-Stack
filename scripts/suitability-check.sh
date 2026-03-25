#!/bin/bash
# SEBI Suitability Check — Verify recommendations match client risk profile
# Usage: suitability-check.sh [CLIENT_ID] [RECOMMENDATION_JSON]
# Checks: risk alignment, concentration, regulatory limits, product suitability

CLIENT_ID=${1:-}
RECOMMENDATION=${2:-}

python3 -c "
import json, sys, os
from datetime import datetime

client_id = '$CLIENT_ID'
recommendation_path = '$RECOMMENDATION'

base_dir = os.path.expanduser('~/.wealthstack/clients')
active_file = os.path.expanduser('~/.wealthstack/active-client.json')

# Get active client if not specified
if not client_id:
    try:
        with open(active_file) as f:
            active = json.load(f)
            client_id = active.get('client_id')
    except:
        pass

if not client_id:
    print(json.dumps({'error': 'No client specified and no active client. Use: suitability-check.sh CLIENT_ID'}))
    sys.exit(1)

# Load client profile
profile_path = os.path.join(base_dir, client_id, 'profile.json')
try:
    with open(profile_path) as f:
        profile = json.load(f)
except FileNotFoundError:
    print(json.dumps({'error': f'Client profile not found: {client_id}'}))
    sys.exit(1)

# Load portfolio if exists
portfolio = None
portfolio_path = os.path.join(base_dir, client_id, 'portfolios', 'latest.json')
if not os.path.exists(portfolio_path):
    portfolio_path = os.path.expanduser('~/.wealthstack/portfolios/latest.json')
try:
    with open(portfolio_path) as f:
        portfolio = json.load(f)
except:
    pass

# Load recommendation if provided
recommendation = None
if recommendation_path:
    try:
        with open(recommendation_path) as f:
            recommendation = json.load(f)
    except:
        pass

risk_profile = profile.get('risk_profile', 'Not assessed').lower()
age = profile.get('age', 0)
residential_status = profile.get('residential_status', 'Resident')
annual_income = profile.get('annual_income', 0)
investment_horizon = profile.get('investment_horizon', 'Not set')
existing_investments = profile.get('existing_investments', 0)

checks = []
passed = 0
failed = 0
warnings = 0

# === CHECK 1: Risk Profile Assessment ===
if risk_profile == 'not assessed':
    checks.append({
        'check': 'Risk Profile Assessment',
        'status': 'FAIL',
        'message': 'Client risk profile has not been assessed',
        'action': 'Complete risk profiling questionnaire before making any recommendations',
        'regulation': 'SEBI RIA Regulations 2020 — Regulation 16(c)'
    })
    failed += 1
else:
    checks.append({
        'check': 'Risk Profile Assessment',
        'status': 'PASS',
        'message': f'Risk profile: {risk_profile}',
        'regulation': 'SEBI RIA Regulations 2020'
    })
    passed += 1

# === CHECK 2: Age-Based Allocation ===
if portfolio and age > 0:
    holdings = portfolio.get('holdings', [])
    total_value = sum(h.get('current_value', h.get('cost_basis', 0)) for h in holdings)
    equity_value = sum(h.get('current_value', h.get('cost_basis', 0)) for h in holdings if h.get('asset_type', 'equity') == 'equity')
    equity_pct = (equity_value / total_value * 100) if total_value > 0 else 0

    # Rule of thumb: equity should be approximately (100 - age)%
    max_equity = min(90, 110 - age)
    if equity_pct > max_equity + 10:  # 10% tolerance
        checks.append({
            'check': 'Age-Based Equity Allocation',
            'status': 'WARN',
            'message': f'Equity at {equity_pct:.0f}% is high for age {age} (guideline: ~{max_equity}%)',
            'action': f'Consider reducing equity to {max_equity}% for age-appropriate risk',
            'regulation': 'SEBI Suitability Framework'
        })
        warnings += 1
    else:
        checks.append({
            'check': 'Age-Based Equity Allocation',
            'status': 'PASS',
            'message': f'Equity at {equity_pct:.0f}% is appropriate for age {age}'
        })
        passed += 1

# === CHECK 3: Risk-Allocation Alignment ===
if portfolio and risk_profile != 'not assessed':
    holdings = portfolio.get('holdings', [])
    total_value = sum(h.get('current_value', h.get('cost_basis', 0)) for h in holdings)
    equity_value = sum(h.get('current_value', h.get('cost_basis', 0)) for h in holdings if h.get('asset_type', 'equity') == 'equity')
    equity_pct = (equity_value / total_value * 100) if total_value > 0 else 0

    risk_limits = {
        'conservative': {'max_equity': 40, 'min_debt': 45},
        'moderate': {'max_equity': 70, 'min_debt': 20},
        'aggressive': {'max_equity': 90, 'min_debt': 5},
        'very aggressive': {'max_equity': 100, 'min_debt': 0}
    }

    limits = risk_limits.get(risk_profile, risk_limits['moderate'])
    if equity_pct > limits['max_equity']:
        checks.append({
            'check': 'Risk-Allocation Alignment',
            'status': 'FAIL',
            'message': f'Equity {equity_pct:.0f}% exceeds {risk_profile} limit of {limits[\"max_equity\"]}%',
            'action': f'Reduce equity to below {limits[\"max_equity\"]}% for {risk_profile} profile',
            'regulation': 'SEBI RIA Regulations — Suitability requirement'
        })
        failed += 1
    else:
        checks.append({
            'check': 'Risk-Allocation Alignment',
            'status': 'PASS',
            'message': f'Equity {equity_pct:.0f}% within {risk_profile} limit ({limits[\"max_equity\"]}%)'
        })
        passed += 1

# === CHECK 4: Concentration Limits ===
if portfolio:
    holdings = portfolio.get('holdings', [])
    total_value = sum(h.get('current_value', h.get('cost_basis', 0)) for h in holdings)
    for h in holdings:
        value = h.get('current_value', h.get('cost_basis', 0))
        if total_value > 0:
            weight = (value / total_value) * 100
            if weight > 25:
                checks.append({
                    'check': f'Concentration — {h.get(\"ticker\", \"Unknown\")}',
                    'status': 'FAIL',
                    'message': f'{h.get(\"ticker\", \"Unknown\")} at {weight:.1f}% exceeds 25% single-stock limit',
                    'action': 'Reduce position to below 25% of portfolio',
                    'regulation': 'SEBI Prudential norms'
                })
                failed += 1

# === CHECK 5: PMS Minimum Check ===
if portfolio and recommendation:
    for rec in recommendation.get('products', []):
        if rec.get('type') == 'PMS' and rec.get('amount', 0) < 5000000:
            checks.append({
                'check': 'PMS Minimum Investment',
                'status': 'FAIL',
                'message': f'PMS recommendation of Rs {rec.get(\"amount\", 0):,.0f} is below SEBI minimum of Rs 50L',
                'regulation': 'SEBI PMS Regulations — Minimum Rs 50,00,000'
            })
            failed += 1

        if rec.get('type') == 'AIF' and rec.get('amount', 0) < 10000000:
            checks.append({
                'check': 'AIF Minimum Investment',
                'status': 'FAIL',
                'message': f'AIF recommendation of Rs {rec.get(\"amount\", 0):,.0f} is below SEBI minimum of Rs 1Cr',
                'regulation': 'SEBI AIF Regulations — Minimum Rs 1,00,00,000'
            })
            failed += 1

# === CHECK 6: NRI Restrictions ===
if residential_status.upper() in ('NRI', 'RNOR'):
    checks.append({
        'check': 'NRI Status Flag',
        'status': 'WARN',
        'message': 'Client is NRI — additional FEMA/RBI restrictions apply',
        'action': 'Verify: PIS route for equity, MF investment restrictions, repatriation limits, DTAA applicability',
        'regulation': 'FEMA 1999, RBI Master Directions on NRI investments'
    })
    warnings += 1

# === CHECK 7: Investment Horizon Match ===
if investment_horizon and investment_horizon != 'Not set':
    horizon_years = {'short': 3, 'medium': 7, 'long': 15}.get(investment_horizon.lower(), 0)
    if portfolio and horizon_years > 0:
        holdings = portfolio.get('holdings', [])
        total_value = sum(h.get('current_value', h.get('cost_basis', 0)) for h in holdings)
        equity_value = sum(h.get('current_value', h.get('cost_basis', 0)) for h in holdings if h.get('asset_type', 'equity') == 'equity')
        equity_pct = (equity_value / total_value * 100) if total_value > 0 else 0

        if horizon_years <= 3 and equity_pct > 40:
            checks.append({
                'check': 'Horizon-Equity Match',
                'status': 'FAIL',
                'message': f'Equity at {equity_pct:.0f}% is too high for {horizon_years}-year horizon',
                'action': 'Short-term horizon should have max 30-40% equity',
                'regulation': 'SEBI Suitability — investment time horizon alignment'
            })
            failed += 1

# === CHECK 8: KYC/Documentation ===
kyc_complete = profile.get('kyc_complete', False)
agreement_signed = profile.get('agreement_signed', False)
if not kyc_complete:
    checks.append({
        'check': 'KYC Status',
        'status': 'WARN',
        'message': 'KYC status not confirmed in client profile',
        'action': 'Verify KYC completion before executing any recommendations',
        'regulation': 'SEBI KYC Registration Agency (KRA) Regulations'
    })
    warnings += 1

result = {
    'client_id': client_id,
    'client_name': profile.get('name', 'Unknown'),
    'risk_profile': risk_profile,
    'check_date': datetime.now().isoformat(),
    'checks': checks,
    'summary': {
        'total_checks': len(checks),
        'passed': passed,
        'failed': failed,
        'warnings': warnings,
        'suitability_score': round((passed / max(len(checks), 1)) * 100),
        'suitable': failed == 0,
        'can_proceed': failed == 0
    }
}

# Save report
reports_dir = os.path.join(base_dir, client_id, 'reports') if os.path.exists(os.path.join(base_dir, client_id)) else os.path.expanduser('~/.wealthstack/reports')
os.makedirs(reports_dir, exist_ok=True)
report_path = os.path.join(reports_dir, 'suitability-latest.json')
with open(report_path, 'w') as f:
    json.dump(result, f, indent=2)

print(json.dumps(result, indent=2))
"
