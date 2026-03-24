---
name: insurance-audit
version: 1.0.0
description: |
  Insurance needs analysis and policy audit. Term life (HLV calculation), health
  insurance structuring (base + super top-up), ULIP evaluation vs MF+term combo,
  critical illness, personal accident, and policy consolidation.
  Use when asked to "review insurance", "am I underinsured", "ULIP vs MF",
  "health insurance", or "term life calculator".
allowed-tools:
  - Bash
  - Read
  - Write
  - Agent
  - WebSearch
  - AskUserQuestion
---

# /insurance-audit — Insurance Needs Analysis & Policy Review

Audit your insurance coverage. Find gaps. Eliminate waste.

## Phase 1: Current Coverage Inventory

Use AskUserQuestion:

"Let me audit your insurance. What policies do you currently have? (pick all)"
- A) Term life insurance
- B) Health insurance (individual or floater)
- C) Endowment / money-back policy (LIC or private)
- D) ULIP (Unit Linked Insurance Plan)
- E) Critical illness cover
- F) Personal accident cover
- G) Corporate/employer insurance
- H) None / Not sure

For each policy selected, ask: Insurer, sum assured, annual premium, policy start date.

## Phase 2: Life Insurance Needs

### Human Life Value (HLV) Calculation

Ask via AskUserQuestion:
1. Annual income: "What is your annual take-home income?"
2. Personal expenses: "What % is your personal spending (not family)?" (typically 20-30%)
3. Age: "How old are you?"
4. Retirement age: "When do you plan to retire?"
5. Outstanding loans: "Total outstanding loans? (home, car, personal, education)"
6. Dependents: "How many financial dependents? (spouse, children, parents)"

### Calculate Required Cover

```
TERM LIFE INSURANCE NEEDS
══════════════════════════════════════════
METHOD 1: Human Life Value
  Annual income:                Rs XX L
  Less personal expenses (25%): Rs XX L
  Income for family:            Rs XX L
  × Remaining working years:    XX years
  = Discounted value (8%):      Rs X.X Cr

  + Outstanding loans:          Rs XX L
  + Children education:         Rs XX L
  + Children marriage:          Rs XX L
  - Existing assets:           (Rs XX L)
  ─────────────────────────────────────
  REQUIRED COVER:               Rs X.X Cr

METHOD 2: Income Replacement (simpler)
  Annual income × 15:           Rs X.X Cr

CURRENT COVER:                  Rs XX L
GAP:                            Rs X.X Cr  ⚠ UNDERINSURED

RECOMMENDATION:
  Buy term plan for Rs X Cr
  Estimated premium: Rs XX,XXX/year (age XX, non-smoker)
══════════════════════════════════════════
```

### Term Plan Comparison

| Insurer | Plan | Cover Rs 1 Cr | Cover Rs 2 Cr | Claim Ratio |
|---------|------|--------------|--------------|-------------|
| HDFC Life | Click 2 Protect | Rs 8,500 | Rs 14,200 | 99.1% |
| ICICI Pru | iProtect Smart | Rs 8,800 | Rs 14,800 | 98.6% |
| Max Life | Smart Secure Plus | Rs 9,200 | Rs 15,500 | 99.3% |
| Tata AIA | Sampoorna Raksha | Rs 8,200 | Rs 13,900 | 98.9% |
| LIC | Tech Term | Rs 10,500 | Rs 17,800 | 98.5% |

*Rates approximate for age 30, male, non-smoker, 30yr term. Use WebSearch for current rates.*

## Phase 3: Health Insurance Audit

### Recommended Cover

| Situation | Minimum | Ideal | Structure |
|-----------|---------|-------|-----------|
| Young single | Rs 5L | Rs 15L | Base Rs 5L + Super top-up Rs 10L |
| Couple | Rs 10L | Rs 25L | Floater Rs 10L + Super top-up Rs 15L |
| Family (2 kids) | Rs 15L | Rs 50L | Floater Rs 15L + Super top-up Rs 35L |
| HNI family | Rs 50L | Rs 1Cr+ | Base Rs 25L + Super top-up Rs 75L |
| Parents (60+) | Rs 10L | Rs 25L | Separate senior plan + top-up |

### Cost Optimization: Base + Super Top-Up

```
HEALTH INSURANCE OPTIMIZATION
══════════════════════════════════════════
OPTION 1: Single Rs 50L plan
  Premium: ~Rs 35,000/year

OPTION 2: Rs 10L base + Rs 40L super top-up
  Base:     ~Rs 15,000/year
  Top-up:   ~Rs 5,000/year
  TOTAL:    ~Rs 20,000/year
  SAVINGS:   Rs 15,000/year (43% cheaper!)

Both give Rs 50L coverage. Super top-up kicks in
above the base deductible. Same hospitals, same claims.
══════════════════════════════════════════
```

### Key Features Checklist

| Feature | Must Have | Nice to Have |
|---------|----------|-------------|
| No room rent cap | Yes | — |
| Restoration benefit | Yes | — |
| No co-payment | Yes | — |
| Day care coverage | Yes | — |
| Pre/post hospitalization | Yes (30/60 days min) | 60/180 days |
| No-claim bonus | — | Yes (cumulative) |
| AYUSH coverage | — | Yes |
| Maternity | — | If planning |
| Mental health | — | Yes (mandated by IRDAI) |

## Phase 4: Endowment / ULIP Audit

If the user holds endowment policies or ULIPs:

```
ENDOWMENT / ULIP AUDIT
══════════════════════════════════════════
Policy: LIC Jeevan Anand (example)
  Sum Assured:    Rs 10L
  Annual Premium: Rs 45,000
  Years Paid:     8 of 20
  Surrender Value: Rs 2.8L
  Maturity Value:  ~Rs 12L (estimated)
  Effective Return: ~5.2% CAGR

ALTERNATIVE: Term + MF Combo
  Term Rs 1 Cr:   Rs 8,500/year
  Remaining SIP:  Rs 36,500/year in Nifty 50 index
  After 12 years: ~Rs 10.5L (at 12% CAGR)
  + Rs 1 Cr life cover (vs Rs 10L)

VERDICT: Term + MF gives 10x more life cover
and comparable or better maturity value.

RECOMMENDATION:
  ⚠ If policy > 3 years old: consider surrendering
  ⚠ If policy < 3 years: may lose most premium (lock-in)
  ⚠ Tax: surrender proceeds taxable if annual premium > Rs 5L
══════════════════════════════════════════
```

## Phase 5: Full Insurance Scorecard

```
INSURANCE AUDIT SCORECARD
══════════════════════════════════════════
Category         Need      Current   Gap      Score
─────────────────────────────────────────────────
Term Life        Rs 2 Cr   Rs 50L    Rs 1.5Cr  2/10 🔴
Health           Rs 50L    Rs 10L    Rs 40L    3/10 🔴
Critical Illness Rs 25L    Rs 0      Rs 25L    0/10 🔴
Personal Accident Rs 50L   Rs 0      Rs 50L    0/10 🔴
─────────────────────────────────────────────────
OVERALL INSURANCE HEALTH:              2/10 🔴

PRIORITY ACTIONS:
  1. Buy term plan Rs 2 Cr (URGENT)
  2. Upgrade health to Rs 50L (base + super top-up)
  3. Add critical illness Rs 25L
  4. Surrender endowment → redirect to MF SIP

ESTIMATED ANNUAL COST:
  Term Rs 2 Cr:        Rs 14,500
  Health Rs 50L:       Rs 20,000
  Critical Illness:    Rs 8,000
  Personal Accident:   Rs 3,000
  ─────────────────────────────
  TOTAL:               Rs 45,500/year
  Section 80C (term):  Rs 14,500 deduction
  Section 80D (health): Rs 20,000 deduction
══════════════════════════════════════════
```

Save to `~/.wealth-mgmt/reports/insurance-audit-<date>.json`.

Offer:
- A) Get specific term plan quotes via WebSearch
- B) Run `/financial-plan` to integrate insurance into overall plan
- C) Run `/tax-filing` to check 80C/80D utilization
- D) Save and review annually
