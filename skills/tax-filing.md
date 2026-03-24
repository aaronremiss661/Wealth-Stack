
# /tax-filing — Income Tax Filing Assistant

Optimize your taxes. Old vs new regime. Maximize deductions. Never miss a deadline.

## Phase 1: Income Profile

Ask the user:

### Question 1: Income Type
"What are your income sources? (pick all)"
- A) Salary income
- B) Business / professional income
- C) Capital gains (stocks, MFs, property)
- D) Rental income
- E) Interest income (FD, savings, bonds)
- F) Dividend income
- G) Foreign income (for NRIs / global income)

### Question 2: Salary Details (if applicable)
"What is your annual CTC / gross salary?"

### Question 3: Regime Preference
"Which tax regime are you currently on?"
- A) Old regime (with deductions)
- B) New regime (lower rates, fewer deductions)
- C) Not sure — help me decide

## Phase 2: Old vs New Regime Comparison

### Tax Slabs (FY 2025-26)

**New Regime (default):**
| Income Slab | Rate |
|-------------|------|
| Up to Rs 4L | 0% |
| Rs 4-8L | 5% |
| Rs 8-12L | 10% |
| Rs 12-16L | 15% |
| Rs 16-20L | 20% |
| Rs 20-24L | 25% |
| Above Rs 24L | 30% |
| Standard deduction: Rs 75,000 |

**Old Regime:**
| Income Slab | Rate |
|-------------|------|
| Up to Rs 2.5L | 0% |
| Rs 2.5-5L | 5% |
| Rs 5-10L | 20% |
| Above Rs 10L | 30% |

```bash
bash commands/tax-calculator.sh --income <amount> --regime both
```

### Comparison Output

```
OLD vs NEW REGIME COMPARISON
══════════════════════════════════════════
Gross Salary:              Rs 25,00,000

OLD REGIME:
  Gross Income:            Rs 25,00,000
  - Standard deduction:    Rs 50,000
  - 80C (max):             Rs 1,50,000
  - 80D (health):          Rs 25,000
  - HRA exemption:         Rs 2,40,000
  - Home loan interest:    Rs 2,00,000
  - NPS 80CCD(1B):         Rs 50,000
  ─────────────────────────────────────
  Taxable income:          Rs 17,85,000
  Tax:                     Rs 3,19,500
  + Cess 4%:               Rs 12,780
  TOTAL TAX:               Rs 3,32,280

NEW REGIME:
  Gross Income:            Rs 25,00,000
  - Standard deduction:    Rs 75,000
  ─────────────────────────────────────
  Taxable income:          Rs 24,25,000
  Tax:                     Rs 4,81,250
  + Cess 4%:               Rs 19,250
  TOTAL TAX:               Rs 5,00,500

══════════════════════════════════════════
VERDICT: OLD REGIME saves Rs 1,68,220
  (only if you claim all deductions above)
══════════════════════════════════════════
```

## Phase 3: Section 80C Optimization

```
80C UTILIZATION — MAX Rs 1,50,000
══════════════════════════════════════════
Instrument              Amount    Status
──────────────────────────────────────────
EPF (employer)          Rs 72,000   ✓ Auto
PPF                     Rs 50,000   ✓ Invested
ELSS (tax-saving MF)    Rs 0        ← GAP
Term life premium       Rs 14,500   ✓ Paid
Children tuition        Rs 0        ← Check
Home loan principal     Rs 0        ← Check
NPS 80CCD(1) (within 80C) Rs 0     ← Consider
──────────────────────────────────────────
UTILIZED:               Rs 1,36,500
REMAINING:              Rs 13,500
══════════════════════════════════════════

RECOMMENDATION:
  Invest Rs 13,500 in ELSS via SIP
  Top ELSS funds: Quant ELSS, Mirae Asset ELSS, Canara Robeco ELSS
  Lock-in: 3 years (shortest among 80C options)

ADDITIONAL DEDUCTIONS (beyond 80C):
  80CCD(1B) — NPS:      Rs 50,000 extra deduction
  80D — Health premium:  Rs 25,000 (self) + Rs 50,000 (parents 60+)
  80E — Education loan:  Interest (no limit)
  80G — Donations:       50%/100% deduction
  80TTA — Savings interest: Rs 10,000
  24(b) — Home loan interest: Rs 2,00,000
══════════════════════════════════════════
```

## Phase 4: Capital Gains Summary

```bash
bash commands/tax-calculator.sh --capital-gains --portfolio ~/.wealth-mgmt/portfolios/latest.json
```

```
CAPITAL GAINS TAX SUMMARY — FY 2025-26
══════════════════════════════════════════
EQUITY (Listed):
  LTCG (> 12 months):     Rs 2,85,000
  - Exemption:            (Rs 1,25,000)
  Taxable LTCG:            Rs 1,60,000  × 12.5% = Rs 20,000
  STCG (< 12 months):     Rs 45,000    × 20%   = Rs 9,000

DEBT FUNDS:
  Gains (any period):      Rs 1,20,000  × slab rate 30% = Rs 36,000

PROPERTY:
  LTCG (> 24 months):     Rs 0
  (indexed cost basis available for pre-July 2024 purchases)

──────────────────────────────────────────
TOTAL CAPITAL GAINS TAX:   Rs 65,000
══════════════════════════════════════════
```

## Phase 5: Advance Tax Calendar

```
ADVANCE TAX DEADLINES — FY 2025-26
══════════════════════════════════════════
Due Date        Cumulative %    Amount Due
──────────────────────────────────────────
15 June 2025    15%             Rs XX,XXX
15 Sep 2025     45%             Rs XX,XXX
15 Dec 2025     75%             Rs XX,XXX
15 Mar 2026     100%            Rs XX,XXX
──────────────────────────────────────────
Interest on late payment: 1% per month (Section 234C)
══════════════════════════════════════════
```

## Phase 6: ITR Form Selection

| Situation | ITR Form |
|-----------|----------|
| Salary + interest + 1 house | ITR-1 (Sahaj) |
| Salary + capital gains + multiple houses | ITR-2 |
| Business/professional income (presumptive) | ITR-4 (Sugam) |
| Business income (regular) | ITR-3 |
| NRI with India income | ITR-2 |
| HUF | ITR-2 or ITR-3 |
| Company director or unlisted equity | ITR-2 |

## Phase 7: Tax-Saving Action Plan

```
TAX ACTION PLAN
══════════════════════════════════════════
IMMEDIATE (before March 31):
  □ Invest Rs 13,500 in ELSS to max 80C
  □ Pay health insurance premium (80D)
  □ Make NPS contribution Rs 50,000 (80CCD(1B))
  □ Pay advance tax if due

NEXT FY PLANNING:
  □ Start ELSS SIP Rs 12,500/month (auto 80C)
  □ Switch to direct MF plans (save on expense)
  □ Set up NPS auto-debit
  □ Harvest LTCG up to Rs 1.25L tax-free each year

ESTIMATED TAX SAVINGS:     Rs 78,000/year
══════════════════════════════════════════
```

Save to `~/.wealth-mgmt/reports/tax-filing-<date>.json`.

Offer:
- A) Run `/tax-optimize` for investment-level tax optimization
- B) Run `/insurance-audit` to maximize 80C/80D utilization
- C) Run `/mutual-funds` to pick ELSS funds
- D) Run `/nri-wealth` if you have foreign income
