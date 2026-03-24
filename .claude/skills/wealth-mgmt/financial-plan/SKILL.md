---
name: financial-plan
version: 1.0.0
description: |
  Financial planning — retirement projections, estate planning, education funding,
  and goal tracking. Monte Carlo simulations, withdrawal strategies, Social Security
  optimization, and milestone progress tracking.
  Use when asked to "financial plan", "retirement projection", "estate plan",
  "education funding", or "am I on track".
allowed-tools:
  - Bash
  - Read
  - Write
  - Agent
  - WebSearch
  - AskUserQuestion
---

# /financial-plan — Financial Planning

Comprehensive financial planning: retirement projections, goal tracking, estate planning, and withdrawal strategies.

## Phase 1: Planning Scope

Use AskUserQuestion:

"What area of financial planning would you like to focus on?"
- A) Retirement Projection — can I retire when I want to?
- B) Goal Tracking — am I on track for my financial goals?
- C) Education Funding — 529/college planning
- D) Estate Planning — wealth transfer and beneficiary review
- E) Comprehensive Plan — all of the above

## Retirement Projection (Option A)

### Gather Inputs

Ask via AskUserQuestion (one at a time):

1. **Current age:** "How old are you?"
2. **Target retirement age:** "When do you want to retire?"
3. **Current portfolio value:** "What is your total investment portfolio value?" (or load from saved)
4. **Annual contribution:** "How much do you contribute per year to investments?"
5. **Desired retirement income:** "What annual income do you need in retirement (today's dollars)?"
6. **Social Security estimate:** "What is your estimated Social Security benefit at full retirement age? (check ssa.gov if unsure)"
7. **Other income:** "Any other retirement income sources? (pension, rental, annuity)"

### Monte Carlo Simulation

Run a simplified Monte Carlo projection:

Assumptions:
- **Pre-retirement return:** Based on current allocation (aggressive: 9%, growth: 8%, moderate: 7%, conservative: 5%)
- **Post-retirement return:** 2% lower than pre-retirement (more conservative allocation)
- **Inflation:** 3% annual
- **Volatility:** Based on allocation (aggressive: 18%, growth: 15%, moderate: 12%, conservative: 8%)

Simulate 1,000 scenarios with random annual returns drawn from a normal distribution.

Report:
```
RETIREMENT PROJECTION
══════════════════════════════════════════
Current Age:           XX
Retirement Age:        XX
Years to Retirement:   XX
Current Portfolio:     $XXX,XXX
Annual Contribution:   $XX,XXX

PROJECTED OUTCOMES (at retirement):
  90th percentile:     $X,XXX,XXX  (optimistic)
  50th percentile:     $X,XXX,XXX  (median)
  10th percentile:     $XXX,XXX    (pessimistic)

INCOME SUSTAINABILITY:
  Required annual:     $XXX,XXX
  Social Security:     $XX,XXX
  Portfolio needed:    $XXX,XXX (at 4% withdrawal rate)
  Success rate:        XX%  (% of simulations lasting 30 years)

VERDICT:
  [ON TRACK / NEEDS ATTENTION / AT RISK]
  [1-2 sentence explanation]
══════════════════════════════════════════
```

### Sensitivity Analysis

Show how changes affect the outcome:
- **Retire 2 years later:** success rate changes to X%
- **Save $500/mo more:** success rate changes to X%
- **Reduce spending by 10%:** success rate changes to X%
- **More aggressive allocation:** success rate changes to X%

## Goal Tracking (Option B)

Ask for financial goals:
- Goal name, target amount, target date, current savings toward it, monthly contribution

For each goal, calculate:
- **On track?** Will current contributions meet the goal?
- **Gap:** How much more is needed per month?
- **Probability:** Likelihood of reaching the goal (with market returns)

## Education Funding (Option C)

Inputs: child's age, target school type (public/private), years until enrollment.

Use current college cost data:
- Public in-state: ~$25K/year (growing ~5%/year)
- Public out-of-state: ~$45K/year
- Private: ~$60K/year

Project future costs and required savings rate.

## Estate Planning (Option D)

Review checklist:
- [ ] Will or trust in place
- [ ] Beneficiary designations current on all accounts
- [ ] Power of attorney designated
- [ ] Healthcare directive in place
- [ ] Estate tax exposure assessment (federal exemption: $13.61M per person, 2024)
- [ ] Gifting strategy ($18K annual exclusion per recipient)
- [ ] Life insurance needs assessment

## Phase 2: Save Plan

Save the financial plan to `~/.wealth-mgmt/plans/financial-plan-<date>.json`.

Offer:
- A) Generate client-facing report with `/client-report`
- B) Run `/portfolio` to review current investments
- C) Run `/rebalance` to align allocation with planning assumptions
- D) Save and revisit — set a reminder for annual review
