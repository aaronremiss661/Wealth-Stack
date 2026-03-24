#!/usr/bin/env bash
# calc-returns.sh — Calculate portfolio returns and risk metrics
# Usage: calc-returns.sh --portfolio <path-to-portfolio.json>
# Returns JSON with performance metrics.

set -euo pipefail

PORTFOLIO_PATH=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --portfolio) PORTFOLIO_PATH="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [ -z "$PORTFOLIO_PATH" ]; then
  # Try default location
  PORTFOLIO_PATH="$HOME/.wealth-mgmt/portfolios/current.json"
  if [ ! -f "$PORTFOLIO_PATH" ]; then
    echo '{"error": "No portfolio specified. Usage: calc-returns.sh --portfolio <path>"}' >&2
    exit 1
  fi
fi

if [ ! -f "$PORTFOLIO_PATH" ]; then
  echo "{\"error\": \"Portfolio file not found: $PORTFOLIO_PATH\"}" >&2
  exit 1
fi

python3 << PYEOF
import json
import sys
import os
from datetime import datetime

portfolio_path = "$PORTFOLIO_PATH"

with open(portfolio_path, "r") as f:
    portfolio = json.load(f)

holdings = portfolio.get("holdings", [])
cash = portfolio.get("cash", {})
cash_amount = cash.get("amount", 0) if isinstance(cash, dict) else cash

# Calculate portfolio-level metrics
total_cost_basis = 0
total_current_value = 0
results = {"holdings": [], "summary": {}}

for h in holdings:
    ticker = h.get("ticker", "")
    shares = h.get("shares", 0)
    cost_basis = h.get("cost_basis", 0)

    # Try to load cached price
    cache_file = os.path.expanduser(f"~/.wealth-mgmt/cache/{ticker}.json")
    current_price = 0
    if os.path.exists(cache_file):
        with open(cache_file, "r") as f:
            cached = json.load(f)
            current_price = cached.get("price", 0) or 0

    current_value = shares * current_price if current_price else 0
    gain_loss = current_value - cost_basis if current_value else 0
    gain_loss_pct = (gain_loss / cost_basis * 100) if cost_basis > 0 else 0

    holding_result = {
        "ticker": ticker,
        "shares": shares,
        "cost_basis": cost_basis,
        "current_price": current_price,
        "current_value": current_value,
        "gain_loss": round(gain_loss, 2),
        "gain_loss_pct": round(gain_loss_pct, 2),
    }
    results["holdings"].append(holding_result)

    total_cost_basis += cost_basis
    total_current_value += current_value

total_current_value += cash_amount
total_gain_loss = total_current_value - total_cost_basis - cash_amount
total_gain_loss_pct = (total_gain_loss / total_cost_basis * 100) if total_cost_basis > 0 else 0

# Calculate weights
for h in results["holdings"]:
    h["weight"] = round(h["current_value"] / total_current_value * 100, 2) if total_current_value > 0 else 0

cash_weight = round(cash_amount / total_current_value * 100, 2) if total_current_value > 0 else 0

# Sort by weight descending
results["holdings"].sort(key=lambda x: x["weight"], reverse=True)

# Top/bottom performers
sorted_by_return = sorted(results["holdings"], key=lambda x: x["gain_loss_pct"], reverse=True)
top_performers = sorted_by_return[:3] if len(sorted_by_return) >= 3 else sorted_by_return
bottom_performers = sorted_by_return[-3:] if len(sorted_by_return) >= 3 else []

results["summary"] = {
    "total_cost_basis": round(total_cost_basis, 2),
    "total_current_value": round(total_current_value, 2),
    "cash": round(cash_amount, 2),
    "cash_weight": cash_weight,
    "total_gain_loss": round(total_gain_loss, 2),
    "total_gain_loss_pct": round(total_gain_loss_pct, 2),
    "num_holdings": len(holdings),
    "top_performers": [{"ticker": h["ticker"], "return_pct": h["gain_loss_pct"]} for h in top_performers],
    "bottom_performers": [{"ticker": h["ticker"], "return_pct": h["gain_loss_pct"]} for h in bottom_performers],
    "calculated_at": datetime.utcnow().isoformat() + "Z"
}

# Concentration flags
concentration_flags = []
for h in results["holdings"]:
    if h["weight"] > 10:
        concentration_flags.append(f"{h['ticker']} is {h['weight']}% of portfolio (>10% threshold)")
results["summary"]["concentration_flags"] = concentration_flags

print(json.dumps(results, indent=2))
PYEOF
