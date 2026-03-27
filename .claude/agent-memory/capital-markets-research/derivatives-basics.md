# Derivatives Basics — Indian Market

Source: NSE, SEBI F&O framework (2024 updates)

## F&O Market Structure
- Exchange: NSE (primary), BSE (limited)
- Settlement: Cash-settled (index derivatives), physical delivery (stock options/futures)
- Expiry: Weekly (Thursday) for Nifty/Bank Nifty; Monthly (last Thursday) for stocks
- Trading hours: 9:15 AM - 3:30 PM IST

## Key Contracts

| Contract | Lot Size | Tick Size | Margin (approx) |
|----------|---------|-----------|-----------------|
| Nifty 50 Futures | 25 | 0.05 | ~Rs 1.2-1.5L |
| Bank Nifty Futures | 15 | 0.05 | ~Rs 1.5-2.0L |
| Nifty Options | 25 | 0.05 | Varies by strike |
| Bank Nifty Options | 15 | 0.05 | Varies by strike |
| FinNifty Options | 25 | 0.05 | Varies by strike |
| Stock Futures | Varies (contract > Rs 5L) | 0.05 | 15-50% of contract |
| Stock Options | Varies | 0.05 | Varies |

## Options Basics

### Call vs Put
| Type | Buyer (Long) | Seller (Short/Writer) |
|------|-------------|---------------------|
| Call | Right to buy at strike price | Obligation to sell at strike price |
| Put | Right to sell at strike price | Obligation to buy at strike price |

### Key Option Greeks
| Greek | Meaning | Typical Range |
|-------|---------|---------------|
| Delta | Price change per 1-point move in underlying | 0 to 1 (call), 0 to -1 (put) |
| Gamma | Rate of change of delta | Highest for ATM options |
| Theta | Time decay per day | Always negative for buyers |
| Vega | Sensitivity to volatility change | Higher for longer expiry |
| Rho | Sensitivity to interest rate | Generally small impact |

### Option Strategies for Wealth Management

| Strategy | Structure | Use Case | Max Loss |
|----------|----------|----------|----------|
| Covered Call | Own stock + sell OTM call | Income on existing holdings | Unlimited downside on stock |
| Protective Put | Own stock + buy put | Portfolio insurance | Premium paid |
| Collar | Own stock + buy put + sell call | Lock in range, low cost | Limited upside, limited downside |
| Bull Call Spread | Buy call + sell higher call | Moderate bullish view | Net premium paid |
| Iron Condor | Sell OTM call + put, buy further OTM | Range-bound market | Difference in strikes - premium |

## India VIX

- Measures Nifty 50 option implied volatility (next 30 days)
- Inversely correlated with Nifty — VIX spikes during crashes

| VIX Level | Market Sentiment | Typical Scenario |
|-----------|-----------------|-----------------|
| < 12 | Very calm, complacency | Prolonged bull market, pre-correction risk |
| 12-15 | Normal | Routine markets |
| 15-20 | Moderate uncertainty | Earnings season, budget, event-driven |
| 20-30 | Elevated fear | Geopolitical events, unexpected policy changes |
| 30-50 | High panic | Significant crisis (IL&FS 2018, rate shock) |
| > 50 | Extreme panic | Black swan (COVID Mar 2020: ~84) |

## SEBI F&O Regulations (2024 Updates)

| Regulation | Change |
|-----------|--------|
| Weekly expiry | Restricted to ONE benchmark index per exchange |
| STT on options selling | Increased to 0.1% of premium (from 0.0625%) |
| STT on futures selling | Increased to 0.02% (from 0.0125%) |
| Lot sizes | Revised to make contract value Rs 15-20L range |
| Calendar spread margin | Only for same-expiry contracts |
| Upfront margin | 100% upfront collection mandatory |
| Peak margin | Intra-day peak margin reporting to exchange |
| Expiry day margin | Additional 2% ELM on expiry day |

## Tax on Derivatives

| Aspect | Treatment |
|--------|-----------|
| Classification | Business income (non-speculative, if proper books maintained) |
| Speculative income | If no proper books, treated as speculative |
| Offset | Non-speculative business loss: Against any business income |
| Carry forward | 8 assessment years |
| Tax audit | Mandatory if turnover >Rs 10 Cr (or Rs 2 Cr and not using 44AD) |
| Turnover calculation | Sum of absolute profit + absolute loss on each trade |
| STT paid | Not deductible as business expense for options |
| GST on brokerage | 18% on brokerage charges |

## Market Microstructure

| Parameter | NSE Details |
|-----------|-------------|
| Order matching | Price-time priority (FIFO within price level) |
| Trading system | NEAT (National Exchange Automated Trading) |
| Circuit breakers | 10%, 15%, 20% on index (Nifty/Sensex) |
| Tick size | Rs 0.05 for equity, Rs 0.01 for some derivatives |
| Settlement cycle | Equity: T+1, Derivatives: T+1 |
| Market hours | Pre-open 9:00-9:08 AM, Normal 9:15 AM-3:30 PM, Post-close 3:30-4:00 PM |
