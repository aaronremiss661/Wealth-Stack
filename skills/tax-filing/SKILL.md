---
name: tax-filing
description: ITR preparation helper — 80C/80D/80G optimization, old vs new regime comparison, advance tax calculation. Use for tax filing or deduction optimization.
context: fork
agent: tax-strategist
---

# Tax Filing Helper

## Step 1: Basic Details

Ask the user:
1. Total income (salary + business + capital gains + other)
2. Filing status (Individual / HUF)
3. Age bracket (<60 / 60-80 / 80+)
4. Old regime or new regime? (or want comparison)

## Step 2: Old vs New Regime Comparison

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/tax-calculator.sh INCOME REGIME AGE
```

**New Regime (default from FY 2023-24):**
- Standard deduction: Rs 75,000
- No 80C/80D/HRA deductions (except NPS 80CCD(2))
- Lower slab rates

**Old Regime:**
- 80C: up to Rs 1.5L (ELSS, PPF, EPF, NSC, tuition, life insurance)
- 80D: health insurance premium (Rs 25K self, Rs 50K for parents 60+)
- 80CCD(1B): NPS additional Rs 50K
- 80G: donations (50% or 100%)
- 80E: education loan interest
- 80TTA/80TTB: savings interest deduction
- HRA exemption
- Home loan: Section 24(b) up to Rs 2L interest, 80C up to Rs 1.5L principal

Compare total tax under both regimes. Recommend the lower one.

## Step 3: Advance Tax

If tax liability > Rs 10,000, calculate advance tax schedule:
- 15% by June 15
- 45% by Sep 15
- 75% by Dec 15
- 100% by Mar 15

## Step 4: Capital Gains Summary

From portfolio data, compute:
- Short-term equity gains (STCG 20%)
- Long-term equity gains (LTCG 12.5% above Rs 1.25L)
- Debt/other gains (slab rate)
- Losses to carry forward (up to 8 years)

## Step 5: Checklist

- [ ] Form 16 from employer
- [ ] AIS (Annual Information Statement) from income tax portal
- [ ] Capital gains statement from broker (Zerodha P&L, etc.)
- [ ] Rent receipts (if claiming HRA)
- [ ] Insurance premium receipts (80C/80D)
- [ ] Donation receipts (80G)
- [ ] Home loan certificate

Disclaimer: "Consult a CA for personalized tax advice."
