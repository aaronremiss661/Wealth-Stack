---
name: retirement-calc
description: Retirement calculator — FIRE number, SWP strategy, NPS optimization, EPF projections. Use for retirement planning, FIRE calculation, or NPS questions.
context: fork
agent: goal-planner
---

# Retirement Calculator

## Step 1: Inputs

Ask the user:
1. Current age
2. Target retirement age
3. Current monthly expenses
4. Current investment portfolio value
5. Monthly savings/SIP amount
6. EPF balance and monthly contribution
7. NPS account? (Y/N, balance)
8. Expected pension/other retirement income

## Step 2: FIRE Number

**FIRE Number** = Annual expenses at retirement × 25 (4% rule, adjusted for India)

For India, use 3.5% withdrawal rate (higher inflation):
FIRE Number = Annual expenses × 28.5

Inflate current expenses to retirement: expenses × (1.06)^years_to_retire

## Step 3: Projection

Monthly projection with:
- EPF: 8.15% (current EPFO rate), employer + employee contribution
- NPS: based on asset allocation (E/C/G), historical returns
- MF/equity portfolio: based on allocation
- PPF: 7.1% (current rate), Rs 1.5L/yr max

## Step 4: SWP Strategy (Post-Retirement)

- **Bucket 1** (0-3 years): Liquid/ultra-short debt (Rs X in cash)
- **Bucket 2** (3-7 years): Short-term debt, balanced funds
- **Bucket 3** (7+ years): Equity (growth engine)

Systematic Withdrawal Plan (SWP) from debt bucket, refill from equity bucket annually.

## Step 5: NPS Optimization

- Tier I: tax deduction up to Rs 50K extra (80CCD(1B)) + employer contribution (80CCD(2))
- Asset allocation: max 75% equity (Active Choice) for young investors
- At 60: 40% must buy annuity, 60% lump sum (tax-free from FY 2023-24)
- Auto choice vs Active choice comparison

## Step 6: Report

Retirement readiness: ON TRACK / NEEDS ATTENTION / AT RISK
Gap analysis with specific remediation (save more / retire later / reduce expenses).
