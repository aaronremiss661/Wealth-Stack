---
name: portfolio
description: Portfolio analysis — holdings, allocation, performance, concentration risk. Use when analyzing investments, reviewing allocation, or asking about portfolio.
context: fork
agent: portfolio-analyzer
---

# Portfolio Analysis

Analyze the user's investment portfolio.

## Step 1: Get Portfolio Data

Ask the user how they want to provide portfolio data:
- A) Upload a CSV file (Zerodha Console, Groww, Angel One, or custom format with columns: ticker, shares, cost_basis)
- B) Paste holdings manually (format: TICKER SHARES COST_BASIS)
- C) Load from saved portfolio in `~/.wealthstack/portfolios/`

Parse the data. For NSE stocks, append `.NS` to tickers. Save to `~/.wealthstack/portfolios/`.

## Step 2: Fetch Market Data

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/fetch-quotes.sh TICKER1.NS TICKER2.NS ...
```

## Step 3: Analyze

Compute and present:
- **Holdings table**: Ticker, Shares, Cost Basis, Current Value, Gain/Loss (%), Weight
- **Allocation**: By asset class, sector (BFSI/IT/Pharma/Auto/FMCG etc.), market cap (large/mid/small)
- **Performance**: Total return, XIRR, top/bottom performers, benchmark comparison vs Nifty 50
- **Concentration flags**: Single stock >10%, single sector >30%, top 5 >50%

## Step 4: Recommendations

Provide actionable recommendations: diversification gaps, overweight positions, high expense ratio funds to replace, tax-loss harvesting candidates.

Present all amounts in INR (Rs) with Indian numbering (lakhs, crores).

## Step 5: Next Steps

Offer: `/wealthstack:risk-assess`, `/wealthstack:rebalance`, `/wealthstack:tax-optimize`, `/wealthstack:client-report`
