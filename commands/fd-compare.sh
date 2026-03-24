#!/bin/bash
# fd-compare.sh — Compare fixed deposit rates across Indian banks & NBFCs
# Usage: fd-compare.sh [--tenure <years>] [--amount <amount>] [--senior]
#
# Examples:
#   fd-compare.sh                          # Default 1-year rates
#   fd-compare.sh --tenure 3               # 3-year FD rates
#   fd-compare.sh --tenure 5 --senior      # 5-year senior citizen rates
#   fd-compare.sh --amount 1000000 --tenure 1  # Post-tax comparison for Rs 10L

set -euo pipefail

TENURE=1
AMOUNT=1000000
SENIOR=false
TAX_BRACKET=30

while [[ $# -gt 0 ]]; do
    case "$1" in
        --tenure) TENURE="$2"; shift 2 ;;
        --amount) AMOUNT="$2"; shift 2 ;;
        --senior) SENIOR=true; shift ;;
        --tax-bracket) TAX_BRACKET="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

python3 -c "
import json

tenure = int('$TENURE')
amount = float('$AMOUNT')
senior = '$SENIOR' == 'true'
tax_bracket = float('$TAX_BRACKET') / 100

# FD rates data (approximate, update periodically via web search)
# Format: [name, general_1yr, senior_1yr, general_3yr, senior_3yr, general_5yr, senior_5yr, min_amount, insured]
banks = [
    ['SBI', 6.80, 7.30, 7.00, 7.50, 6.50, 7.50, 1000, True],
    ['HDFC Bank', 7.00, 7.50, 7.10, 7.60, 7.00, 7.50, 5000, True],
    ['ICICI Bank', 7.00, 7.50, 7.10, 7.60, 7.00, 7.50, 10000, True],
    ['Kotak Mahindra', 7.10, 7.60, 7.20, 7.70, 6.20, 6.70, 5000, True],
    ['Axis Bank', 6.90, 7.40, 7.10, 7.60, 7.00, 7.50, 5000, True],
    ['IndusInd Bank', 7.50, 8.00, 7.75, 8.25, 7.25, 7.75, 10000, True],
    ['Yes Bank', 7.50, 8.00, 7.75, 8.25, 7.25, 7.75, 10000, True],
    ['Bajaj Finance', 8.05, 8.30, 8.25, 8.50, 8.05, 8.30, 15000, False],
    ['Shriram Finance', 8.54, 9.04, 8.69, 9.19, 8.40, 8.90, 5000, False],
    ['Mahindra Finance', 8.05, 8.30, 8.20, 8.45, 8.05, 8.30, 5000, False],
    ['PNB Housing', 7.90, 8.15, 7.95, 8.20, 7.65, 7.90, 10000, False],
    ['LIC Housing', 7.75, 8.00, 7.80, 8.05, 7.60, 7.85, 10000, False],
]

# Select rates based on tenure
rates = []
for b in banks:
    if tenure <= 1:
        rate = b[2] if senior else b[1]
    elif tenure <= 3:
        rate = b[4] if senior else b[3]
    else:
        rate = b[6] if senior else b[5]

    post_tax = rate * (1 - tax_bracket)
    maturity = amount * (1 + rate/100) ** tenure
    interest = maturity - amount
    tax_paid = interest * tax_bracket

    rates.append({
        'bank': b[0],
        'rate': rate,
        'post_tax_rate': round(post_tax, 2),
        'maturity_value': round(maturity),
        'interest_earned': round(interest),
        'tax_on_interest': round(tax_paid),
        'net_interest': round(interest - tax_paid),
        'min_amount': b[7],
        'dicgc_insured': b[8],
    })

# Sort by rate descending
rates.sort(key=lambda x: x['rate'], reverse=True)

result = {
    'fd_comparison': {
        'tenure_years': tenure,
        'amount': amount,
        'category': 'Senior Citizen' if senior else 'General',
        'tax_bracket': f'{tax_bracket*100:.0f}%',
        'rates': rates,
        'note': 'Rates are indicative. Check bank websites for latest rates.',
        'dicgc_note': 'Bank FDs insured up to Rs 5L per depositor per bank. NBFC FDs are NOT insured.',
    }
}

print(json.dumps(result, indent=2))
"
