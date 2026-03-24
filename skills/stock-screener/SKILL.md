---
name: stock-screener
description: NSE/BSE stock screening by fundamentals — PE ratio, ROE, debt-to-equity, dividend yield, market cap. Use when screening or filtering stocks.
context: fork
agent: portfolio-analyzer
---

# Stock Screener

## Step 1: Screening Criteria

Ask the user what they're looking for:
- A) Value stocks — low PE, high dividend yield
- B) Quality stocks — high ROE, low debt, consistent earnings
- C) Growth stocks — high revenue/earnings growth
- D) Dividend stocks — high and consistent dividend yield
- E) Custom screen — define your own criteria

## Preset Screens

**Value**: PE < 15, PB < 2, Dividend Yield > 2%, Market Cap > Rs 5,000 Cr
**Quality**: ROE > 15%, Debt/Equity < 0.5, 5yr Profit CAGR > 10%, Market Cap > Rs 10,000 Cr
**Growth**: Revenue CAGR 5yr > 15%, EPS CAGR 5yr > 15%, Market Cap > Rs 2,000 Cr
**Dividend**: Dividend Yield > 3%, Payout consistent 5yr+, No dividend cut in 5yr

## Step 2: Data

Search the web for data from Screener.in, Trendlyne, or Ticker Tape.

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/nse-screener.sh SCREEN_TYPE
```

## Step 3: Results

Present as a sorted table:
| Stock | CMP | Market Cap | PE | ROE | Debt/Eq | Div Yield | 5yr CAGR |

Include sector classification and Nifty index membership.

## Step 4: Analysis

For top 5 results, provide brief analysis: business quality, competitive moat, recent developments, risk factors.

Disclaimer: "Stock screening is for research purposes. This is not a buy/sell recommendation."
