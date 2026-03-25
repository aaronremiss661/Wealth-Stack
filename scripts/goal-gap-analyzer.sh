#!/bin/bash
# Goal Gap Analyzer — Compare investment trajectory vs financial goals
# Usage: goal-gap-analyzer.sh [GOALS_JSON_PATH] [INFLATION_PCT]
# Goals JSON format: {goals: [{name, target_amount, target_date, current_value, monthly_sip, expected_return}]}

FILE=${1:-~/.wealthstack/goals.json}
INFLATION=${2:-6}

python3 -c "
import json, sys, math
from datetime import datetime

today = datetime.now()
inflation = $INFLATION / 100

def months_until(target_date_str):
    target = datetime.strptime(target_date_str, '%Y-%m-%d')
    delta = (target.year - today.year) * 12 + (target.month - today.month)
    return max(0, delta)

def project_value(current_value, monthly_sip, annual_return, months):
    \"\"\"Project future value of existing corpus + SIP contributions.\"\"\"
    if months == 0:
        return current_value
    monthly_return = (1 + annual_return) ** (1/12) - 1
    # FV of existing corpus
    fv_lumpsum = current_value * (1 + monthly_return) ** months
    # FV of SIP stream
    if monthly_return > 0:
        fv_sip = monthly_sip * (((1 + monthly_return) ** months - 1) / monthly_return) * (1 + monthly_return)
    else:
        fv_sip = monthly_sip * months
    return fv_lumpsum + fv_sip

def inflation_adjusted_target(target_amount, months):
    \"\"\"Adjust target for inflation if target is in today's terms.\"\"\"
    years = months / 12
    return target_amount * (1 + inflation) ** years

def required_additional_sip(gap, annual_return, months):
    \"\"\"Calculate additional monthly SIP needed to bridge the gap.\"\"\"
    if months <= 0 or gap <= 0:
        return 0
    monthly_return = (1 + annual_return) ** (1/12) - 1
    if monthly_return > 0:
        sip = gap * monthly_return / (((1 + monthly_return) ** months - 1) * (1 + monthly_return))
    else:
        sip = gap / months
    return max(0, sip)

def success_probability(projected, target):
    \"\"\"Simple deterministic probability estimate based on projection vs target.\"\"\"
    if target == 0:
        return 100.0
    ratio = projected / target
    if ratio >= 1.2:
        return 95.0
    elif ratio >= 1.0:
        return 80.0 + (ratio - 1.0) * 75.0  # 80-95% range
    elif ratio >= 0.8:
        return 50.0 + (ratio - 0.8) * 150.0  # 50-80% range
    elif ratio >= 0.5:
        return 20.0 + (ratio - 0.5) * 100.0  # 20-50% range
    else:
        return max(5.0, ratio * 40.0)

try:
    with open('$FILE') as f:
        data = json.load(f)

    goals = data.get('goals', [])
    results = []
    goals_on_track = 0
    goals_at_risk = 0
    total_gap = 0

    for g in goals:
        name = g['name']
        target_amount = g['target_amount']
        target_date = g['target_date']
        current_value = g.get('current_value', 0)
        monthly_sip = g.get('monthly_sip', 0)
        expected_return = g.get('expected_return', 12) / 100
        adjust_inflation = g.get('inflation_adjusted', True)

        months = months_until(target_date)
        years = months / 12

        # Inflation-adjusted target (if target is in today's rupees)
        real_target = inflation_adjusted_target(target_amount, months) if adjust_inflation else target_amount

        # Project current trajectory
        projected = project_value(current_value, monthly_sip, expected_return, months)

        # Gap analysis
        gap = real_target - projected
        gap_pct = round((gap / real_target) * 100, 1) if real_target > 0 else 0

        # Additional SIP needed
        add_sip = required_additional_sip(gap, expected_return, months) if gap > 0 else 0

        # Track status
        on_track = projected >= real_target
        if on_track:
            goals_on_track += 1
        else:
            goals_at_risk += 1
            total_gap += gap

        prob = success_probability(projected, real_target)

        results.append({
            'name': name,
            'target_date': target_date,
            'years_remaining': round(years, 1),
            'target_today': round(target_amount),
            'target_inflation_adjusted': round(real_target),
            'current_value': round(current_value),
            'monthly_sip': round(monthly_sip),
            'expected_return_pct': round(expected_return * 100, 1),
            'projected_value': round(projected),
            'gap': round(gap),
            'gap_pct': gap_pct,
            'additional_sip_needed': round(add_sip),
            'probability_of_success': round(prob, 1),
            'on_track': on_track
        })

    output = {
        'goals': results,
        'summary': {
            'total_goals': len(goals),
            'goals_on_track': goals_on_track,
            'goals_at_risk': goals_at_risk,
            'total_gap': round(total_gap),
            'inflation_assumed_pct': $INFLATION
        },
        'file': '$FILE',
        'currency': 'INR'
    }
    print(json.dumps(output, indent=2))

except FileNotFoundError:
    print(json.dumps({'error': 'Goals file not found: $FILE', 'hint': 'Create goals JSON with: {goals: [{name, target_amount, target_date, current_value, monthly_sip, expected_return}]}'}))
except Exception as e:
    print(json.dumps({'error': str(e)}))
"
