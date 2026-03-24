#!/bin/bash
# FD Rate Comparison across Indian banks
# Usage: fd-compare.sh [tenure_months]

TENURE=${1:-12}

python3 -c "
import json

# Approximate FD rates (update periodically via web search)
banks = {
    'SBI': {'1yr': 6.80, '2yr': 7.00, '3yr': 6.75, '5yr': 6.50, 'senior_premium': 0.50},
    'HDFC Bank': {'1yr': 6.60, '2yr': 7.00, '3yr': 7.00, '5yr': 7.00, 'senior_premium': 0.50},
    'ICICI Bank': {'1yr': 6.70, '2yr': 7.00, '3yr': 7.00, '5yr': 6.90, 'senior_premium': 0.50},
    'Kotak': {'1yr': 7.10, '2yr': 7.15, '3yr': 6.90, '5yr': 6.40, 'senior_premium': 0.50},
    'Axis Bank': {'1yr': 6.70, '2yr': 7.00, '3yr': 7.00, '5yr': 6.80, 'senior_premium': 0.50},
    'Bajaj Finance FD': {'1yr': 8.05, '2yr': 8.25, '3yr': 8.25, '5yr': 8.00, 'senior_premium': 0.25},
    'Mahindra Finance FD': {'1yr': 7.85, '2yr': 8.00, '3yr': 8.05, '5yr': 7.80, 'senior_premium': 0.25},
    'AU Small Finance': {'1yr': 7.25, '2yr': 7.50, '3yr': 7.50, '5yr': 7.25, 'senior_premium': 0.50},
    'Ujjivan SFB': {'1yr': 7.50, '2yr': 7.55, '3yr': 7.30, '5yr': 7.20, 'senior_premium': 0.50}
}

result = {
    'note': 'Rates are approximate. Verify with bank websites for latest rates.',
    'tenure_months': $TENURE,
    'banks': banks
}
print(json.dumps(result, indent=2))
"
