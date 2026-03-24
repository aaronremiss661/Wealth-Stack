---
name: rebalance
version: 1.0.0
description: |
  Portfolio rebalancing. Drift analysis against target allocation, trade generation
  to restore targets, tax-aware rebalancing, and threshold-based monitoring.
  Use when asked to "rebalance", "fix allocation", "drift analysis", or
  "get back to target".
allowed-tools:
  - Bash
  - Read
  - Write
  - Agent
  - WebSearch
  - AskUserQuestion
---

# /rebalance — Portfolio Rebalancing

Analyze allocation drift and generate trades to restore target weights.

## Phase 1: Load Portfolio & Target Allocation

Load portfolio from `~/.wealth-mgmt/portfolios/`.

Check if a target allocation exists at `~/.wealth-mgmt/target-allocation.json`.

If no target exists, ask the user via AskUserQuestion:

"What target allocation would you like? Choose a preset or define custom."
- A) Conservative: 30% Equity / 60% Fixed Income / 10% Cash
- B) Moderate: 60% Equity / 30% Fixed Income / 10% Cash
- C) Growth: 80% Equity / 15% Fixed Income / 5% Cash
- D) Aggressive: 95% Equity / 5% Cash
- E) Custom — I'll define my own targets

If Custom: ask for each asset class target as percentages summing to 100%.

Save target to `~/.wealth-mgmt/target-allocation.json`.

## Phase 2: Drift Analysis

Compare current allocation to target:

| Asset Class | Target | Current | Drift | Status |
|------------|--------|---------|-------|--------|
| US Equity | 50% | 57% | +7% | OVER |
| Intl Equity | 20% | 15% | -5% | UNDER |
| Fixed Income | 25% | 23% | -2% | OK |
| Cash | 5% | 5% | 0% | OK |

Flag any drift exceeding the rebalancing threshold (default: 5%).

## Phase 3: Rebalancing Strategy

Use AskUserQuestion:

"How would you like to rebalance?"
- A) Full rebalance — sell overweight, buy underweight (generates taxable events)
- B) Cash-flow rebalance — direct new contributions to underweight areas only
- C) Tax-aware rebalance — minimize taxable gains while reducing drift
- D) Threshold-only — only rebalance positions drifting more than 5%

## Phase 4: Trade Generation

Based on the chosen strategy, calculate specific trades:

```
REBALANCING TRADES
══════════════════════════════════════════
SELL:
  AAPL    -25 shares   ($4,250)   Reduces US Equity from 57% → 50%
  QQQ     -10 shares   ($4,850)   Reduces Tech concentration

BUY:
  VXUS    +40 shares   ($2,400)   Increases Intl Equity from 15% → 20%
  BND     +30 shares   ($2,100)   Increases Fixed Income from 23% → 25%
  VWO     +50 shares   ($2,100)   Adds Emerging Markets exposure

NET CASH FLOW: -$2,500 (excess moves to cash)
══════════════════════════════════════════
```

### Tax-Aware Considerations

If tax-aware strategy selected:
- Prioritize selling lots with losses (harvest while rebalancing)
- Avoid selling short-term gain positions if possible
- Flag any wash sale concerns from recent trades
- Show estimated tax impact of each sell trade

## Phase 5: Post-Rebalance Projection

Show what the portfolio looks like after executing the trades:

| Asset Class | Before | After | Target | Remaining Drift |
|------------|--------|-------|--------|----------------|

## Phase 6: Confirm & Save

Use AskUserQuestion:

"Ready to proceed?"
- A) Save trade list — I'll execute manually
- B) Adjust trades — modify before saving
- C) Run `/tax-optimize` first — check tax impact in detail
- D) Run `/client-report` — include rebalancing plan in client report

Save the rebalancing plan to `~/.wealth-mgmt/reports/rebalance-<date>.json`.
