---
name: client-report
description: Generate professional HTML client portfolio reports. Use when asked for client report, portfolio summary, or preparing for a client meeting.
disable-model-invocation: true
context: fork
agent: portfolio-analyzer
---

# Client Report Generator

## Step 1: Report Type

Ask the user:
- A) Quarterly Review — full portfolio + performance + outlook
- B) Rebalancing Proposal — current state + recommended changes
- C) Tax Planning — year-end tax optimization summary
- D) Financial Plan Update — progress toward goals

Ask for: client name (or "Personal"), report period.

## Step 2: Gather Data

Load from `~/.wealthstack/`:
- `portfolios/` — holdings data
- `risk-profile.json` — risk assessment
- `target-allocation.json` — target allocation
- `reports/` — previous analyses

## Step 3: Generate HTML Report

Create a professional report at `~/.wealthstack/reports/client-report-{date}.html` with:

1. **Executive Summary** — value, period return, 1-3 key highlights
2. **Holdings Table** — ticker, shares, value, weight, gain/loss
3. **Allocation** — asset class, sector, market cap breakdown
4. **Performance** — vs Nifty 50 benchmark, attribution
5. **Risk Dashboard** — beta, Sharpe, volatility, max drawdown
6. **Recommendations** — rebalancing, tax harvesting, concentration fixes

Style: professional dark theme, INR formatting (Rs with Indian numbering), responsive HTML.

## Step 4: Deliver

Open in browser: `open ~/.wealthstack/reports/client-report-{date}.html`
