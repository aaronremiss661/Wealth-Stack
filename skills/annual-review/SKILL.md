---
name: annual-review
description: Comprehensive annual portfolio review — chains portfolio analysis, tax optimization, rebalancing, compliance check, and client report generation into a single workflow.
context: fork
agent: portfolio-analyzer
allowed-tools: Bash, Read, Write, Grep, Glob, WebSearch
---

# Annual Portfolio Review

Run a comprehensive end-of-year (or periodic) portfolio review that chains multiple analysis steps.

## Workflow Chain

### Phase 1: Portfolio Snapshot
Load and analyze the current portfolio state.

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/enrich-portfolio.sh
```

Present:
- Total portfolio value and YTD return
- Holdings breakdown by asset class
- Top/bottom performers
- Cash position

### Phase 2: Performance Attribution
Analyze what drove returns this year.

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/portfolio-xirr.sh
```

Break down:
- XIRR for overall portfolio and each holding
- Benchmark comparison (vs Nifty 50, category benchmarks)
- Sector-wise attribution
- Impact of new investments vs market movement

### Phase 3: Risk Assessment
Evaluate portfolio risk metrics.

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/monte-carlo.sh $(total_value) $(equity_pct) $(debt_pct) $(gold_pct) 10
```

Present:
- Current risk level vs target risk profile
- Concentration analysis
- Volatility metrics
- Stress test results (what happens in a 2008/2020 scenario)

### Phase 4: Tax Optimization Review

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/tax-lot-optimizer.sh
```

Identify:
- Realized gains/losses for the FY
- LTCG vs STCG breakdown
- Tax-loss harvesting opportunities before March 31
- ELSS investments for 80C
- Estimated tax liability

### Phase 5: Drift & Rebalancing

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/drift-analyzer.sh
```

Show:
- Current vs target allocation
- Drift by asset class
- Recommended rebalancing trades
- Tax impact of rebalancing

### Phase 6: Alert Scan

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-alerts.sh
```

Flag:
- Any concentration breaches
- Compliance issues
- Pending actions

### Phase 7: Forward Projections

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/goal-gap-analyzer.sh
```

Project:
- Are financial goals on track?
- SIP adequacy check
- Any shortfalls requiring attention

### Phase 8: Generate Report

Compile all findings into a structured review report:

```
ANNUAL PORTFOLIO REVIEW — {YEAR}
══════════════════════════════════════════
Client: {name}
Review Date: {date}
Portfolio Value: Rs {value}

1. PERFORMANCE SUMMARY
   - Total Return: X%
   - XIRR: X%
   - Benchmark: Nifty 50 returned X%

2. ALLOCATION STATUS
   - Current allocation table
   - Drift from target

3. TAX SUMMARY
   - LTCG: Rs X (tax: Rs Y)
   - STCG: Rs X (tax: Rs Y)
   - Harvesting opportunities: Rs X

4. RISK METRICS
   - Health Score: X/100
   - Key alerts: [list]

5. GOAL TRACKING
   - Goals on track: X of Y
   - Shortfalls: [list]

6. RECOMMENDATIONS
   - [Prioritized action items]
══════════════════════════════════════════
```

Save report to `~/.wealthstack/reports/annual-review-{date}.md`.

## Step 9: Next Steps

Offer to execute specific recommendations:
- `/rebalance` — Execute rebalancing trades
- `/tax-optimize` — Implement tax-loss harvesting
- `/goal-planner` — Adjust goals and SIPs
- `/client-report` — Generate formatted client report
