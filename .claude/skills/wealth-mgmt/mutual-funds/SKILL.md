---
name: mutual-funds
version: 1.0.0
description: |
  Mutual fund screening, comparison, SIP tracking, and portfolio overlap analysis.
  Covers equity, debt, hybrid, index funds, ETFs, and FoFs. Direct vs regular plan
  comparison. AMFI NAV data. CRISIL/Morningstar ratings.
  Use when asked to "compare mutual funds", "which fund", "SIP tracker",
  "fund overlap", "best mutual fund", or "MF recommendation".
allowed-tools:
  - Bash
  - Read
  - Write
  - Agent
  - WebSearch
  - AskUserQuestion
---

# /mutual-funds — Mutual Fund Screening & Analysis

Screen, compare, and track mutual funds for Indian investors.

## Phase 1: What Do You Need?

Use AskUserQuestion:

"What would you like to do with mutual funds?"
- A) Screen funds — find the best fund for a category
- B) Compare funds — head-to-head comparison of 2-3 funds
- C) Portfolio overlap — check if my funds hold the same stocks
- D) SIP tracker — track my existing SIPs and returns
- E) Switch analysis — should I switch from regular to direct plan?
- F) Tax harvesting — which fund units to redeem for tax efficiency?

## Phase 2: Fund Screening (Option A)

### Category Selection

Use AskUserQuestion:

"Which category are you looking at?"
- A) Large Cap (Nifty 50 universe)
- B) Flexi Cap / Multi Cap
- C) Mid Cap
- D) Small Cap
- E) Index Fund / ETF
- F) Debt — Short Duration / Corporate Bond / Gilt
- G) Hybrid — Balanced Advantage / Aggressive Hybrid
- H) International — US / Global
- I) Sectoral / Thematic
- J) ELSS (Tax Saving)

### Screening Criteria

For each category, rank funds by:

| Metric | Weight | What to Check |
|--------|--------|---------------|
| 3yr & 5yr CAGR | 25% | Returns relative to category average and benchmark |
| Consistency (rolling returns) | 20% | 1yr rolling returns over 3yr/5yr — fewer negative periods = better |
| Risk-adjusted return (Sharpe) | 15% | Higher Sharpe = better return per unit of risk |
| Downside protection | 15% | Max drawdown, downside capture ratio |
| Expense ratio | 10% | Direct plan expense — lower is better |
| AUM stability | 10% | AUM > Rs 1,000 Cr (equity), avoid extreme AUM growth |
| Fund manager tenure | 5% | > 3 years on same fund preferred |

### Fetch Fund Data

```bash
bash ${CLAUDE_SKILL_DIR}/../bin/fetch-mf-nav.sh <SCHEME_CODE>
```

Or use WebSearch for latest fund data from AMFI, Value Research, or Morningstar India.

### Output: Top 5 Funds

```
TOP FUNDS — [CATEGORY]
══════════════════════════════════════════════════════════════
Rank  Fund Name                    3yr     5yr    Expense  Sharpe  AUM
──────────────────────────────────────────────────────────────
1.    Parag Parikh Flexi Cap       18.2%   16.5%   0.63%   1.12   Rs 52,000 Cr
2.    HDFC Flexi Cap               17.8%   15.9%   0.77%   1.05   Rs 45,000 Cr
3.    Kotak Flexi Cap              16.9%   15.2%   0.59%   0.98   Rs 38,000 Cr
4.    UTI Flexi Cap                16.5%   14.8%   0.68%   0.95   Rs 28,000 Cr
5.    DSP Flexi Cap                16.1%   14.5%   0.72%   0.91   Rs 15,000 Cr
══════════════════════════════════════════════════════════════
Benchmark: Nifty 500 TRI — 3yr: 14.2% | 5yr: 13.1%
Category Avg: 3yr: 15.1% | 5yr: 13.8%
══════════════════════════════════════════════════════════════
```

## Phase 3: Fund Comparison (Option B)

Ask the user for 2-3 fund names, then compare:

```
HEAD-TO-HEAD COMPARISON
══════════════════════════════════════════════════════════════
                        Fund A          Fund B          Fund C
──────────────────────────────────────────────────────────────
Category                Flexi Cap       Flexi Cap       Flexi Cap
AUM                     Rs 52,000 Cr    Rs 45,000 Cr    Rs 38,000 Cr
Expense (Direct)        0.63%           0.77%           0.59%
1yr Return              22.5%           21.8%           20.1%
3yr CAGR                18.2%           17.8%           16.9%
5yr CAGR                16.5%           15.9%           15.2%
Sharpe Ratio            1.12            1.05            0.98
Max Drawdown            -18.5%          -22.1%          -16.8%
Turnover                28%             45%             35%
Top Holding             HDFC Bank 8%    ICICI 7%        Infosys 6%
# Stocks                45              52              38
Large Cap %             65%             72%             60%
Mid Cap %               25%             18%             28%
Small Cap %             10%             10%             12%
Fund Manager            Rajeev Thakkar  Roshi Jain      Harsha Upadhyaya
Manager Since           2013            2022            2018
──────────────────────────────────────────────────────────────
VERDICT: Fund A — best risk-adjusted returns, longest manager tenure
══════════════════════════════════════════════════════════════
```

## Phase 4: Portfolio Overlap (Option C)

Check if the user's funds hold the same underlying stocks:

```
PORTFOLIO OVERLAP ANALYSIS
══════════════════════════════════════════════════════════════
Fund Pair                       Common Stocks    Overlap %
──────────────────────────────────────────────────────────────
Parag Parikh × HDFC Flexi       12 stocks        35%        ⚠ HIGH
Parag Parikh × Nifty 50 Index   18 stocks        52%        ⚠ HIGH
HDFC Flexi × Nifty 50 Index     22 stocks        68%        🔴 VERY HIGH

TOP OVERLAPPING HOLDINGS:
  HDFC Bank      — in all 3 funds (avg weight: 7.2%)
  ICICI Bank     — in all 3 funds (avg weight: 5.8%)
  Infosys        — in all 3 funds (avg weight: 5.1%)
  Reliance       — in all 3 funds (avg weight: 4.9%)

RECOMMENDATION:
  Your 3 funds have 68% overlap with Nifty 50. You're paying
  active fund fees for index-like exposure. Consider:
  • Replace one flexi cap with a mid/small cap fund for true diversification
  • Or switch to a Nifty 50 index fund (0.1% expense) + dedicated midcap
══════════════════════════════════════════════════════════════
```

## Phase 5: SIP Tracker (Option D)

Ask for SIP details (fund, monthly amount, start date), then calculate:

```bash
bash ${CLAUDE_SKILL_DIR}/../bin/sip-calculator.sh --fund "<name>" --amount <monthly> --start <YYYY-MM>
```

```
SIP TRACKER
══════════════════════════════════════════════════════════════
Fund                    Monthly   Start     Invested    Value     XIRR
──────────────────────────────────────────────────────────────
Parag Parikh Flexi      Rs 15K    2021-01   Rs 9.00L    Rs 13.2L  18.5%
HDFC Mid-Cap Opp        Rs 10K    2022-06   Rs 4.50L    Rs 5.8L   16.2%
UTI Nifty 50 Index      Rs 20K    2020-04   Rs 14.40L   Rs 22.1L  15.8%
Nippon Liquid            Rs 5K    2023-01   Rs 1.80L    Rs 1.92L   6.5%
──────────────────────────────────────────────────────────────
TOTAL                   Rs 50K              Rs 29.70L   Rs 43.0L  16.1%
══════════════════════════════════════════════════════════════
```

## Phase 6: Direct vs Regular Switch (Option E)

Calculate the cost of staying in regular plans:

```
DIRECT vs REGULAR — COST OF COMMISSION
══════════════════════════════════════════════════════════════
Fund                    Regular    Direct    Diff    10yr Impact
──────────────────────────────────────────────────────────────
Parag Parikh Flexi      1.62%      0.63%    0.99%   Rs 2.1L lost
HDFC Mid-Cap Opp        1.85%      0.75%    1.10%   Rs 1.4L lost
UTI Nifty 50 Index      0.38%      0.18%    0.20%   Rs 0.6L lost
──────────────────────────────────────────────────────────────
TOTAL 10yr COST OF REGULAR PLANS:                   Rs 4.1L

SWITCH RECOMMENDATION:
  Switch to direct plans via Kuvera/Groww/MFUtility.
  No exit load after 1 year. STCG/LTCG applies on switch.
  Best timing: switch units held > 1 year first (LTCG rate).
══════════════════════════════════════════════════════════════
```

## Phase 7: Next Steps

Offer:
- A) Run `/goal-planner` to map funds to goals
- B) Run `/tax-optimize` to check LTCG/STCG on fund redemptions
- C) Run `/portfolio` to see overall allocation with funds included
- D) Save analysis to `~/.wealth-mgmt/reports/`
