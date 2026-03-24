---
name: tax-optimize
description: Tax optimization — LTCG/STCG harvesting, wash sale detection, lot-level optimization, old vs new regime comparison. Use for tax-loss harvesting or capital gains strategy.
context: fork
agent: tax-strategist
---

# Tax Optimization

## Step 1: Tax Context

Ask the user:
1. Filing status (Individual / HUF / both)
2. Marginal tax rate (10-12% / 22-24% / 32-35% / 37%)
3. Realized capital gains this year (none / short-term / long-term / both)
4. Old regime or new regime

## Step 2: Tax-Loss Harvesting

Load portfolio from `~/.wealthstack/portfolios/`. For each holding with unrealized loss:
- Loss amount, type (STCG <12mo / LTCG >12mo)
- Tax savings at client's rate (equity LTCG 12.5% above Rs 1.25L, STCG 20%)
- Replacement security suggestion (avoids wash sale)
- 30-day wash sale window check

## Step 3: Gain Management

- Flag holdings approaching 1-year mark (STCG→LTCG transition)
- Pair gains with harvestable losses
- LTCG stacking: use Rs 1.25L exemption per PAN (individual + HUF = Rs 2.5L)

## Step 4: Lot Optimization

Compare FIFO vs HIFO vs specific lot identification for partial sells.

## Step 5: Summary

```
TAX OPTIMIZATION SUMMARY
══════════════════════════════════════════
Total Harvestable Losses:     Rs XX,XXX
  Short-term losses:          Rs XX,XXX
  Long-term losses:           Rs XX,XXX
Estimated Tax Savings:        Rs X,XXX
══════════════════════════════════════════
```

Include disclaimer: consult a qualified CA before implementing.
