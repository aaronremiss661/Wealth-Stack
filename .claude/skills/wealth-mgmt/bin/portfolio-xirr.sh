#!/bin/bash
# portfolio-xirr.sh — Calculate XIRR for investment portfolio
# Usage: portfolio-xirr.sh --cashflows <json_file_or_inline>
#
# Cashflow format (JSON array of [date, amount]):
#   [["2021-01-05", -25000], ["2021-02-05", -25000], ..., ["2026-03-24", 450000]]
#   Negative = investment, Positive = current value / redemption
#
# Examples:
#   portfolio-xirr.sh --cashflows '[["2021-01-05",-25000],["2021-02-05",-25000],["2026-03-24",680000]]'
#   portfolio-xirr.sh --cashflows cashflows.json
#   portfolio-xirr.sh --sip --amount 25000 --start 2021-01 --current-value 680000

set -euo pipefail

MODE="cashflows"
CASHFLOWS=""
SIP_AMOUNT=0
SIP_START=""
CURRENT_VALUE=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --cashflows) CASHFLOWS="$2"; shift 2 ;;
        --sip) MODE="sip"; shift ;;
        --amount) SIP_AMOUNT="$2"; shift 2 ;;
        --start) SIP_START="$2"; shift 2 ;;
        --current-value) CURRENT_VALUE="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

python3 << 'PYEOF'
import json
import sys
from datetime import datetime, timedelta

mode = "$MODE"
cashflows_input = '''$CASHFLOWS'''
sip_amount = float("$SIP_AMOUNT") if "$SIP_AMOUNT" else 0
sip_start = "$SIP_START"
current_value = float("$CURRENT_VALUE") if "$CURRENT_VALUE" else 0

def xirr(cashflows, guess=0.1):
    """Calculate XIRR using Newton's method."""
    if not cashflows:
        return 0

    dates = [cf[0] for cf in cashflows]
    amounts = [cf[1] for cf in cashflows]
    d0 = min(dates)

    def npv(rate):
        return sum(a / (1 + rate) ** ((d - d0).days / 365.25) for d, a in zip(dates, amounts))

    def dnpv(rate):
        return sum(-a * ((d - d0).days / 365.25) / (1 + rate) ** ((d - d0).days / 365.25 + 1) for d, a in zip(dates, amounts))

    rate = guess
    for _ in range(1000):
        f = npv(rate)
        df = dnpv(rate)
        if abs(df) < 1e-12:
            break
        new_rate = rate - f / df
        if abs(new_rate - rate) < 1e-9:
            rate = new_rate
            break
        rate = new_rate

    return rate

try:
    if mode == "sip":
        # Generate SIP cashflows
        start = datetime.strptime(sip_start + "-05", "%Y-%m-%d")
        today = datetime.now()
        cashflows = []
        current = start
        total_invested = 0
        while current <= today:
            cashflows.append([current, -sip_amount])
            total_invested += sip_amount
            # Move to next month
            if current.month == 12:
                current = current.replace(year=current.year + 1, month=1)
            else:
                current = current.replace(month=current.month + 1)
        cashflows.append([today, current_value])

    else:
        # Parse cashflows from input
        if cashflows_input.endswith('.json'):
            with open(cashflows_input) as f:
                raw = json.load(f)
        else:
            raw = json.loads(cashflows_input)

        cashflows = [[datetime.strptime(d, "%Y-%m-%d"), float(a)] for d, a in raw]
        total_invested = sum(-a for _, a in cashflows if a < 0)

    rate = xirr(cashflows)

    result = {
        "xirr": f"{rate * 100:.2f}%",
        "xirr_decimal": round(rate, 6),
        "total_invested": round(total_invested),
        "current_value": round(cashflows[-1][1]) if cashflows[-1][1] > 0 else 0,
        "absolute_return": f"{((cashflows[-1][1] / total_invested - 1) * 100):.1f}%" if total_invested > 0 else "N/A",
        "num_transactions": len(cashflows),
        "first_investment": cashflows[0][0].strftime("%Y-%m-%d"),
        "latest_date": cashflows[-1][0].strftime("%Y-%m-%d"),
    }

    print(json.dumps(result, indent=2))

except Exception as e:
    print(json.dumps({"error": str(e)}))
PYEOF
