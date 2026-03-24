#!/bin/bash
# sip-calculator.sh — SIP, SWP, and lumpsum calculator
# Usage: sip-calculator.sh --mode <sip|swp|lumpsum|goal> [options]
#
# Modes:
#   sip      — Calculate future value of monthly SIP
#   swp      — Calculate how long a corpus lasts with monthly withdrawals
#   lumpsum  — Calculate future value of one-time investment
#   goal     — Calculate required monthly SIP to reach a goal
#
# Examples:
#   sip-calculator.sh --mode sip --amount 25000 --years 20 --return 12
#   sip-calculator.sh --mode goal --target 10000000 --years 15 --return 12
#   sip-calculator.sh --mode swp --corpus 50000000 --withdraw 200000 --return 8
#   sip-calculator.sh --mode lumpsum --amount 1000000 --years 10 --return 12

set -euo pipefail

MODE=""
AMOUNT=0
YEARS=0
RETURN_RATE=12
TARGET=0
CORPUS=0
WITHDRAW=0
INFLATION=6
STEP_UP=10

while [[ $# -gt 0 ]]; do
    case "$1" in
        --mode) MODE="$2"; shift 2 ;;
        --amount) AMOUNT="$2"; shift 2 ;;
        --years) YEARS="$2"; shift 2 ;;
        --return) RETURN_RATE="$2"; shift 2 ;;
        --target) TARGET="$2"; shift 2 ;;
        --corpus) CORPUS="$2"; shift 2 ;;
        --withdraw) WITHDRAW="$2"; shift 2 ;;
        --inflation) INFLATION="$2"; shift 2 ;;
        --step-up) STEP_UP="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

python3 -c "
import json

mode = '$MODE'
amount = float('$AMOUNT')
years = int('$YEARS')
rate = float('$RETURN_RATE') / 100
target = float('$TARGET')
corpus = float('$CORPUS')
withdraw = float('$WITHDRAW')
inflation = float('$INFLATION') / 100
step_up = float('$STEP_UP') / 100

monthly_rate = rate / 12
months = years * 12

result = {}

if mode == 'sip':
    # Future value of SIP
    if monthly_rate > 0:
        fv = amount * (((1 + monthly_rate)**months - 1) / monthly_rate) * (1 + monthly_rate)
    else:
        fv = amount * months
    invested = amount * months
    gains = fv - invested

    # With step-up
    fv_stepup = 0
    current_sip = amount
    for y in range(years):
        for m in range(12):
            month_num = y * 12 + m
            remaining = months - month_num
            fv_stepup += current_sip * (1 + monthly_rate)**remaining
        current_sip *= (1 + step_up)

    result = {
        'mode': 'SIP Calculator',
        'monthly_sip': amount,
        'years': years,
        'expected_return': f'{rate*100:.1f}%',
        'total_invested': round(invested),
        'future_value': round(fv),
        'wealth_gained': round(gains),
        'with_step_up': {
            'step_up_rate': f'{step_up*100:.0f}%',
            'future_value': round(fv_stepup),
        }
    }

elif mode == 'goal':
    # Required SIP to reach target
    if monthly_rate > 0:
        sip = target / ((((1 + monthly_rate)**months - 1) / monthly_rate) * (1 + monthly_rate))
    else:
        sip = target / months

    # Inflation-adjusted target
    real_target = target * (1 + inflation)**years
    if monthly_rate > 0:
        real_sip = real_target / ((((1 + monthly_rate)**months - 1) / monthly_rate) * (1 + monthly_rate))
    else:
        real_sip = real_target / months

    result = {
        'mode': 'Goal SIP Calculator',
        'target_amount': round(target),
        'inflation_adjusted_target': round(real_target),
        'years': years,
        'expected_return': f'{rate*100:.1f}%',
        'required_monthly_sip': round(sip),
        'inflation_adjusted_sip': round(real_sip),
        'total_investment': round(sip * months),
    }

elif mode == 'swp':
    # How long corpus lasts with withdrawals
    balance = corpus
    monthly_withdraw = withdraw
    month = 0
    max_months = years * 12 if years > 0 else 600  # default 50 years max

    while balance > 0 and month < max_months:
        balance = balance * (1 + monthly_rate) - monthly_withdraw
        month += 1
        if month % 12 == 0:
            monthly_withdraw *= (1 + inflation)  # inflation-adjust withdrawals

    result = {
        'mode': 'SWP Calculator',
        'initial_corpus': round(corpus),
        'monthly_withdrawal': round(withdraw),
        'portfolio_return': f'{rate*100:.1f}%',
        'inflation': f'{inflation*100:.1f}%',
        'corpus_lasts': f'{month // 12} years {month % 12} months',
        'total_withdrawn': round(withdraw * month),
    }

elif mode == 'lumpsum':
    fv = amount * (1 + rate)**years
    result = {
        'mode': 'Lumpsum Calculator',
        'investment': round(amount),
        'years': years,
        'expected_return': f'{rate*100:.1f}%',
        'future_value': round(fv),
        'wealth_gained': round(fv - amount),
        'real_value_after_inflation': round(fv / (1 + inflation)**years),
    }

else:
    result = {'error': 'Invalid mode. Use: sip, swp, lumpsum, or goal'}

print(json.dumps(result, indent=2))
"
