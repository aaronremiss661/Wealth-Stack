
# /market-brief — Market Research & Briefing

Generate market intelligence relevant to a portfolio or general market conditions.

## Phase 1: Briefing Scope

Ask the user:

"What type of market brief do you need?"
- A) Daily Quick Brief — headlines, major moves, portfolio impact
- B) Weekly Sector Review — sector rotation, relative performance
- C) Portfolio-Specific — market outlook filtered through your holdings
- D) Deep Dive — detailed research on a specific sector, theme, or asset

## Phase 2: Market Research

Delegate to the **Market Researcher** subagent:

> You are a Market Researcher subagent. Compile a market briefing using web search.
>
> Research and summarize:
> 1. **Major indices** — S&P 500, Nasdaq, Dow, Russell 2000, International (MSCI EAFE, EM)
> 2. **Fixed income** — 10-year Treasury yield, yield curve shape, credit spreads
> 3. **Macro indicators** — latest data on inflation (CPI/PCE), employment, GDP, Fed policy
> 4. **Sector performance** — which sectors are leading/lagging and why
> 5. **Notable earnings** — any major earnings reports relevant to this period
> 6. **Geopolitical/risk factors** — trade policy, conflict, regulatory changes
>
> Briefing type: [from Phase 1]
> Portfolio holdings (if applicable): [holdings list]
>
> Use web search to find current data. Cite sources. Present data as of today's date.

## Phase 3: Portfolio Impact Analysis

If the user has a saved portfolio, analyze how market conditions affect their holdings:

- **Holdings in the news:** Flag any portfolio companies with material news
- **Sector headwinds/tailwinds:** How macro trends affect their sector exposure
- **Rate sensitivity:** Impact of yield changes on fixed income and rate-sensitive equity
- **Currency exposure:** FX impact for international holdings

## Phase 4: Market Brief Output

```
MARKET BRIEF — {DATE}
══════════════════════════════════════════

INDICES
  S&P 500:     X,XXX.XX  (+X.X%)
  Nasdaq:      XX,XXX.XX (+X.X%)
  10Y Yield:   X.XX%     (+X bps)

MACRO SNAPSHOT
  Fed Funds:   X.XX-X.XX%
  CPI (YoY):   X.X%
  Unemployment: X.X%

SECTOR LEADERS          SECTOR LAGGARDS
  1. [Sector] +X.X%       1. [Sector] -X.X%
  2. [Sector] +X.X%       2. [Sector] -X.X%
  3. [Sector] +X.X%       3. [Sector] -X.X%

KEY THEMES
  • [Theme 1 — 2-3 sentences]
  • [Theme 2 — 2-3 sentences]
  • [Theme 3 — 2-3 sentences]

PORTFOLIO IMPACT
  • [How this affects your holdings]

══════════════════════════════════════════
```

## Phase 5: Save & Follow-up

Save brief to `~/.wealth-mgmt/reports/market-brief-<date>.md`.

Offer:
- A) Deep dive on a specific topic mentioned above
- B) Run `/portfolio` to see how your holdings are doing
- C) Run `/rebalance` if market conditions suggest allocation changes
