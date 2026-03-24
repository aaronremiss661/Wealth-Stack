#!/bin/bash
# Income Tax Calculator — Old vs New Regime (FY 2025-26)
# Usage: tax-calculator.sh TAXABLE_INCOME [old|new|both] [age: below60|60to80|above80]

INCOME=${1:-1500000}
REGIME=${2:-both}
AGE=${3:-below60}

python3 -c "
import json

income = $INCOME

def new_regime(income):
    std_deduction = 75000
    taxable = max(0, income - std_deduction)
    slabs = [(400000, 0), (400000, 0.05), (400000, 0.10), (400000, 0.15), (400000, 0.20), (float('inf'), 0.30)]
    tax = 0
    remaining = taxable
    for limit, rate in slabs:
        if remaining <= 0: break
        taxed = min(remaining, limit)
        tax += taxed * rate
        remaining -= taxed
    # Rebate u/s 87A: if taxable income <= 12L (after std deduction), tax = 0
    if taxable <= 1200000:
        tax = 0
    cess = tax * 0.04
    return {'taxable_income': taxable, 'tax': round(tax), 'cess': round(cess), 'total': round(tax + cess)}

def old_regime(income, age='below60'):
    # No standard deduction assumed here (user must input taxable income after deductions)
    taxable = income
    if age == 'below60':
        exempt = 250000
        slabs = [(250000, 0.05), (500000, 0.20), (float('inf'), 0.30)]
    elif age == '60to80':
        exempt = 300000
        slabs = [(200000, 0.05), (500000, 0.20), (float('inf'), 0.30)]
    else:
        exempt = 500000
        slabs = [(500000, 0.20), (float('inf'), 0.30)]
    
    remaining = max(0, taxable - exempt)
    tax = 0
    for limit, rate in slabs:
        if remaining <= 0: break
        taxed = min(remaining, limit)
        tax += taxed * rate
        remaining -= taxed
    # Rebate u/s 87A old regime: if taxable <= 5L, tax = 0
    if taxable <= 500000:
        tax = 0
    cess = tax * 0.04
    return {'taxable_income': taxable, 'tax': round(tax), 'cess': round(cess), 'total': round(tax + cess)}

result = {'income': income, 'age': '$AGE'}
regime = '$REGIME'

if regime in ('new', 'both'):
    result['new_regime'] = new_regime(income)
if regime in ('old', 'both'):
    result['old_regime'] = old_regime(income, '$AGE')
if regime == 'both':
    diff = result['old_regime']['total'] - result['new_regime']['total']
    result['recommendation'] = 'New regime saves Rs {:,}'.format(abs(diff)) if diff > 0 else 'Old regime saves Rs {:,}'.format(abs(diff))
    result['better_regime'] = 'new' if diff > 0 else 'old'

print(json.dumps(result, indent=2))
"
