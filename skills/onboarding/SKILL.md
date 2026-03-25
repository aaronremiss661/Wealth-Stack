---
name: onboarding
description: New client onboarding workflow — chains risk profiling, goal planning, portfolio construction, compliance check, and welcome report into a complete onboarding experience.
context: fork
agent: investment-counsellor
allowed-tools: Bash, Read, Write, Grep, Glob, WebSearch
---

# Client Onboarding

Complete onboarding workflow for a new wealth management client.

## Workflow Chain

### Phase 1: Client Profile Collection

Gather essential information:

**Personal Details:**
- Name, age, occupation
- Residential status (Resident/NRI/RNOR)
- Family situation (single, married, dependents)
- Annual income range
- Existing investments (approximate)
- Liabilities (home loan, personal loan, etc.)

**Financial Snapshot:**
- Monthly income after tax
- Monthly expenses
- Monthly savings capacity (income - expenses)
- Emergency fund status (months of expenses saved)
- Insurance coverage (term life, health)

### Phase 2: Risk Profiling

Conduct a structured risk assessment through questions:

1. **Investment horizon**: <3 years / 3-5 years / 5-10 years / 10+ years
2. **Reaction to 20% portfolio drop**: Sell everything / Sell some / Hold / Buy more
3. **Income stability**: Stable salary / Variable / Business income / Retired
4. **Financial dependents**: 0 / 1-2 / 3+ / Supporting parents
5. **Investment experience**: Beginner / Intermediate / Advanced
6. **Primary goal**: Wealth preservation / Steady growth / Aggressive growth
7. **Risk capacity** (based on income vs expenses ratio)

Score and classify:
- **Conservative** (score 7-12): Capital preservation priority
- **Moderate** (score 13-18): Balanced growth
- **Aggressive** (score 19-24): Maximum growth
- **Very Aggressive** (score 25-28): High-conviction concentrated

Save profile to `~/.wealthstack/clients/{client-id}/profile.json`.

### Phase 3: Goal Planning

For each life goal, capture:
- Goal name (retirement, child education, house purchase, etc.)
- Target amount (in today's rupees)
- Target date
- Priority (must-have / nice-to-have)

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/sip-calculator.sh {target_amount} {years} {expected_return}
bash ${CLAUDE_PLUGIN_ROOT}/scripts/goal-gap-analyzer.sh
```

Map goals to investment horizons and risk levels.

### Phase 4: Portfolio Construction

Based on risk profile and goals, recommend:

**Asset Allocation:**
| Risk Profile | Equity | Debt | Gold | Cash |
|-------------|--------|------|------|------|
| Conservative | 30% | 55% | 10% | 5% |
| Moderate | 60% | 30% | 7% | 3% |
| Aggressive | 80% | 12% | 5% | 3% |
| Very Aggressive | 90% | 5% | 3% | 2% |

**Product Selection:**
- Large Cap: Index fund (Nifty 50/Sensex) — low cost core
- Flexi Cap: Actively managed for alpha
- Mid/Small Cap: For aggressive allocation
- Debt: Short duration / corporate bond fund
- Gold: SGB (8-year) or Gold ETF
- International: Nasdaq 100 / S&P 500 via LRS or fund of funds

Save target allocation to `~/.wealthstack/target-allocation.json`.

### Phase 5: Compliance Check

Verify suitability:
- Does allocation match risk profile? (SEBI RIA requirement)
- Are product recommendations suitable for investment horizon?
- NRI restrictions applicable? (check FEMA limits)
- PMS minimum met if recommending PMS? (Rs 50L)
- Concentration limits respected?

Read regulatory knowledge:
```
Read ${CLAUDE_PLUGIN_ROOT}/knowledge/regulatory/sebi-rules.md
Read ${CLAUDE_PLUGIN_ROOT}/knowledge/regulatory/fema-rules.md (if NRI)
```

### Phase 6: Implementation Plan

Create actionable steps:
1. **Immediate**: Open necessary accounts (demat, MF platform, NPS)
2. **Week 1**: Deploy lumpsum (if any) via STP or direct
3. **Month 1**: Set up SIPs for all goal-linked investments
4. **Quarter 1**: First review checkpoint
5. **Annual**: Full review cycle (use `/annual-review`)

### Phase 7: Welcome Report

Generate a comprehensive onboarding report:

```
WEALTH MANAGEMENT — ONBOARDING REPORT
══════════════════════════════════════════
Client: {name}
Date: {date}
Advisor: WealthStack

RISK PROFILE: {Conservative/Moderate/Aggressive}

GOALS:
  1. {Goal 1}: Rs {target} by {date} — SIP Rs {amount}/mo
  2. {Goal 2}: Rs {target} by {date} — SIP Rs {amount}/mo

RECOMMENDED ALLOCATION:
  Equity: {X}% | Debt: {Y}% | Gold: {Z}%

PRODUCT RECOMMENDATIONS:
  [Table of specific fund/stock recommendations]

IMPLEMENTATION TIMELINE:
  [Step-by-step action items with dates]

REVIEW SCHEDULE:
  - Quarterly: Portfolio rebalancing check
  - Annual: Comprehensive review
  - Ad-hoc: On major market events
══════════════════════════════════════════
```

Save to `~/.wealthstack/reports/onboarding-{client-id}-{date}.md`.

### Phase 8: Next Steps

Offer immediate actions:
- `/portfolio` — Import existing investments
- `/insurance-audit` — Check insurance adequacy
- `/tax-filing` — Review tax optimization
- `/nri-wealth` — NRI-specific setup (if applicable)
