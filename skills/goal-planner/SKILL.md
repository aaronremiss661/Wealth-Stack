---
name: goal-planner
description: Goal-based financial planning with SIP calculations and glide path allocation. Use when mapping investments to life goals like retirement, education, or house purchase.
context: fork
agent: goal-planner
---

# Goal-Based Planner

## Step 1: Goal Discovery

Ask the user to list their financial goals. For each goal, capture:
- Goal name (e.g., "Daughter's college education")
- Target amount (today's Rs)
- Timeline (years from now)
- Priority: Essential / Important / Aspirational
- Current savings toward this goal
- Current monthly SIP toward this goal

## Step 2: Future Value

Inflate each goal to future value:
- General: 6% inflation
- Education (India): 10%
- Education (abroad): 11% (8% + 3% INR depreciation)
- Healthcare: 8%
- Real estate: 5-7%

## Step 3: Asset Allocation per Goal

Use glide path based on time to goal:
- 10+ years: 75-85% equity
- 5-7 years: 40-55% equity
- 1-3 years: 5-15% equity
- <1 year: 0% equity

## Step 4: SIP Calculation

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/sip-calculator.sh FUTURE_VALUE YEARS RETURN_RATE
```

For each goal: required SIP, current SIP, gap.

## Step 5: Goal Dashboard

Show all goals with status: ON TRACK / NEEDS ATTENTION / AT RISK.
Total required SIP vs current SIP with gap amount.

## Step 6: Product Recommendations

Direct MF plans only. Recommend: Nifty 50 index (<0.2% ER), flexi cap, midcap 150 index, short duration debt, SGBs for gold allocation.
