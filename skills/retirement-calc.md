
# /retirement-calc — Retirement Calculator

Can you retire when you want? How much do you need? Let's find out.

## Phase 1: Retirement Profile

Ask the user (one at a time):

1. "How old are you?"
2. "At what age do you want to retire?"
3. "What are your current monthly expenses (household)?"
4. "What monthly income would you want in retirement (in today's rupees)?"
5. "What is your current retirement corpus? (EPF + PPF + NPS + MFs + FDs earmarked for retirement)"
6. "How much do you save/invest monthly toward retirement?"
7. "Do you expect any pension or other guaranteed income in retirement? (EPF pension, NPS annuity, rental income)"

## Phase 2: FIRE Number Calculation

### The Indian FIRE Formula

FIRE Number = Annual retirement expenses ÷ Safe Withdrawal Rate

**Safe Withdrawal Rate for India:**
- Traditional US 4% rule assumes 30yr retirement, US market returns
- India adjustment: use **3.5%** (higher inflation, emerging market volatility)
- Conservative: **3.0%** (for 40+ year retirement or early FIRE)
- Aggressive: **4.0%** (if large Social Security / pension / rental income)

```
FIRE NUMBER CALCULATION
══════════════════════════════════════════
Monthly expenses (today):          Rs 1,00,000
Annual expenses (today):           Rs 12,00,000

Inflation-adjusted at retirement:
  Current age:                     35
  Retirement age:                  50
  Years to retirement:             15
  Inflation rate:                  6%
  Future annual expenses:          Rs 28,74,000

FIRE NUMBER (at 3.5% SWR):
  Rs 28,74,000 ÷ 3.5% =           Rs 8.21 Cr

FIRE NUMBER (at 4.0% SWR):
  Rs 28,74,000 ÷ 4.0% =           Rs 7.19 Cr

TARGET CORPUS:                     Rs 8.2 Cr
  (using 3.5% for safety)
══════════════════════════════════════════
```

## Phase 3: Gap Analysis

```
RETIREMENT GAP ANALYSIS
══════════════════════════════════════════
TARGET CORPUS:                     Rs 8.21 Cr

CURRENT RETIREMENT ASSETS:
  EPF balance:                     Rs 15,00,000
  PPF balance:                     Rs 8,50,000
  NPS balance:                     Rs 5,20,000
  MFs (retirement tagged):         Rs 22,00,000
  ─────────────────────────────────────────
  Total current corpus:            Rs 50,70,000

PROJECTED GROWTH (15 years):
  EPF (8.15% growth + contributions): Rs 85,00,000
  PPF (7.1%, Rs 1.5L/yr):             Rs 38,00,000
  NPS (10% equity-heavy):             Rs 32,00,000
  MFs (12% CAGR, Rs 50K SIP):         Rs 3,20,00,000
  ─────────────────────────────────────────
  Projected corpus at 50:              Rs 4,75,00,000

TARGET:                                Rs 8,21,00,000
GAP:                                   Rs 3,46,00,000

TO CLOSE THE GAP:
  Increase monthly SIP by:             Rs 35,000/month
  OR delay retirement by:              3 years (retire at 53)
  OR reduce expenses by:               15% (Rs 85K/month)
══════════════════════════════════════════
```

## Phase 4: Monte Carlo Simulation

Run 1,000 retirement scenarios with variable returns:

```
MONTE CARLO RETIREMENT SIMULATION
══════════════════════════════════════════
Assumptions:
  Pre-retirement return: 11% ± 15% (equity-heavy)
  Post-retirement return: 8% ± 10% (balanced)
  Inflation: 6% ± 2%
  Retirement length: 35 years (age 50-85)
  Withdrawals: Rs 28.7L/year, inflation-adjusted

RESULTS (1,000 simulations):
──────────────────────────────────────────
  Success rate (money lasts to 85):  72%  ⚠

  90th percentile (optimistic):      Rs 15.2 Cr left at 85
  75th percentile:                   Rs 4.8 Cr left
  50th percentile (median):          Rs 0.6 Cr left
  25th percentile:                   RUNS OUT at age 78
  10th percentile (pessimistic):     RUNS OUT at age 72

VERDICT: 72% SUCCESS — NEEDS IMPROVEMENT
  Target: 90%+ success rate for comfortable retirement

FIXES TO REACH 90%:
  A) Add Rs 35K/month to SIP        → 91% success
  B) Retire at 53 instead of 50     → 89% success
  C) Build Rs 2Cr annuity bucket    → 93% success
  D) Reduce spending 10% in down years → 88% success
══════════════════════════════════════════
```

## Phase 5: NPS Optimization

```
NPS RETIREMENT PLANNING
══════════════════════════════════════════
CURRENT NPS:
  Tier I balance:      Rs 5,20,000
  Monthly contribution: Rs 10,000
  Asset allocation:     75% Equity / 25% Corp Bond

PROJECTION (15 years, 10% return):
  Corpus at 50:        Rs 48,00,000

NPS EXIT RULES (at 60 or superannuation):
  Minimum annuity:     40% of corpus → Rs 19,20,000
  Lump sum (tax-free): 60% of corpus → Rs 28,80,000

  Annuity Rs 19.2L at ~6% rate = Rs 96,000/year pension

TAX BENEFITS (Old Regime):
  80CCD(1): Within 80C limit (Rs 1.5L)
  80CCD(1B): Additional Rs 50,000 deduction
  80CCD(2): Employer contribution (14% of basic) — no limit!

OPTIMIZATION:
  ✅ Max out 80CCD(1B) — Rs 50K/year (saves Rs 15,600 at 30% bracket)
  ✅ Choose aggressive equity (75%) if retirement > 10 years away
  ✅ Auto-choice lifecycle fund shifts to debt near retirement
  ⚠ NPS annuity is taxable as income in retirement
  ⚠ Only 60% lump sum is tax-free
══════════════════════════════════════════
```

## Phase 6: Retirement Income Ladder

```
RETIREMENT INCOME PLAN (post-retirement)
══════════════════════════════════════════
BUCKET 1 — Immediate (Years 1-3):
  Liquid MFs + FDs:        Rs 90L
  Purpose: Living expenses, no market risk
  Yield: 6-7%

BUCKET 2 — Medium (Years 4-7):
  Debt MFs + SGBs + NCDs:  Rs 1.2 Cr
  Purpose: Replenish Bucket 1, moderate returns
  Yield: 7-8%

BUCKET 3 — Long-term (Years 8+):
  Equity MFs + PMS:        Rs 2.5 Cr
  Purpose: Beat inflation, grow real wealth
  Expected: 10-12% CAGR

GUARANTEED INCOME:
  NPS annuity:             Rs 96,000/year
  EPF pension (EPS):       Rs 7,500/month (max)
  Rental income:           Rs 30,000/month
  ─────────────────────────────────────────
  Guaranteed monthly:       Rs 45,500

GAP TO FILL FROM BUCKETS:
  Required: Rs 1,00,000/month
  Guaranteed: Rs 45,500/month
  From portfolio: Rs 54,500/month (SWP from Bucket 1)
══════════════════════════════════════════
```

## Phase 7: SWP (Systematic Withdrawal Plan)

```
SWP SETUP FOR RETIREMENT INCOME
══════════════════════════════════════════
Fund:           HDFC Balanced Advantage (or similar)
Corpus:         Rs 90,00,000 (Bucket 1+2)
Monthly SWP:    Rs 55,000
Withdrawal rate: 7.3% annually

TAX ON SWP:
  Each SWP = partial redemption
  LTCG (>1yr): 12.5% above Rs 1.25L/year
  STCG (<1yr): 20%

  Estimated annual LTCG: ~Rs 2L taxable
  Tax: Rs 9,375/year (very efficient!)

SWP vs FD INTEREST:
  FD interest: taxed at 30% = Rs 1.65L tax on Rs 5.5L
  SWP:         taxed at 12.5% LTCG = Rs 9,375
  TAX SAVINGS: Rs 1.55L/year with SWP!
══════════════════════════════════════════
```

Save to `~/.wealth-mgmt/plans/retirement-<date>.json`.

Offer:
- A) Run `/goal-planner` to integrate retirement with other goals
- B) Run `/tax-filing` to optimize NPS tax benefits
- C) Run `/insurance-audit` to ensure adequate life/health cover
- D) Run `/financial-plan` for comprehensive planning beyond retirement
- E) Set annual review reminder
