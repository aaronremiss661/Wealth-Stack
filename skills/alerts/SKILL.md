---
name: alerts
description: Portfolio alert scanner — checks for drift, concentration risk, tax harvesting opportunities, NAV drops, and SIP reminders. Use when asked to check portfolio health or scan for issues.
context: fork
agent: portfolio-analyzer
allowed-tools: Bash, Read, Write, Grep, Glob
---

# Portfolio Alerts

Scan the user's portfolio for automated health checks and actionable alerts.

## Step 1: Run Alert Scanner

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-alerts.sh
```

If no enriched portfolio exists, first:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/enrich-portfolio.sh
```

## Step 2: Analyze Results

Parse the JSON output and present alerts by severity:

### Critical (High Severity)
- **Concentration > 20%**: Single holding exceeds safe concentration limit
- **Drift > 10%**: Asset class significantly off-target
- **NAV Drop > 20%**: Major decline from recent high

### Warning (Medium Severity)
- **Concentration 10-20%**: Approaching concentration limit
- **Top 5 > 50%**: Portfolio too top-heavy
- **Drift 5-10%**: Moderate allocation drift
- **Stale Data**: Portfolio prices more than 30 days old

### Opportunities (Low Severity)
- **Tax-Loss Harvesting**: Holdings down >10% — potential to book losses
- **SIP Reminder**: Monthly SIP processing window

## Step 3: Present Health Score

Display the portfolio health score (0-100):
- **90-100**: Excellent — no action needed
- **70-89**: Good — minor issues to watch
- **50-69**: Fair — attention needed
- **Below 50**: Poor — immediate action recommended

## Step 4: Action Plan

For each alert, provide:
1. What the issue is (plain language)
2. Why it matters (risk/opportunity)
3. Specific action to take (with amounts where applicable)
4. Relevant skill to use next (e.g., `/rebalance` for drift, `/tax-optimize` for harvesting)

## Step 5: Next Steps

Based on alerts found, recommend:
- Drift alerts → `/rebalance`
- Concentration → `/portfolio` for detailed analysis
- Tax harvesting → `/tax-optimize`
- Stale data → Re-import and enrich portfolio
