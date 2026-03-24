---
name: fd-bonds
description: Fixed deposit rate comparison, bond analysis, NCD evaluation, SGBs, tax-free bonds. Use for FD comparison, bond investing, or fixed income allocation.
context: fork
agent: portfolio-analyzer
---

# FD & Bond Analysis

## Step 1: What Do You Need?

Ask the user:
- A) Compare FD rates across banks
- B) Bond/NCD evaluation
- C) SGB (Sovereign Gold Bond) analysis
- D) Tax-free bond assessment
- E) Debt portfolio optimization

## FD Comparison

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/fd-compare.sh
```

Search the web for latest FD rates from: SBI, HDFC Bank, ICICI Bank, Kotak, Axis, small finance banks (Ujjivan, Equitas, AU SFB), corporate FDs (HDFC Ltd, Bajaj Finance, Mahindra Finance).

Compare: rate, tenure, senior citizen premium, tax treatment (TDS above Rs 40K), premature withdrawal penalty.

## Bond/NCD Analysis

For any bond/NCD: coupon rate, yield to maturity, credit rating (CRISIL/ICRA/CARE), maturity date, call/put options, liquidity.

Post-tax yield comparison: FD vs NCD vs debt MF at client's tax slab.

## SGBs

- Current tranche price and gold price premium/discount
- 2.5% annual interest (taxable)
- LTCG tax-free if held to maturity (8 years)
- Exit after 5th year allowed
- Listed on NSE/BSE (secondary market, may trade at premium/discount)

## Tax-Free Bonds

NHAI, REC, PFC, IRFC — listed, secondary market only.
Tax-free interest, effective yield comparison with taxable instruments at client's slab.
