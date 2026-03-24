
# /stock-screener — Indian Stock Screener

Screen NSE/BSE stocks by fundamental quality, valuation, and dividends.

## Phase 1: Screening Strategy

Ask the user:

"What type of stocks are you looking for?"
- A) Quality Compounders — high ROE, low debt, consistent growth (Marcellus-style)
- B) Value / Undervalued — low PE, high dividend yield, below book value
- C) Growth — high revenue/profit growth, expanding margins
- D) Dividend — steady payout, high yield, growing dividends
- E) Momentum — 52-week highs, strong price action, volume breakouts
- F) Custom — I'll define my own filters

## Phase 2: Pre-Built Screens

### A) Quality Compounders (Coffee Can Approach)

Inspired by Marcellus Consistent Compounders:

| Filter | Criteria | Rationale |
|--------|----------|-----------|
| ROE | > 15% for 10 consecutive years | Sustainable competitive advantage |
| Revenue growth | > 10% CAGR over 10 years | Growing business |
| Debt-to-equity | < 0.5 | Low financial risk |
| Promoter pledging | 0% | No promoter stress |
| Market cap | > Rs 5,000 Cr | Liquidity and stability |
| Free cash flow | Positive for 8 of 10 years | Real earnings, not accounting |

### B) Value Screen

| Filter | Criteria |
|--------|----------|
| PE ratio | < 15 (or < sector median) |
| Price-to-book | < 2 |
| Dividend yield | > 2% |
| Debt-to-equity | < 1 |
| Profit growth (3yr) | > 0% (not value trap) |
| Promoter holding | > 50% |

### C) Growth Screen

| Filter | Criteria |
|--------|----------|
| Revenue growth (3yr CAGR) | > 20% |
| Profit growth (3yr CAGR) | > 25% |
| ROE | > 15% |
| Operating margin | Expanding (YoY) |
| Market cap | Rs 1,000 – 50,000 Cr (mid-cap sweet spot) |

### D) Dividend Screen

| Filter | Criteria |
|--------|----------|
| Dividend yield | > 3% |
| Payout consistency | Paid dividends for 5+ consecutive years |
| Payout ratio | 20-60% (sustainable) |
| Profit growth | > 5% CAGR (growing dividends) |
| Debt-to-equity | < 1 |

## Phase 3: Run Screen

```bash
bash commands/nse-screener.sh --screen "<screen_type>" --limit 20
```

Or use WebSearch to pull data from Screener.in, Trendlyne, or Ticker Tape.

### Output Format

```
STOCK SCREEN — QUALITY COMPOUNDERS
══════════════════════════════════════════════════════════════
#   Ticker     Company              MCap    PE    ROE   D/E   10yr Growth
──────────────────────────────────────────────────────────────────────────
1.  NESTLEIND   Nestle India        Rs 2.1L Cr  72   108%  0.0   14%
2.  PIDILITIND  Pidilite Industries Rs 1.5L Cr  85    25%  0.1   17%
3.  ASIANPAINT  Asian Paints        Rs 2.8L Cr  58    28%  0.1   15%
4.  HDFCBANK    HDFC Bank           Rs 12L Cr   19    17%  N/A   20%
5.  TCS         TCS                 Rs 14L Cr   29    48%  0.0   12%
6.  INFY        Infosys             Rs 7L Cr    27    32%  0.0   13%
7.  BAJFINANCE  Bajaj Finance       Rs 4.5L Cr  32    22%  3.2   35%
8.  DMART       Avenue Supermarts   Rs 3.2L Cr  105   16%  0.0   25%
──────────────────────────────────────────────────────────────────────────
Filters: ROE>15% (10yr), Revenue CAGR>10%, D/E<0.5, MCap>5000Cr
══════════════════════════════════════════════════════════════
```

## Phase 4: Deep Dive (Optional)

For any stock the user selects, provide:

```
STOCK DEEP DIVE — HDFC BANK
══════════════════════════════════════════
FUNDAMENTALS:
  Market Cap:    Rs 12,00,000 Cr     PE:        19.2
  Price:         Rs 1,650             PB:        3.1
  ROE:           17.2%               ROCE:       —
  D/E:           N/A (bank)          NPA:        1.2% (gross)
  Dividend Yield: 1.1%               Payout:     23%

GROWTH (CAGR):
  Revenue:  5yr 18% | 10yr 20%
  Profit:   5yr 20% | 10yr 22%
  Book Value: 5yr 16%

SHAREHOLDING:
  Promoter:     26%  (stable)
  FII:          33%  (slight increase)
  DII:          23%
  Public:       18%

STRENGTHS:
  ✅ Largest private bank by assets
  ✅ Consistent profit growth (20yr track record)
  ✅ Low NPA vs industry

RISKS:
  ⚠ Promoter holding at minimum regulatory level
  ⚠ Unsecured loan book growing
  ⚠ Competition from fintechs in retail
══════════════════════════════════════════
```

## Phase 5: Next Steps

Offer:
- A) Add screened stocks to watchlist
- B) Run `/portfolio` to check overlap with existing holdings
- C) Run `/risk-assess` on a stock pick list
- D) Run `/pms-aif` to compare with PMS strategies holding these stocks
- E) Save screen results to `~/.wealth-mgmt/reports/`

## Disclaimer

> Stock screening is for research purposes. Past fundamentals do not guarantee
> future performance. Always do your own due diligence. This is not a buy/sell
> recommendation. Consult a SEBI-registered investment advisor.
