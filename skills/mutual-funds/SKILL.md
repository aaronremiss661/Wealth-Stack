---
name: mutual-funds
description: Mutual fund screening, comparison, and SIP tracking. Direct vs regular plan analysis, expense ratio comparison, category analysis. Use for MF selection or review.
context: fork
agent: portfolio-analyzer
---

# Mutual Fund Analysis

## Step 1: What Do You Need?

Ask the user:
- A) Screen MFs — find the best fund in a category
- B) Compare funds — side-by-side comparison
- C) Review my MF portfolio — analyze existing MF holdings
- D) Direct vs Regular — show savings from switching

## Screening

Search the web for latest fund data from AMFI, Value Research, or Morningstar India.

**Categories**: Large Cap, Mid Cap, Small Cap, Flexi Cap, ELSS, Index Fund, Debt (Liquid, Short Duration, Gilt, Corporate Bond), Hybrid, International.

**Screening criteria**:
- AUM > Rs 1,000 Cr (for equity)
- Expense ratio (direct plan)
- 3yr/5yr CAGR vs category average and benchmark
- Consistency (rolling returns)
- Fund manager tenure and track record
- Sharpe ratio and standard deviation

## Direct vs Regular Analysis

For each fund held in regular plan:
- Regular plan ER vs Direct plan ER
- Annual savings per Rs 1L invested
- 10-year compounding difference
- How to switch (systematic transfer or redemption + fresh SIP)

## SIP Tracking

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/fetch-mf-nav.sh SCHEME_CODE
```

Track SIP performance: invested amount, current value, XIRR, absolute return.

Present all amounts in Rs with Indian numbering.
