#!/bin/bash
# tax-calculator.sh — Indian income tax calculator (Old vs New regime)
# Usage: tax-calculator.sh --income <amount> --regime <old|new|both> [options]
#
# Options:
#   --income <amount>     Gross annual income
#   --regime <old|new|both>  Tax regime to calculate
#   --age <years>         Age (for senior citizen benefits)
#   --80c <amount>        Section 80C deductions (max 1,50,000)
#   --80d <amount>        Section 80D deductions (health insurance)
#   --hra <amount>        HRA exemption amount
#   --home-loan <amount>  Home loan interest (Section 24b, max 2,00,000)
#   --nps <amount>        NPS 80CCD(1B) (max 50,000)
#   --other-deductions <amount>  Other deductions
#
# Example:
#   tax-calculator.sh --income 2500000 --regime both --80c 150000 --80d 25000 --nps 50000

set -euo pipefail

INCOME=0
REGIME="both"
AGE=30
SEC_80C=0
SEC_80D=0
HRA=0
HOME_LOAN=0
NPS=0
OTHER=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --income) INCOME="$2"; shift 2 ;;
        --regime) REGIME="$2"; shift 2 ;;
        --age) AGE="$2"; shift 2 ;;
        --80c) SEC_80C="$2"; shift 2 ;;
        --80d) SEC_80D="$2"; shift 2 ;;
        --hra) HRA="$2"; shift 2 ;;
        --home-loan) HOME_LOAN="$2"; shift 2 ;;
        --nps) NPS="$2"; shift 2 ;;
        --other-deductions) OTHER="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

python3 -c "
import json

income = float('$INCOME')
regime = '$REGIME'
age = int('$AGE')
sec_80c = min(float('$SEC_80C'), 150000)
sec_80d = float('$SEC_80D')
hra = float('$HRA')
home_loan = min(float('$HOME_LOAN'), 200000)
nps = min(float('$NPS'), 50000)
other = float('$OTHER')

def calc_new_regime(gross):
    # FY 2025-26 new regime slabs
    std_deduction = 75000
    taxable = max(0, gross - std_deduction)

    slabs = [
        (400000, 0),
        (400000, 0.05),
        (400000, 0.10),
        (400000, 0.15),
        (400000, 0.20),
        (400000, 0.25),
        (float('inf'), 0.30),
    ]

    tax = 0
    remaining = taxable
    for slab_amount, rate in slabs:
        if remaining <= 0:
            break
        taxable_in_slab = min(remaining, slab_amount)
        tax += taxable_in_slab * rate
        remaining -= taxable_in_slab

    # Rebate u/s 87A: if taxable income <= 12,00,000
    if taxable <= 1200000:
        tax = 0

    cess = tax * 0.04
    # Surcharge
    surcharge = 0
    if taxable > 50000000:
        surcharge = tax * 0.25
    elif taxable > 20000000:
        surcharge = tax * 0.25
    elif taxable > 10000000:
        surcharge = tax * 0.15
    elif taxable > 5000000:
        surcharge = tax * 0.10

    total = tax + cess + surcharge

    return {
        'regime': 'New Regime (FY 2025-26)',
        'gross_income': round(gross),
        'standard_deduction': round(std_deduction),
        'taxable_income': round(taxable),
        'tax': round(tax),
        'surcharge': round(surcharge),
        'cess_4pct': round(cess),
        'total_tax': round(total),
        'effective_rate': f'{(total/gross*100):.1f}%' if gross > 0 else '0%',
        'monthly_tax': round(total / 12),
    }

def calc_old_regime(gross):
    std_deduction = 50000
    deductions = sec_80c + sec_80d + hra + home_loan + nps + other
    taxable = max(0, gross - std_deduction - deductions)

    # Basic exemption
    if age >= 80:
        exempt = 500000
    elif age >= 60:
        exempt = 300000
    else:
        exempt = 250000

    slabs = [
        (exempt, 0),
        (250000, 0.05),
        (500000, 0.20),
        (float('inf'), 0.30),
    ]

    tax = 0
    remaining = taxable
    for slab_amount, rate in slabs:
        if remaining <= 0:
            break
        taxable_in_slab = min(remaining, slab_amount)
        tax += taxable_in_slab * rate
        remaining -= taxable_in_slab

    # Rebate u/s 87A: if taxable income <= 5,00,000
    if taxable <= 500000:
        tax = 0

    cess = tax * 0.04
    surcharge = 0
    if taxable > 50000000:
        surcharge = tax * 0.37
    elif taxable > 20000000:
        surcharge = tax * 0.25
    elif taxable > 10000000:
        surcharge = tax * 0.15
    elif taxable > 5000000:
        surcharge = tax * 0.10

    total = tax + cess + surcharge

    return {
        'regime': 'Old Regime (FY 2025-26)',
        'gross_income': round(gross),
        'standard_deduction': round(std_deduction),
        'deductions': {
            '80C': round(sec_80c),
            '80D': round(sec_80d),
            'HRA': round(hra),
            'Home_Loan_24b': round(home_loan),
            'NPS_80CCD1B': round(nps),
            'Other': round(other),
            'Total': round(deductions),
        },
        'taxable_income': round(taxable),
        'tax': round(tax),
        'surcharge': round(surcharge),
        'cess_4pct': round(cess),
        'total_tax': round(total),
        'effective_rate': f'{(total/gross*100):.1f}%' if gross > 0 else '0%',
        'monthly_tax': round(total / 12),
    }

results = {}

if regime in ('new', 'both'):
    results['new_regime'] = calc_new_regime(income)

if regime in ('old', 'both'):
    results['old_regime'] = calc_old_regime(income)

if regime == 'both':
    new_tax = results['new_regime']['total_tax']
    old_tax = results['old_regime']['total_tax']
    savings = new_tax - old_tax
    results['comparison'] = {
        'better_regime': 'Old' if old_tax < new_tax else 'New',
        'savings': abs(round(savings)),
        'recommendation': f\"{'Old' if old_tax < new_tax else 'New'} regime saves Rs {abs(round(savings)):,}\"
    }

print(json.dumps(results, indent=2))
"
