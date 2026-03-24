
# /wealth-mgmt — Wealth Management Plugin

Your AI-powered wealth management assistant. This plugin provides a complete
suite of tools for portfolio management, financial planning, and client advisory.

## Available Skills

### Core Skills

| Skill | Command | Description |
|-------|---------|-------------|
| Portfolio Analysis | `/portfolio` | Analyze holdings, allocation, performance, and concentration risk |
| Risk Assessment | `/risk-assess` | Client risk profiling, portfolio stress testing, drawdown analysis |
| Tax Optimization | `/tax-optimize` | Tax-loss harvesting, capital gains management (LTCG/STCG, new regime) |
| Rebalancing | `/rebalance` | Drift analysis, target allocation, rebalancing trade generation |
| Client Reports | `/client-report` | Generate professional HTML reports for client meetings |
| Market Brief | `/market-brief` | Nifty 50, Sensex, RBI policy, sector analysis, FII/DII flows |
| Compliance | `/compliance` | SEBI suitability checks, concentration limits, disclosure review |
| Financial Plan | `/financial-plan` | Retirement projections, estate planning, education funding |

### India Wealth Management Skills

| Skill | Command | Description | Modeled After |
|-------|---------|-------------|---------------|
| PMS & AIF | `/pms-aif` | Evaluate PMS managers (Marcellus, ASK, 360 ONE) and AIFs (Cat I/II/III) | 360 ONE Asset, ASK Investment |
| HNI Advisory | `/hni-advisory` | Rs 5Cr+ client structuring — PMS, AIF, structured products, LRS | 360 ONE Wealth, Kotak Private, Nuvama |
| NRI Wealth | `/nri-wealth` | NRI/RNOR tax planning, FEMA, DTAA, repatriation (US/UAE/UK/SG) | Centrum Wealth, ICICI NRI Services |
| Family Office | `/family-office` | Rs 100Cr+ families — trusts, HUF, succession, philanthropy | Waterfield Advisors, 360 ONE FO |
| Goal Planner | `/goal-planner` | Goal-mapped SIPs with glide path — retirement, education, house | Dezerv, Scripbox, Kuvera Pro |

## Subagents

### Core Subagents

| Agent | Purpose |
|-------|---------|
| Portfolio Analyzer | Deep-dive on holdings, returns attribution, sector/geo exposure |
| Risk Profiler | Quantitative risk metrics — Sharpe, Sortino, VaR, max drawdown |
| Tax Strategist | Tax-loss harvesting, LTCG/STCG optimization, wash sale detection |
| Compliance Checker | SEBI suitability rules, concentration limits, regulatory requirements |
| Market Researcher | Nifty/Sensex, RBI policy, FII/DII flows, sector rotation |

### India Wealth Management Subagents

| Agent | Purpose | Firm Reference |
|-------|---------|---------------|
| HNI/UHNI Advisor | Multi-asset allocation for Rs 5Cr+, PMS/AIF selection, tax structuring | 360 ONE, Kotak Private, Nuvama |
| PMS & AIF Analyst | Due diligence on PMS managers and AIF products, fee analysis, peer comparison | Marcellus, ASK, 360 ONE Asset |
| Goal-Based Planner | Goal-mapped investing, glide path allocation, SIP gap analysis | Dezerv, Scripbox |
| Family Office Advisor | Multi-gen wealth, trusts, HUF, succession, philanthropy, governance | Waterfield, Entrust, Cervin |
| NRI Wealth Advisor | Cross-border tax, FEMA, DTAA, NRE/NRO/FCNR, repatriation planning | Centrum Wealth |
| Insurance & Estate Advisor | Term life HLV, health insurance structuring, will/nomination audit | — |

## Connectors

External data integrations:

| Connector | Purpose |
|-----------|---------|
| Market Data | Fetch real-time and historical quotes, fundamentals, and benchmarks |
| Portfolio Import | Ingest portfolio data from CSV, JSON, or brokerage exports |
| Document Generator | Produce HTML/PDF client reports from templates |

## Commands (CLI)

Shell utilities that skills and subagents invoke:

| Command | Purpose |
|---------|---------|
| `fetch-quotes.sh` | Fetch stock/ETF/fund quotes and fundamentals |
| `calc-returns.sh` | Compute returns, CAGR, risk-adjusted metrics |
| `import-portfolio.sh` | Parse and normalize portfolio CSV/JSON files |
| `wealth-config.sh` | Manage plugin configuration (API keys, defaults) |

## Client Tiers

WealthStack adapts its recommendations based on client AUM:

| Tier | AUM | Service Model | Key Skills |
|------|-----|---------------|------------|
| Retail | < Rs 50L | Self-directed, MF/ETF focused | `/portfolio`, `/goal-planner`, `/tax-optimize` |
| Affluent | Rs 50L – 5Cr | Digital advisory, goal-based | `/goal-planner`, `/risk-assess`, `/financial-plan` |
| HNI | Rs 5Cr – 25Cr | PMS + AIF access, dedicated advisory | `/hni-advisory`, `/pms-aif`, `/tax-optimize` |
| UHNI | Rs 25Cr – 100Cr | Bespoke structuring, alternatives | `/hni-advisory`, `/pms-aif`, `/compliance` |
| Family Office | Rs 100Cr+ | Multi-gen, trusts, philanthropy | `/family-office`, `/nri-wealth`, `/compliance` |

## Quick Start

1. **Import a portfolio:** `/portfolio` → provide a CSV (Zerodha/Groww export) or manual entry
2. **Set goals:** `/goal-planner` → map investments to life goals (Dezerv-style)
3. **Assess risk:** `/risk-assess` → risk metrics and stress test against 2008/COVID
4. **Optimize taxes:** `/tax-optimize` → LTCG/STCG harvesting (new regime rates)
5. **Evaluate PMS:** `/pms-aif` → compare Marcellus, ASK, 360 ONE and others
6. **Rebalance:** `/rebalance` → generate tax-aware rebalancing trades
7. **Report:** `/client-report` → professional HTML report with INR formatting

## Configuration

Plugin settings are stored in `~/.wealth-mgmt/config.json`:

```bash
# Set up API key for market data
bash commands/wealth-config.sh set api_key "YOUR_KEY"

# Set default benchmark
bash commands/wealth-config.sh set benchmark "SPY"

# Set default currency
bash commands/wealth-config.sh set currency "USD"
```

## Data Directory

All portfolio data, reports, and cached market data are stored in `~/.wealth-mgmt/`:

```
~/.wealth-mgmt/
├── config.json          # Plugin settings
├── portfolios/          # Imported portfolio files
├── reports/             # Generated client reports
├── cache/               # Cached market data
└── templates/           # Custom report templates
```
