#!/bin/bash
# SIP Calculator for Indian investors
# Usage: sip-calculator.sh FUTURE_VALUE YEARS ANNUAL_RETURN_PCT
# Example: sip-calculator.sh 10000000 15 12

FV=${1:-10000000}
YEARS=${2:-15}
RETURN=${3:-12}

python3 -c "
import json
fv = $FV
years = $YEARS
annual_return = $RETURN / 100
monthly_return = (1 + annual_return) ** (1/12) - 1
months = years * 12

# Required monthly SIP
if monthly_return > 0:
    sip = fv * monthly_return / ((1 + monthly_return) ** months - 1)
else:
    sip = fv / months

# Lumpsum needed today
lumpsum = fv / (1 + annual_return) ** years

# Total invested via SIP
total_invested = sip * months
wealth_gain = fv - total_invested

result = {
    'target_amount': round(fv),
    'years': years,
    'expected_return_pct': $RETURN,
    'monthly_sip_required': round(sip),
    'lumpsum_required_today': round(lumpsum),
    'total_invested_via_sip': round(total_invested),
    'wealth_gain': round(wealth_gain),
    'wealth_gain_pct': round((wealth_gain / total_invested) * 100, 1) if total_invested > 0 else 0,
    'currency': 'INR'
}
print(json.dumps(result, indent=2))
"
