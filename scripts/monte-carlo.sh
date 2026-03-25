#!/bin/bash
# Monte Carlo Portfolio Simulation
# Usage: monte-carlo.sh PORTFOLIO_VALUE EQUITY_PCT DEBT_PCT GOLD_PCT YEARS [MONTHLY_SIP]
# Example: monte-carlo.sh 5000000 60 30 10 20 50000

if [ $# -lt 5 ]; then
  echo '{"error": "Usage: monte-carlo.sh PORTFOLIO_VALUE EQUITY_PCT DEBT_PCT GOLD_PCT YEARS [MONTHLY_SIP]"}'
  exit 1
fi

PORTFOLIO=$1
EQUITY=$2
DEBT=$3
GOLD=$4
YEARS=$5
SIP=${6:-0}

python3 -c "
import json, sys

try:
    import numpy as np
except ImportError:
    print(json.dumps({'error': 'numpy not installed. Run: pip install numpy'}))
    sys.exit(1)

portfolio_value = $PORTFOLIO
equity_pct = $EQUITY / 100
debt_pct = $DEBT / 100
gold_pct = $GOLD / 100
years = $YEARS
monthly_sip = $SIP
n_simulations = 1000
months = years * 12

# Validate allocation sums to ~100%
total_alloc = equity_pct + debt_pct + gold_pct
if abs(total_alloc - 1.0) > 0.01:
    print(json.dumps({'error': f'Allocation must sum to 100%. Got {round(total_alloc*100,1)}%'}))
    sys.exit(1)

# Asset class assumptions (annualized)
assumptions = {
    'equity': {'mean': 0.12, 'std': 0.18},
    'debt':   {'mean': 0.07, 'std': 0.03},
    'gold':   {'mean': 0.08, 'std': 0.12}
}

# Convert annual to monthly parameters
eq_monthly_mean = (1 + assumptions['equity']['mean']) ** (1/12) - 1
eq_monthly_std = assumptions['equity']['std'] / (12 ** 0.5)
dt_monthly_mean = (1 + assumptions['debt']['mean']) ** (1/12) - 1
dt_monthly_std = assumptions['debt']['std'] / (12 ** 0.5)
gd_monthly_mean = (1 + assumptions['gold']['mean']) ** (1/12) - 1
gd_monthly_std = assumptions['gold']['std'] / (12 ** 0.5)

np.random.seed(None)  # True random

# Run simulations
final_values = np.zeros(n_simulations)

for sim in range(n_simulations):
    # Allocate starting portfolio
    eq_val = portfolio_value * equity_pct
    dt_val = portfolio_value * debt_pct
    gd_val = portfolio_value * gold_pct

    for m in range(months):
        # Generate monthly returns
        eq_ret = np.random.normal(eq_monthly_mean, eq_monthly_std)
        dt_ret = np.random.normal(dt_monthly_mean, dt_monthly_std)
        gd_ret = np.random.normal(gd_monthly_mean, gd_monthly_std)

        # Apply returns
        eq_val *= (1 + eq_ret)
        dt_val *= (1 + dt_ret)
        gd_val *= (1 + gd_ret)

        # Add SIP (allocated proportionally)
        if monthly_sip > 0:
            eq_val += monthly_sip * equity_pct
            dt_val += monthly_sip * debt_pct
            gd_val += monthly_sip * gold_pct

        # Monthly rebalancing: redistribute to target allocation
        total = eq_val + dt_val + gd_val
        if total > 0:
            eq_val = total * equity_pct
            dt_val = total * debt_pct
            gd_val = total * gold_pct

    final_values[sim] = eq_val + dt_val + gd_val

# Ensure no negative portfolio values (floor at 0)
final_values = np.maximum(final_values, 0)

# Calculate statistics
total_invested = portfolio_value + (monthly_sip * months)
percentiles = {
    'p10': round(float(np.percentile(final_values, 10))),
    'p25': round(float(np.percentile(final_values, 25))),
    'p50': round(float(np.percentile(final_values, 50))),
    'p75': round(float(np.percentile(final_values, 75))),
    'p90': round(float(np.percentile(final_values, 90)))
}

prob_positive = round(float(np.mean(final_values > total_invested) * 100), 1)
prob_double = round(float(np.mean(final_values > 2 * total_invested) * 100), 1)
prob_loss = round(float(np.mean(final_values < total_invested) * 100), 1)

result = {
    'simulations': n_simulations,
    'portfolio_value': portfolio_value,
    'allocation': {
        'equity_pct': round(equity_pct * 100, 1),
        'debt_pct': round(debt_pct * 100, 1),
        'gold_pct': round(gold_pct * 100, 1)
    },
    'monthly_sip': monthly_sip,
    'years': years,
    'total_invested': total_invested,
    'assumptions': {
        'equity': {'annual_mean_pct': 12, 'annual_std_pct': 18},
        'debt':   {'annual_mean_pct': 7,  'annual_std_pct': 3},
        'gold':   {'annual_mean_pct': 8,  'annual_std_pct': 12}
    },
    'percentiles': percentiles,
    'stats': {
        'mean': round(float(np.mean(final_values))),
        'std': round(float(np.std(final_values))),
        'prob_positive_pct': prob_positive,
        'prob_double_pct': prob_double,
        'prob_loss_pct': prob_loss,
        'max': round(float(np.max(final_values))),
        'min': round(float(np.min(final_values))),
        'worst_case_return_pct': round(float((np.min(final_values) / total_invested - 1) * 100), 1),
        'best_case_return_pct': round(float((np.max(final_values) / total_invested - 1) * 100), 1),
        'median_return_pct': round(float((percentiles['p50'] / total_invested - 1) * 100), 1)
    },
    'currency': 'INR'
}
print(json.dumps(result, indent=2))
"
