---
name: financial-plan
description: Financial planning — retirement projections, estate planning, education funding, Monte Carlo simulations. Use for retirement planning, financial goals, or estate questions.
context: fork
agent: goal-planner
---

# Financial Planning

## Step 1: Scope

Ask the user:
- A) Retirement Projection — can I retire when I want?
- B) Goal Tracking — am I on track for my goals?
- C) Education Funding — 529/college planning
- D) Estate Planning — will, trust, succession
- E) Comprehensive Plan — all of the above

## Retirement Projection

Gather: current age, target retirement age, portfolio value, annual contribution, desired retirement income (today's Rs), expected pension/EPF, other income sources.

**Monte Carlo simulation** (1,000 scenarios):
- Pre-retirement return: based on allocation (aggressive 9%, growth 8%, moderate 7%, conservative 5%)
- Post-retirement return: 2% lower
- Inflation: 6% (India)
- 4% withdrawal rate adjusted for Indian inflation

Report success rate (% of simulations lasting 30 years). Sensitivity: retire 2yr later, save Rs 10K more/mo, reduce spending 10%.

## Goal Tracking

For each goal: name, target amount, timeline, current savings, monthly SIP.
Use `scripts/sip-calculator.sh` for calculations.
Show ON TRACK / NEEDS ATTENTION / AT RISK.

## Estate Planning

Checklist: will, nominations audit, trust, POA, healthcare directive.
Reminder: India has no estate tax, but transfers trigger capital gains.
Nominee ≠ Owner — will overrides nomination.

Save to `~/.wealthstack/plans/financial-plan-{date}.json`.
