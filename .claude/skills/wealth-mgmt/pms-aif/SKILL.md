---
name: pms-aif
version: 1.0.0
description: |
  PMS & AIF evaluation for Indian HNI/UHNI investors. Due diligence on Portfolio
  Management Services (Marcellus, ASK, 360 ONE, Motilal Oswal) and Alternative
  Investment Funds (Cat I/II/III). Fee analysis, peer comparison, suitability checks.
  Use when asked to "evaluate PMS", "compare AIFs", "PMS due diligence", or
  "which PMS should I invest in".
allowed-tools:
  - Bash
  - Read
  - Write
  - Agent
  - WebSearch
  - AskUserQuestion
---

# /pms-aif — PMS & AIF Evaluation

Evaluate Portfolio Management Services and Alternative Investment Funds for Indian investors.

## Phase 1: What Are You Evaluating?

Use AskUserQuestion:

"What would you like to evaluate?"
- A) A specific PMS strategy (I'll name it)
- B) A specific AIF product (I'll name it)
- C) Compare multiple PMS strategies against each other
- D) Help me find the right PMS/AIF for my goals
- E) General education — explain PMS vs AIF vs Mutual Funds

## Phase 2: Suitability Gate

Before any product evaluation, verify the client meets minimum requirements.

**PMS Minimum Requirements (SEBI):**
- Minimum investment: Rs 50 lakh
- Recommended net worth: > 5x investment (Rs 2.5 Cr+ for minimum ticket)
- Investment horizon: 3+ years
- Risk tolerance: Moderate to Aggressive

**AIF Minimum Requirements (SEBI):**
- Minimum investment: Rs 1 crore
- Recommended net worth: > 5x investment (Rs 5 Cr+)
- Lock-in tolerance: 3-7 years (Cat I/II), varies (Cat III)
- Sophistication: Advanced — understands illiquidity risk

If the client doesn't meet these, recommend mutual funds (direct plans) instead.

## Phase 3: PMS Evaluation

Invoke the **PMS & AIF Analyst** subagent:

> You are a PMS & AIF Analyst for WealthStack. Evaluate the following PMS strategy.
>
> Research via WebSearch:
> 1. SEBI PMS disclosure data for this manager
> 2. AUM growth trend (rapid AUM growth dilutes small/midcap returns)
> 3. Fund manager track record and tenure
> 4. Recent portfolio changes (sector shifts, cash calls)
>
> Evaluate on these dimensions (score 1-10 each):
>
> | Dimension | Weight | What to Check |
> |-----------|--------|---------------|
> | Performance | 25% | 1yr/3yr/5yr CAGR vs Nifty 50/500, rolling returns |
> | Risk Management | 20% | Max drawdown, recovery time, downside capture |
> | Portfolio Quality | 15% | Concentration, market cap mix, sector balance |
> | Fee Efficiency | 15% | Total cost (fixed + performance fee + tax drag from turnover) |
> | Manager Quality | 15% | Track record length, skin in game, team depth |
> | Transparency | 10% | Reporting frequency, SEBI compliance, accessibility |
>
> PMS strategy: [from user input]

### PMS Universe Reference

| Manager | Flagship Strategy | Style | Min Ticket |
|---------|------------------|-------|-----------|
| **Marcellus** | Consistent Compounders | Quality, forensic accounting | Rs 50L |
| **ASK Investment** | India Select | Growth at reasonable price | Rs 50L |
| **Motilal Oswal** | NTDOP (Next Trillion Dollar) | Growth, large-cap oriented | Rs 50L |
| **360 ONE** | Multicap PMS | Diversified, multi-cap | Rs 50L |
| **Alchemy Capital** | High Growth | Mid/small cap | Rs 50L |
| **Unifi Capital** | BCAD | Concentrated, high conviction | Rs 50L |
| **Stallion Asset** | Core Fund | Momentum + quality | Rs 50L |
| **Aequitas** | India Opportunities | Deep value | Rs 50L |
| **IIFL (now 360 ONE)** | Multicap, Special Sits | Multi-strategy | Rs 50L |
| **Carnelian** | Shift Strategy | Thematic, structural shifts | Rs 50L |

## Phase 4: AIF Evaluation

### AIF Categories Explained

| Category | What It Is | Examples | Lock-in | Tax |
|----------|-----------|---------|---------|-----|
| **Cat I** | Venture Capital, SME, Social, Infra | Blume, Fireside, Omnivore | 5-10 yr | Pass-through* |
| **Cat II** | Private Equity, Credit, Distressed | 360 ONE PE, ICICI Credit, Vivriti | 3-5 yr | Pass-through |
| **Cat III** | Long-short, Hedge strategies | True Beacon, Edelweiss Alt, 360 ONE | 1-3 yr | Fund-level |

*VC funds under Cat I have special tax treatment.

### AIF Due Diligence Checklist

For any AIF being evaluated, check:

1. **Fund terms:** Vintage, target fund size, deployment period, drawdown schedule
2. **Track record:** Net IRR, DPI (money returned), TVPI (total value), MOIC
3. **Manager co-invest:** SEBI requires minimum 2.5% of corpus — verify
4. **Portfolio quality:** For credit AIFs, check NPA/default rates; for PE, check exit track record
5. **Fees:** Management fee (typically 2%), carry (15-20%), hurdle rate (8-12%), catch-up
6. **Lock-in & liquidity:** Can you exit early? Secondary market? Extension clauses?
7. **Tax treatment:**
   - Cat I/II: Pass-through — gains taxed in your hands at your rate
   - Cat III: Fund-level tax at maximum marginal rate (leads to tax inefficiency)

## Phase 5: Comparison Table

If comparing multiple products, generate:

```
PMS/AIF COMPARISON
══════════════════════════════════════════════════════════════
                    Strategy A      Strategy B      Strategy C
──────────────────────────────────────────────────────────────
3yr CAGR            18.2%           22.1%           15.8%
Nifty 50 (3yr)      14.5%           14.5%           14.5%
Alpha               +3.7%           +7.6%           +1.3%
Max Drawdown        -18.3%          -28.1%          -12.5%
Sharpe Ratio         1.05            0.92            0.88
# Stocks             18              12              35
Turnover             45%             85%             25%
Fixed Fee            2.0%            2.5%            1.5%
Perf Fee             15% >10%        20% >12%        10% >8%
Est. Tax Drag        1.2%            2.8%            0.6%
TOTAL COST (est.)    3.2%            5.3%            2.1%
──────────────────────────────────────────────────────────────
SCORE (1-10)         7.5             8.0             6.5
VERDICT             Good value       Best returns,    Conservative,
                                    high cost        low cost
══════════════════════════════════════════════════════════════
```

## Phase 6: PMS vs MF Tax Drag Comparison

Critical insight most advisors miss — PMS has higher tax drag than MFs:

| Factor | PMS | Mutual Fund |
|--------|-----|-------------|
| Each trade | Taxable event | No tax until redemption |
| STCG (< 1yr) | 20% on each sale | 20% only on MF redemption |
| LTCG (> 1yr) | 12.5% above Rs 1.25L per trade | 12.5% above Rs 1.25L on redemption |
| High turnover impact | Major — every buy/sell triggers tax | Minimal — fund trades tax-free internally |
| Dividend reinvestment | Taxable | Growth option avoids this |

**Estimate annual tax drag:** Turnover % × average gain × tax rate.
A PMS with 80% turnover may cost 2-3% extra annually vs equivalent MF.

## Phase 7: Recommendation

Present final recommendation:
- **SUITABLE:** Product aligns with client profile and goals
- **SUITABLE WITH CAVEATS:** Product fits but watch for [specific concerns]
- **NOT SUITABLE:** Better alternatives exist or client doesn't meet criteria
- **PREFER MF:** For this client, direct mutual funds offer better net returns after fees and tax

Offer next steps:
- A) Deep dive into the recommended product
- B) Run `/hni-advisory` for full HNI allocation planning
- C) Run `/tax-optimize` to see how PMS/AIF fits the tax picture
- D) Save analysis to `~/.wealth-mgmt/reports/`
