---
name: market-brief
description: Indian market research and briefing — Nifty, Sensex, RBI policy, FII/DII flows, sector analysis. Use when asked for market update or sector analysis.
context: fork
agent: market-researcher
---

# Market Brief

## Step 1: Scope

Ask the user:
- A) Daily Quick Brief — headlines, major index moves, portfolio impact
- B) Weekly Sector Review — sector rotation, relative performance
- C) Portfolio-Specific — outlook filtered through your holdings
- D) Deep Dive — specific sector, theme, or asset class

## Step 2: Research

Search the web for current data on:
- Major indices: Nifty 50, Sensex, Nifty Bank, Nifty IT, Nifty Midcap 150
- Fixed income: 10-year G-Sec yield, RBI repo rate, corporate bond spreads
- Macro: CPI inflation, IIP, GDP growth, INR/USD
- Flows: FII/FPI net flows, DII flows, MF SIP inflows
- Sectors: BFSI, IT, Pharma, Auto, FMCG, Metals, Realty, Energy
- Policy: RBI MPC decisions, SEBI regulations, government policy

## Step 3: Output

Present in the market brief format with all figures in Indian numbering (lakhs, crores).

If user has a saved portfolio, analyze how market conditions affect their specific holdings.

Save to `~/.wealthstack/reports/market-brief-{date}.md`.
