#!/bin/bash
# Backtest portfolio against historical market scenarios
# Usage:
#   backtest.sh PORTFOLIO_JSON [SCENARIO]
#   backtest.sh --scenario 2020-covid
#   backtest.sh --scenario custom --start 2022-01-01 --end 2023-06-30
#   backtest.sh path/to/portfolio.json 2008-gfc
#   backtest.sh --all   (run all pre-built scenarios)
# Pre-built scenarios: 2008-gfc, 2013-taper, 2016-demon, 2020-covid, 2022-rate-hike
# Portfolio JSON: {allocations: {equity: 0.6, debt: 0.3, gold: 0.1}, initial_value: 1000000}

PORTFOLIO_FILE=""
SCENARIO=""
START_DATE=""
END_DATE=""
RUN_ALL=0
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scenario)
      SCENARIO="$2"
      shift 2
      ;;
    --start)
      START_DATE="$2"
      shift 2
      ;;
    --end)
      END_DATE="$2"
      shift 2
      ;;
    --all)
      RUN_ALL=1
      shift
      ;;
    -*)
      echo '{"error": "Unknown flag: '"$1"'. Usage: backtest.sh [PORTFOLIO_JSON] [--scenario NAME] [--start DATE --end DATE] [--all]"}'
      exit 1
      ;;
    *)
      # Positional: first is portfolio file or scenario
      if [ -z "$PORTFOLIO_FILE" ] && [[ "$1" == *.json || "$1" == /* || "$1" == ~* ]]; then
        PORTFOLIO_FILE="$1"
      elif [ -z "$SCENARIO" ]; then
        SCENARIO="$1"
      fi
      shift
      ;;
  esac
done

# Default portfolio path
if [ -z "$PORTFOLIO_FILE" ]; then
  PORTFOLIO_FILE="$HOME/.wealthstack/portfolios/latest.json"
fi

python3 -c "
import json, os, sys, math, time
from datetime import datetime, timedelta

PORTFOLIO_FILE = os.path.expanduser('$PORTFOLIO_FILE')
SCENARIO       = '$SCENARIO'.strip()
START_DATE     = '$START_DATE'.strip()
END_DATE       = '$END_DATE'.strip()
RUN_ALL        = $RUN_ALL
SCRIPT_DIR     = '$SCRIPT_DIR'

# ─── Pre-built Scenario Definitions ───────────────────────────────────────────
# Each scenario has monthly return profiles for different asset classes.
# Returns are expressed as decimals (e.g., -0.15 = -15%).
# Monthly values simulate the path from peak to trough and recovery.

SCENARIOS = {
    '2008-gfc': {
        'name': '2008 Global Financial Crisis',
        'period': {'start': '2008-01-01', 'end': '2009-12-31'},
        'description': 'US subprime crisis, Lehman collapse, global contagion. Nifty fell 60% from peak.',
        'peak_to_trough_months': 10,
        'recovery_months': 18,
        'asset_returns': {
            'equity':   -0.60,
            'debt':      0.02,
            'gold':      0.25,
            'realestate':-0.20,
            'cash':      0.04
        },
        # Monthly equity path: 10 months down, then 18 months recovery
        'monthly_equity_path': [
            -0.08, -0.06, -0.03, -0.10, -0.05, -0.08, -0.12, -0.15, -0.06, -0.02,  # crash (10 months)
            0.08, 0.10, 0.06, 0.05, 0.07, 0.04, 0.08, 0.06, 0.05, 0.03, 0.04, 0.03,  # recovery (12 months)
            0.04, 0.03, 0.02, 0.03, 0.02, 0.02  # final recovery (6 months)
        ],
        'monthly_debt_path': [
            0.003, 0.002, 0.001, 0.002, 0.003, 0.001, 0.002, 0.001, 0.002, 0.001,
            0.002, 0.001, 0.002, 0.001, 0.002, 0.001, 0.002, 0.001, 0.001, 0.002,
            0.001, 0.002, 0.001, 0.001, 0.002, 0.001, 0.001, 0.002
        ],
        'monthly_gold_path': [
            0.02, 0.03, 0.01, 0.02, 0.03, 0.02, 0.01, 0.03, 0.02, 0.01,
            0.01, 0.02, 0.01, 0.01, 0.01, 0.02, 0.01, 0.01, 0.01, 0.01,
            0.00, 0.01, 0.01, 0.00, 0.01, 0.00, 0.01, 0.00
        ],
        'nifty_comparison': {
            'peak': 6287, 'peak_date': '2008-01-08',
            'trough': 2524, 'trough_date': '2008-10-27',
            'drawdown_pct': -59.8,
            'recovery_date': '2010-11-05', 'recovery_months': 30
        }
    },

    '2013-taper': {
        'name': '2013 Taper Tantrum',
        'period': {'start': '2013-05-01', 'end': '2013-12-31'},
        'description': 'Fed taper talk triggered EM selloff. INR crashed from 54 to 68/$.',
        'peak_to_trough_months': 4,
        'recovery_months': 5,
        'asset_returns': {
            'equity':   -0.18,
            'debt':     -0.03,
            'gold':     -0.15,
            'realestate':-0.05,
            'cash':      0.02
        },
        'monthly_equity_path': [
            -0.05, -0.07, -0.04, -0.03,  # crash (4 months)
            0.04, 0.03, 0.05, 0.02       # recovery (4 months)
        ],
        'monthly_debt_path': [
            -0.01, -0.01, -0.005, -0.005,
            0.003, 0.002, 0.003, 0.002
        ],
        'monthly_gold_path': [
            -0.06, -0.04, -0.03, -0.03,
            0.01, 0.005, 0.01, 0.005
        ],
        'nifty_comparison': {
            'peak': 6229, 'peak_date': '2013-05-17',
            'trough': 5118, 'trough_date': '2013-08-28',
            'drawdown_pct': -17.8,
            'recovery_date': '2014-01-23', 'recovery_months': 5
        }
    },

    '2016-demon': {
        'name': '2016 Demonetization',
        'period': {'start': '2016-11-01', 'end': '2017-04-30'},
        'description': 'PM Modi announced demonetization of Rs 500/1000 notes on Nov 8, 2016.',
        'peak_to_trough_months': 2,
        'recovery_months': 3,
        'asset_returns': {
            'equity':   -0.08,
            'debt':      0.01,
            'gold':      0.05,
            'realestate':-0.15,
            'cash':      0.02
        },
        'monthly_equity_path': [
            -0.06, -0.03,                 # crash (2 months)
            0.02, 0.04, 0.03, 0.02       # recovery (4 months)
        ],
        'monthly_debt_path': [
            0.005, 0.003,
            0.002, 0.001, 0.002, 0.001
        ],
        'monthly_gold_path': [
            0.02, 0.02,
            0.01, 0.00, 0.00, -0.01
        ],
        'nifty_comparison': {
            'peak': 8669, 'peak_date': '2016-11-03',
            'trough': 7929, 'trough_date': '2016-12-26',
            'drawdown_pct': -8.5,
            'recovery_date': '2017-02-22', 'recovery_months': 3
        }
    },

    '2020-covid': {
        'name': '2020 COVID-19 Crash',
        'period': {'start': '2020-01-01', 'end': '2020-12-31'},
        'description': 'Fastest crash and V-shaped recovery in Indian market history.',
        'peak_to_trough_months': 2,
        'recovery_months': 5,
        'asset_returns': {
            'equity':   -0.38,
            'debt':      0.03,
            'gold':      0.28,
            'realestate':-0.10,
            'cash':      0.02
        },
        'monthly_equity_path': [
            0.01, -0.08, -0.25, -0.10,   # Jan (small gain), Feb-Apr crash
            0.10, 0.08, 0.07, 0.05,      # May-Aug recovery
            0.04, 0.06, 0.08, 0.04       # Sep-Dec rally
        ],
        'monthly_debt_path': [
            0.004, 0.003, -0.005, 0.003,
            0.003, 0.002, 0.003, 0.002,
            0.002, 0.003, 0.002, 0.002
        ],
        'monthly_gold_path': [
            0.03, 0.02, 0.01, 0.05,
            0.03, 0.02, 0.04, 0.03,
            -0.01, -0.02, 0.01, 0.02
        ],
        'nifty_comparison': {
            'peak': 12362, 'peak_date': '2020-01-20',
            'trough': 7511, 'trough_date': '2020-03-23',
            'drawdown_pct': -39.3,
            'recovery_date': '2020-10-08', 'recovery_months': 5
        }
    },

    '2022-rate-hike': {
        'name': '2022 Rate Hike Cycle',
        'period': {'start': '2022-01-01', 'end': '2023-06-30'},
        'description': 'RBI raised repo from 4.0% to 6.5%. FII outflows largest ever.',
        'peak_to_trough_months': 6,
        'recovery_months': 9,
        'asset_returns': {
            'equity':   -0.15,
            'debt':     -0.02,
            'gold':      0.05,
            'realestate': 0.02,
            'cash':      0.04
        },
        'monthly_equity_path': [
            -0.02, -0.03, -0.02, -0.04, -0.03, -0.02,  # drawdown (6 months)
            0.03, 0.02, -0.01, 0.02, 0.01, 0.03,         # choppy recovery (6 months)
            0.02, 0.01, 0.03, 0.02, 0.01, 0.02            # gradual recovery (6 months)
        ],
        'monthly_debt_path': [
            -0.003, -0.004, -0.003, -0.004, -0.002, -0.003,
            0.001, 0.002, 0.001, 0.002, 0.001, 0.002,
            0.002, 0.001, 0.002, 0.001, 0.002, 0.001
        ],
        'monthly_gold_path': [
            0.01, 0.02, 0.03, -0.01, -0.02, 0.01,
            0.01, -0.01, 0.02, 0.01, -0.01, 0.01,
            0.00, 0.01, 0.00, -0.01, 0.01, 0.00
        ],
        'nifty_comparison': {
            'peak': 18604, 'peak_date': '2021-10-19',
            'trough': 15183, 'trough_date': '2022-06-17',
            'drawdown_pct': -18.4,
            'recovery_date': '2023-03-15', 'recovery_months': 9
        }
    }
}


def load_portfolio(filepath):
    \"\"\"Load portfolio from JSON file or use a default.\"\"\"
    if os.path.exists(filepath):
        try:
            with open(filepath, 'r') as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError) as e:
            pass
    # Default portfolio
    return {
        'allocations': {
            'equity': 0.60,
            'debt':   0.30,
            'gold':   0.10
        },
        'initial_value': 1000000
    }


def simulate_scenario(portfolio, scenario_key, scenario_def):
    \"\"\"Run a portfolio through a historical scenario and calculate metrics.\"\"\"
    alloc = portfolio.get('allocations', {'equity': 0.6, 'debt': 0.3, 'gold': 0.1})
    initial = portfolio.get('initial_value', 1000000)

    # Normalize allocations
    total_alloc = sum(alloc.values())
    if total_alloc > 0:
        alloc = {k: v / total_alloc for k, v in alloc.items()}

    # Get monthly paths
    equity_path = scenario_def.get('monthly_equity_path', [])
    debt_path   = scenario_def.get('monthly_debt_path', [])
    gold_path   = scenario_def.get('monthly_gold_path', [])

    n_months = max(len(equity_path), len(debt_path), len(gold_path))
    if n_months == 0:
        # Fallback: generate simple path from total returns
        asset_ret = scenario_def.get('asset_returns', {})
        crash_months = scenario_def.get('peak_to_trough_months', 3)
        rec_months = scenario_def.get('recovery_months', 6)
        n_months = crash_months + rec_months
        equity_ret = asset_ret.get('equity', -0.20)
        monthly_crash = equity_ret / crash_months if crash_months else equity_ret
        monthly_rec = abs(equity_ret) / rec_months if rec_months else 0
        equity_path = [monthly_crash] * crash_months + [monthly_rec] * rec_months
        debt_total = asset_ret.get('debt', 0.02)
        debt_path = [debt_total / n_months] * n_months
        gold_total = asset_ret.get('gold', 0.05)
        gold_path = [gold_total / n_months] * n_months

    # Pad shorter paths with zeros
    while len(equity_path) < n_months:
        equity_path.append(0.0)
    while len(debt_path) < n_months:
        debt_path.append(0.0)
    while len(gold_path) < n_months:
        gold_path.append(0.0)

    # Map asset classes to paths
    asset_paths = {
        'equity': equity_path,
        'debt': debt_path,
        'gold': gold_path,
        'realestate': equity_path,  # approximate with equity for simplicity
        'cash': [0.003] * n_months  # ~3.6% annual
    }

    # Simulate monthly portfolio values
    monthly_values = [{'month': 0, 'value': round(initial, 2)}]
    portfolio_value = initial
    lowest_value = initial
    highest_value = initial
    worst_month_return = 0
    best_month_return = 0
    worst_month_idx = 0
    best_month_idx = 0

    # Also track pure Nifty (100% equity) for comparison
    nifty_value = initial

    for month_idx in range(n_months):
        # Calculate weighted portfolio return for this month
        monthly_return = 0
        for asset, weight in alloc.items():
            asset_key = asset.lower()
            path = asset_paths.get(asset_key, asset_paths.get('equity', [0.0] * n_months))
            if month_idx < len(path):
                monthly_return += weight * path[month_idx]

        portfolio_value *= (1 + monthly_return)

        # Track Nifty comparison
        if month_idx < len(equity_path):
            nifty_value *= (1 + equity_path[month_idx])

        # Track extremes
        if portfolio_value < lowest_value:
            lowest_value = portfolio_value
        if portfolio_value > highest_value:
            highest_value = portfolio_value

        if monthly_return < worst_month_return:
            worst_month_return = monthly_return
            worst_month_idx = month_idx + 1
        if monthly_return > best_month_return:
            best_month_return = monthly_return
            best_month_idx = month_idx + 1

        monthly_values.append({
            'month': month_idx + 1,
            'value': round(portfolio_value, 2)
        })

    # Calculate metrics
    max_drawdown_pct = round(((lowest_value - initial) / initial) * 100, 2)

    # Recovery time: months until portfolio value returns to initial
    recovery_months = None
    hit_trough = False
    for mv in monthly_values:
        if mv['value'] < initial:
            hit_trough = True
        if hit_trough and mv['value'] >= initial:
            recovery_months = mv['month']
            break
    if recovery_months is None and portfolio_value >= initial:
        recovery_months = n_months

    # CAGR
    years = n_months / 12
    if years > 0 and portfolio_value > 0 and initial > 0:
        cagr = (pow(portfolio_value / initial, 1 / years) - 1) * 100
    else:
        cagr = 0

    # Nifty comparison
    nifty_return_pct = round(((nifty_value - initial) / initial) * 100, 2)
    portfolio_return_pct = round(((portfolio_value - initial) / initial) * 100, 2)

    period = scenario_def.get('period', {})

    return {
        'scenario': scenario_key,
        'scenario_name': scenario_def.get('name', scenario_key),
        'description': scenario_def.get('description', ''),
        'period': period,
        'months_simulated': n_months,
        'allocations_used': {k: round(v, 4) for k, v in alloc.items()},
        'portfolio': {
            'initial': round(initial, 2),
            'lowest': round(lowest_value, 2),
            'final': round(portfolio_value, 2),
            'return_pct': portfolio_return_pct,
            'max_drawdown_pct': max_drawdown_pct,
            'recovery_months': recovery_months,
            'cagr_pct': round(cagr, 2),
            'worst_month': {
                'month': worst_month_idx,
                'return_pct': round(worst_month_return * 100, 2)
            },
            'best_month': {
                'month': best_month_idx,
                'return_pct': round(best_month_return * 100, 2)
            }
        },
        'monthly_values': monthly_values,
        'comparison_vs_nifty': {
            'nifty_return_pct': nifty_return_pct,
            'portfolio_return_pct': portfolio_return_pct,
            'outperformance_pct': round(portfolio_return_pct - nifty_return_pct, 2),
            'nifty_stats': scenario_def.get('nifty_comparison', {})
        }
    }


def run_custom_scenario(portfolio, start, end):
    \"\"\"Fetch historical data and simulate a custom date range.\"\"\"
    import subprocess

    fetch_script = os.path.join(SCRIPT_DIR, 'fetch-historical.sh')

    if not os.path.exists(fetch_script):
        return {'error': f'fetch-historical.sh not found at {fetch_script}'}

    # Fetch Nifty 50 data
    try:
        result = subprocess.run(
            ['bash', fetch_script, '--index', 'nifty50', '--start', start, '--end', end],
            capture_output=True, text=True, timeout=60
        )
        nifty_data = json.loads(result.stdout)
    except Exception as e:
        return {'error': f'Failed to fetch Nifty data: {str(e)}'}

    if 'error' in nifty_data:
        return {'error': f'Nifty fetch failed: {nifty_data[\"error\"]}'}

    data_points = nifty_data.get('data', [])
    if len(data_points) < 2:
        return {'error': 'Insufficient historical data returned'}

    # Convert daily data to monthly returns
    monthly_returns = []
    current_month = None
    month_start_price = None

    for dp in data_points:
        date_str = dp['date']
        month_key = date_str[:7]  # YYYY-MM
        close = dp['close']

        if current_month != month_key:
            if current_month is not None and month_start_price and month_start_price > 0:
                monthly_ret = (close - month_start_price) / month_start_price
                monthly_returns.append(monthly_ret)
            current_month = month_key
            month_start_price = close

    # Handle last month
    if month_start_price and data_points and month_start_price > 0:
        last_close = data_points[-1]['close']
        monthly_ret = (last_close - month_start_price) / month_start_price
        monthly_returns.append(monthly_ret)

    if not monthly_returns:
        return {'error': 'Could not compute monthly returns from data'}

    # Build a pseudo-scenario from the monthly equity returns
    # For debt and gold, use conservative estimates
    n = len(monthly_returns)
    total_equity_return = 1.0
    for r in monthly_returns:
        total_equity_return *= (1 + r)
    total_equity_return -= 1

    custom_scenario = {
        'name': f'Custom: {start} to {end}',
        'period': {'start': start, 'end': end},
        'description': f'Custom backtest using live Nifty 50 data from {start} to {end}',
        'peak_to_trough_months': n,
        'recovery_months': 0,
        'asset_returns': {
            'equity': round(total_equity_return, 4),
            'debt': round(0.06 * (n / 12), 4),   # ~6% annual proxy
            'gold': round(0.08 * (n / 12), 4)    # ~8% annual proxy
        },
        'monthly_equity_path': monthly_returns,
        'monthly_debt_path': [0.005] * n,   # ~6% annual
        'monthly_gold_path': [0.0065] * n,  # ~8% annual
        'nifty_comparison': {
            'start_value': data_points[0]['close'],
            'end_value': data_points[-1]['close'],
            'return_pct': round(total_equity_return * 100, 2)
        }
    }

    return simulate_scenario(portfolio, 'custom', custom_scenario)


# ─── Main ─────────────────────────────────────────────────────────────────────

portfolio = load_portfolio(PORTFOLIO_FILE)
portfolio_source = PORTFOLIO_FILE if os.path.exists(PORTFOLIO_FILE) else 'default (60% equity, 30% debt, 10% gold)'

if RUN_ALL:
    # Run all pre-built scenarios
    results = {
        'portfolio_source': portfolio_source,
        'allocations': portfolio.get('allocations', {}),
        'initial_value': portfolio.get('initial_value', 1000000),
        'scenarios': {}
    }
    for key in SCENARIOS:
        res = simulate_scenario(portfolio, key, SCENARIOS[key])
        # Omit monthly_values for --all to keep output concise
        res.pop('monthly_values', None)
        results['scenarios'][key] = res

    # Summary table
    summary = []
    for key, res in results['scenarios'].items():
        p = res.get('portfolio', {})
        summary.append({
            'scenario': key,
            'max_drawdown_pct': p.get('max_drawdown_pct', 0),
            'recovery_months': p.get('recovery_months'),
            'final_value': p.get('final', 0),
            'cagr_pct': p.get('cagr_pct', 0),
            'vs_nifty_pct': res.get('comparison_vs_nifty', {}).get('outperformance_pct', 0)
        })
    results['summary'] = summary
    results['_meta'] = {
        'ran_at': time.strftime('%Y-%m-%d %H:%M:%S'),
        'engine': 'wealthstack-backtest-v1'
    }
    print(json.dumps(results, indent=2))

elif SCENARIO == 'custom':
    if not START_DATE or not END_DATE:
        print(json.dumps({
            'error': 'Custom scenario requires --start and --end dates.',
            'usage': 'backtest.sh --scenario custom --start 2022-01-01 --end 2023-06-30'
        }))
        sys.exit(1)
    result = run_custom_scenario(portfolio, START_DATE, END_DATE)
    result['portfolio_source'] = portfolio_source
    result['_meta'] = {
        'ran_at': time.strftime('%Y-%m-%d %H:%M:%S'),
        'engine': 'wealthstack-backtest-v1',
        'data_source': 'yfinance (live)'
    }
    print(json.dumps(result, indent=2))

elif SCENARIO:
    if SCENARIO not in SCENARIOS:
        print(json.dumps({
            'error': f'Unknown scenario: {SCENARIO}',
            'available': list(SCENARIOS.keys()),
            'hint': 'Use --scenario custom --start YYYY-MM-DD --end YYYY-MM-DD for custom ranges.'
        }))
        sys.exit(1)
    result = simulate_scenario(portfolio, SCENARIO, SCENARIOS[SCENARIO])
    result['portfolio_source'] = portfolio_source
    result['_meta'] = {
        'ran_at': time.strftime('%Y-%m-%d %H:%M:%S'),
        'engine': 'wealthstack-backtest-v1'
    }
    print(json.dumps(result, indent=2))

else:
    # No scenario specified — show usage and available scenarios
    info = {
        'usage': [
            'backtest.sh --scenario 2020-covid',
            'backtest.sh --scenario custom --start 2022-01-01 --end 2023-06-30',
            'backtest.sh --all',
            'backtest.sh path/to/portfolio.json 2008-gfc'
        ],
        'available_scenarios': {},
        'portfolio_loaded': portfolio_source,
        'allocations': portfolio.get('allocations', {}),
        'initial_value': portfolio.get('initial_value', 1000000)
    }
    for key, s in SCENARIOS.items():
        info['available_scenarios'][key] = {
            'name': s['name'],
            'period': s['period'],
            'equity_drawdown': str(round(s['asset_returns']['equity'] * 100)) + '%',
            'description': s['description']
        }
    print(json.dumps(info, indent=2))
" 2>/dev/null || echo '{"error": "Python3 execution failed"}'
