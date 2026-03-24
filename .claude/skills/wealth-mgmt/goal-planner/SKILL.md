---
name: goal-planner
version: 1.0.0
description: |
  Goal-based financial planning modeled after Dezerv, Scripbox, and Kuvera Pro.
  Maps every rupee to a life goal with timeline-based glide path allocation.
  SIP calculation, gap analysis, direct MF recommendations, and goal dashboard.
  Use when asked to "plan goals", "SIP calculator", "goal-based investing",
  "am I on track", or "Dezerv-style planning".
allowed-tools:
  - Bash
  - Read
  - Write
  - Agent
  - WebSearch
  - AskUserQuestion
---

# /goal-planner — Goal-Based Financial Planning

Every rupee mapped to a goal. Systematic, evidence-based, emotion-free investing.

## Philosophy (Dezerv Model)

- **Goal-mapped:** Every investment is linked to a specific life goal with a deadline
- **Glide path:** Asset allocation shifts from equity→debt as the goal approaches
- **Systematic:** SIPs on autopilot, rebalancing rules-based, not market-timing
- **Cost-efficient:** Direct MF plans only (save 0.5-1% commission annually)
- **Behavior > stock picking:** Automate everything to remove emotional decisions

## Phase 1: Goal Discovery

Use AskUserQuestion:

"Let's map out your financial goals. Which of these apply to you? (pick all that apply)"
- A) Retirement — building a corpus for financial independence
- B) Child's education — school, college, or abroad
- C) House purchase — down payment or full purchase
- D) Emergency fund — 6-12 months of expenses
- E) Car / vehicle purchase
- F) Wedding / family event
- G) Vacation / travel
- H) Parent care / medical
- I) Wealth building — general long-term growth
- J) Other — I'll specify

For each selected goal, ask:

### Goal Detail Template

"Tell me about your [GOAL_NAME]:"

1. **Target amount in today's rupees:** "How much would this cost today?"
2. **Timeline:** "When do you need this money?"
3. **Priority:** Essential (must happen) / Important (should happen) / Aspirational (nice to have)
4. **Current savings toward this goal:** "How much have you already saved for this?"
5. **Current SIP toward this goal:** "Are you doing any SIP currently for this? How much per month?"

## Phase 2: Future Value & Inflation Adjustment

### India-Specific Inflation Rates

| Category | Inflation Rate | Rationale |
|----------|---------------|-----------|
| General / lifestyle | 6% | CPI India long-term average |
| Education (India) | 10-12% | Fee hikes consistently outpace CPI |
| Education (abroad) | 8% + 3% currency depreciation = 11% | USD appreciation against INR |
| Healthcare / medical | 8-10% | Medical inflation higher than CPI |
| Real estate (Tier 1 cities) | 5-7% | Varies hugely by micro-market |
| Car / vehicle | 5% | Moderate price inflation |
| Vacation (international) | 8% | Includes currency depreciation |
| Wedding | 7-8% | Social inflation |

### Calculation

For each goal:
```
Future Value = Today's Cost × (1 + inflation)^years
Required Corpus = Future Value - Existing Savings × (1 + return)^years
Monthly SIP = Required Corpus × r / ((1+r)^n - 1)
  where r = monthly expected return, n = months to goal
```

## Phase 3: Goal-Based Asset Allocation (Glide Path)

Invoke the **Goal-Based Planner** subagent:

> You are a Goal-Based Planner for WealthStack. Design a glide path allocation for each goal.

### Glide Path Table

| Time to Goal | Equity | Debt | Gold |
|-------------|--------|------|------|
| **10+ years** | 80% | 15% | 5% |
| **7-10 years** | 65% | 30% | 5% |
| **5-7 years** | 50% | 45% | 5% |
| **3-5 years** | 30% | 65% | 5% |
| **1-3 years** | 10% | 85% | 5% |
| **< 1 year** | 0% | 100% | 0% |

As each goal gets closer, equity automatically reduces. This is like a target-date fund but per goal.

## Phase 4: Product Recommendations (Direct MF Plans)

### Equity Allocation

| Sub-category | Allocation | Recommended Fund Type | Example (Search for latest ratings) |
|-------------|-----------|---------------------|-------------------------------------|
| Large cap | 40% of equity | Nifty 50 Index Fund | UTI Nifty 50, HDFC Nifty 50 (expense < 0.2%) |
| Flexi cap | 30% of equity | Top-rated flexi cap | Parag Parikh Flexi Cap, PPFAS |
| Mid cap | 20% of equity | Nifty Midcap 150 or active | Motilal Oswal Midcap, Kotak Emerging |
| International | 10% of equity | US/Global index FoF | Motilal Oswal Nasdaq 100, Navi US Total Market |

### Debt Allocation

| Sub-category | Allocation | Recommended Fund Type | When to Use |
|-------------|-----------|---------------------|-------------|
| Short duration | 40% of debt | Short-term debt fund | Goals 1-3 years away |
| Corporate bond | 30% of debt | Banking & PSU or corp bond | Goals 3-5 years away |
| Gilt | 20% of debt | Gilt fund (10yr) | Goals 5+ years (rate lock) |
| Liquid | 10% of debt | Liquid / overnight fund | Emergency fund, <1 year goals |

### Gold Allocation

| Instrument | Preference | Why |
|-----------|-----------|-----|
| **Sovereign Gold Bond (SGB)** | 1st choice | Tax-free on maturity, 2.5% annual coupon |
| Gold ETF | 2nd choice | Liquid, no lock-in, but LTCG applies |
| Gold MF | 3rd choice | No demat needed, SIP available |

### Selection Criteria (Dezerv Style)

- **Direct plans only** — save 0.5-1% annually vs regular plans
- **Expense ratio:** lower is better (index funds < 0.3%, active < 1.5%)
- **AUM > Rs 1,000 crore** for equity funds (for stability)
- **Track record:** 5+ years for active funds, 3+ for index
- **Consistency:** Rolling return analysis, not just point-to-point
- **Fund manager tenure:** > 3 years on same fund

## Phase 5: SIP Plan & Gap Analysis

Calculate for each goal:

```
GOAL-BY-GOAL SIP PLAN
══════════════════════════════════════════════════════════════
GOAL                    TODAY     FUTURE    SAVED    SIP NEEDED
──────────────────────────────────────────────────────────────
Retirement (age 60)     Rs 5 Cr   Rs 14.3 Cr  Rs 40L   Rs 45,000/mo
 └ 25 years away, 80% equity, 15% debt, 5% gold

Daughter Education      Rs 40L    Rs 1.55 Cr  Rs 5L    Rs 18,000/mo
 └ 15 years, abroad, 11% inflation
 └ 80% equity → glide to 30% equity by year 12

Son Education           Rs 25L    Rs 65L      Rs 3L    Rs 8,500/mo
 └ 10 years, India engineering, 10% inflation
 └ 65% equity → glide to 10% by year 8

House Down Payment      Rs 30L    Rs 38L      Rs 12L   Rs 22,000/mo
 └ 3 years, 7% inflation
 └ 30% equity, 65% debt, 5% gold

Emergency Fund          Rs 6L     Rs 6L       Rs 2L    Rs 15,000/mo
 └ Immediate (build in 3 months)
 └ 100% liquid/overnight fund

Europe Vacation         Rs 5L     Rs 5.6L     Rs 1L    Rs 8,500/mo
 └ 18 months, 8% inflation
 └ 10% equity, 85% debt, 5% gold

──────────────────────────────────────────────────────────────
TOTAL SIP NEEDED:                              Rs 1,17,000/mo
CURRENT SIP:                                   Rs 85,000/mo
GAP:                                           Rs 32,000/mo
══════════════════════════════════════════════════════════════

GAP RESOLUTION OPTIONS:
  A) Increase SIP by Rs 32,000/mo → all goals on track
  B) Extend house timeline by 1 year → reduces gap to Rs 18,000/mo
  C) Choose India college over abroad → saves Rs 10,000/mo
  D) Reduce vacation budget by 20% → saves Rs 1,700/mo
══════════════════════════════════════════════════════════════
```

## Phase 6: Implementation

### SIP Setup Checklist

For each goal, provide specific instructions:

```
IMPLEMENTATION CHECKLIST
══════════════════════════════════════════
RETIREMENT (Rs 45,000/mo):
  □ UTI Nifty 50 Index (Direct)     Rs 18,000/mo
  □ Parag Parikh Flexi Cap (Direct)  Rs 13,500/mo
  □ Motilal Oswal Midcap (Direct)    Rs 9,000/mo
  □ Motilal Oswal Nasdaq FoF          Rs 4,500/mo

DAUGHTER EDUCATION (Rs 18,000/mo):
  □ HDFC Nifty 50 Index (Direct)     Rs 7,200/mo
  □ Kotak Emerging Equity (Direct)    Rs 5,400/mo
  □ HDFC Short Term Debt (Direct)     Rs 2,700/mo
  □ SGB (apply when available)        Rs 2,700/mo equiv

[... similar for each goal ...]

PLATFORM: Use Kuvera / Groww / MFUtility for direct plans
SIP DATE: 5th of each month (avoid month-end salary crunch)
══════════════════════════════════════════
```

## Phase 7: Rebalancing Rules

- **Time-based:** Review every 6 months
- **Threshold-based:** Rebalance if any asset class drifts > 5% from target
- **Glide path:** Annually shift equity→debt as goal approaches (automatic reduction)
- **Tax-aware:** Prefer redirecting fresh SIPs rather than selling (avoids STCG)
- **Step-up SIP:** Increase SIP by 10% every year (matches salary growth)

## Phase 8: Goal Dashboard & Save

Save the complete goal plan to `~/.wealth-mgmt/plans/goals-<date>.json`.

Offer:
- A) Run `/portfolio` to link existing investments to goals
- B) Run `/tax-optimize` to check Section 80C/80D utilization
- C) Run `/risk-assess` to validate allocation matches risk profile
- D) Generate client report with `/client-report`
- E) Set 6-month review reminder

## Annual Review Triggers

Re-run `/goal-planner` when:
- Salary/income changes significantly (adjust SIP step-up)
- New goal added (marriage, second child, etc.)
- Goal timeline changes (delayed/advanced)
- Market crash > 20% (reassess, don't panic — stay the course)
- Any goal achieved (celebrate, then reallocate the SIP)
