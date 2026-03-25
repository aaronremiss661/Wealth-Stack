---
name: market-shock
description: Market shock response workflow — chains market brief, risk assessment, alert check, and rebalancing recommendations for rapid response during market volatility.
context: fork
agent: market-researcher
allowed-tools: Bash, Read, Write, Grep, Glob, WebSearch
---

# Market Shock Response

Rapid-response workflow for significant market events (crash, flash crash, geopolitical event, policy surprise).

## Trigger Conditions
Use this skill when:
- Nifty/Sensex drops >3% in a single session
- Major geopolitical event (war, sanctions, trade war)
- RBI surprise policy action
- Global contagion event (US recession, China crisis, banking crisis)
- Currency shock (INR >2% move in a day)

## Workflow Chain

### Phase 1: Market Brief
Get the current market state immediately.

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/fetch-indices.sh
bash ${CLAUDE_PLUGIN_ROOT}/scripts/fetch-fii-dii.sh
```

Search web for the latest:
- What triggered the market move
- Global market context (US futures, Europe, Asia)
- FII/DII activity today
- India VIX level

Present a 5-line situation summary.

### Phase 2: Portfolio Impact Assessment

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/enrich-portfolio.sh
bash ${CLAUDE_PLUGIN_ROOT}/scripts/check-alerts.sh
```

Calculate:
- Portfolio value change today (estimated from index moves if real-time not available)
- Most impacted holdings
- Sector-wise impact
- Comparison to portfolio's historical drawdowns

### Phase 3: Historical Context

Read relevant scenario files:
```bash
cat ${CLAUDE_PLUGIN_ROOT}/knowledge/scenarios/*.md
```

Compare current event to historical parallels:
- How similar events played out (drawdown, duration, recovery)
- What worked/didn't work as a response
- Sector rotation patterns that followed

### Phase 4: Risk Check

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/monte-carlo.sh $(total_value) $(equity_pct) $(debt_pct) $(gold_pct) 5
```

Present:
- Updated probability distribution given current volatility
- Worst-case scenario analysis
- Whether current allocation can withstand further downside

### Phase 5: Action Recommendations

Based on severity, recommend one of:

**HOLD — Minor Correction (<5%)**:
- Don't panic — this is normal volatility
- Review if SIPs are running (let them benefit from lower prices)
- Check for tax-loss harvesting opportunities

**WATCH — Moderate Drop (5-15%)**:
- Review asset allocation — consider tactical rebalancing
- Deploy cash buffer into equity if available
- Increase SIP amounts temporarily (buy the dip with discipline)
- Avoid selling quality holdings

**ACT — Major Crash (>15%)**:
- Rebalance: sell some debt/gold to buy equity (buy low)
- Deploy emergency deployment capital (if pre-planned)
- Prioritize quality large-caps over mid/small
- Extend investment horizon expectations
- Review stop-losses on speculative positions

### Phase 6: Client Communication Template

Generate a client communication template:

```
MARKET UPDATE — {DATE}
══════════════════════════════════════════
Dear {Client},

WHAT HAPPENED:
[1-2 sentence summary of the event]

YOUR PORTFOLIO IMPACT:
[Estimated impact with specific numbers]

OUR ASSESSMENT:
[Severity: Minor/Moderate/Major]
[Historical parallel and expected recovery]

RECOMMENDED ACTIONS:
1. [Most important action]
2. [Second action]
3. [Third action]

WHAT WE'RE NOT DOING:
- Not panic selling quality holdings
- Not timing the bottom — deploying systematically

We're monitoring the situation closely.
══════════════════════════════════════════
```

Save to `~/.wealthstack/reports/market-shock-{date}.md`.

### Phase 7: Follow-Up Schedule

Set follow-up checkpoints:
- 24 hours: Re-assess if situation has stabilized
- 1 week: Check if portfolio has recovered
- 1 month: Full review of actions taken
