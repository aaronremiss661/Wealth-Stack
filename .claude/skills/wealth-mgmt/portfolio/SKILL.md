---
name: portfolio
version: 1.0.0
description: |
  Portfolio analysis and management. Analyze holdings, asset allocation,
  performance attribution, sector/geographic exposure, and concentration risk.
  Use when asked to "analyze portfolio", "show allocation", "portfolio performance",
  or "what do I hold".
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Agent
  - WebSearch
  - AskUserQuestion
---

# /portfolio — Portfolio Analysis

Analyze investment portfolios: holdings, allocation, performance, and risk exposure.

## Phase 1: Portfolio Ingestion

First, determine how the user wants to provide portfolio data.

Use AskUserQuestion:
- Question: "How would you like to provide your portfolio data?"
- Options:
  - A) Upload a CSV file (columns: ticker, shares, cost_basis)
  - B) Paste holdings manually
  - C) Load from saved portfolio in ~/.wealth-mgmt/portfolios/

### If CSV (Option A):
Ask for the file path, then parse it:

```bash
bash ${CLAUDE_SKILL_DIR}/../bin/import-portfolio.sh "<file-path>"
```

### If Manual (Option B):
Ask the user to list holdings in format: `TICKER SHARES COST_BASIS`
Example: `AAPL 100 15000`

Save to `~/.wealth-mgmt/portfolios/manual-<date>.json`.

### If Saved (Option C):
```bash
ls ~/.wealth-mgmt/portfolios/ 2>/dev/null || echo "NO_PORTFOLIOS"
```
Let the user pick one.

## Phase 2: Market Data Enrichment

Fetch current prices for all holdings:

```bash
bash ${CLAUDE_SKILL_DIR}/../bin/fetch-quotes.sh <TICKER1> <TICKER2> ...
```

This returns JSON with current price, day change, 52-week range, sector, and market cap.

## Phase 3: Portfolio Analysis

Using the holdings and market data, compute and present:

### Holdings Table

| Ticker | Shares | Cost Basis | Current Value | Gain/Loss | Weight |
|--------|--------|-----------|---------------|-----------|--------|

### Asset Allocation Breakdown

Classify each holding by:
- **Asset class:** Equity, Fixed Income, Cash, Alternatives, Real Estate
- **Sector:** Technology, Healthcare, Financials, Consumer, Energy, etc.
- **Geography:** US, International Developed, Emerging Markets
- **Market cap:** Large, Mid, Small

Present pie-chart-style breakdowns for each dimension.

### Performance Metrics

Calculate using the `calc-returns.sh` command:

```bash
bash ${CLAUDE_SKILL_DIR}/../bin/calc-returns.sh --portfolio "<portfolio-json-path>"
```

Report:
- **Total return** (absolute and percentage)
- **Unrealized gain/loss** per holding
- **Portfolio yield** (if dividend data available)
- **Top/bottom performers**

### Concentration Risk

Flag any:
- Single holding > 10% of portfolio
- Single sector > 30% of portfolio
- Single asset class > 80% of portfolio (unless intentional)

## Phase 4: Recommendations

Based on the analysis, use the **Portfolio Analyzer** subagent for deep analysis:

Invoke the Agent tool with this prompt:
> You are a Portfolio Analyzer subagent. Review the following portfolio data and provide:
> 1. Key strengths of the current allocation
> 2. Concentration risks or gaps
> 3. Diversification opportunities
> 4. Holdings that may warrant further review
>
> Portfolio: [insert portfolio JSON]
> Market data: [insert enriched data]

Present the subagent's findings as actionable recommendations.

## Phase 5: Save & Export

Save the analysis to `~/.wealth-mgmt/portfolios/` and offer:
- A) Save analysis for future reference
- B) Run `/risk-assess` for deeper risk analysis
- C) Run `/rebalance` to optimize allocation
- D) Run `/client-report` to generate a client-facing report
