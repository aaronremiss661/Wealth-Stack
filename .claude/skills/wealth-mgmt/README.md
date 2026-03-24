# WealthStack

**AI-powered wealth management skills for Claude Code. Built for Indian investors.**

WealthStack is an open-source Claude Code plugin that gives you a complete wealth management toolkit — portfolio analysis, risk assessment, tax optimization, rebalancing, compliance, and financial planning — all from your terminal.

Inspired by [gstack](https://github.com/garrytan/gstack) by Garry Tan.

---

## Quick Start

```bash
git clone https://github.com/revanupoju/wealthstack.git ~/.claude/skills/wealthstack
cd ~/.claude/skills/wealthstack && ./setup
```

That's it. Open Claude Code and type `/wealth-mgmt` to see everything available.

## What You Get

### 13 Slash Commands

**Core Skills:**

| Command | What it does |
|---------|-------------|
| `/portfolio` | Import holdings (CSV, Zerodha, Groww), analyze allocation, flag concentration risk |
| `/risk-assess` | Risk tolerance questionnaire + quantitative metrics (Sharpe, Sortino, VaR, max drawdown) + stress testing against 2008, COVID, dot-com scenarios |
| `/tax-optimize` | Find tax-loss harvesting opportunities, detect wash sales, optimize lot selection. LTCG/STCG rates for India's new regime |
| `/rebalance` | Drift analysis, trade generation (full, cash-flow, or tax-aware), post-rebalance projection |
| `/client-report` | Generate professional HTML reports — quarterly review, rebalancing proposal, tax plan, or financial plan update |
| `/market-brief` | Market research — Nifty 50, Sensex, RBI policy, sector rotation, macro data, FII/DII flows |
| `/compliance` | SEBI suitability review, concentration limits, documentation checklist |
| `/financial-plan` | Retirement Monte Carlo (1000 scenarios), goal tracking, education funding, estate planning |

**India Wealth Management Skills:**

| Command | What it does | Modeled after |
|---------|-------------|---------------|
| `/pms-aif` | Evaluate PMS managers (Marcellus, ASK, 360 ONE) and AIFs (Cat I/II/III). Fee analysis, peer comparison, suitability | 360 ONE Asset, ASK Investment |
| `/hni-advisory` | Rs 5Cr+ client structuring — PMS, AIF, structured products, international via LRS, concentrated stock de-risking | 360 ONE Wealth, Kotak Private, Nuvama |
| `/nri-wealth` | NRI/RNOR tax planning, FEMA compliance, DTAA optimization, repatriation (Form 15CA/15CB). US/UAE/UK/SG specific | Centrum Wealth, ICICI NRI |
| `/family-office` | Rs 100Cr+ families — trusts, HUF, holding companies, succession, philanthropy (Section 8, CSR) | Waterfield Advisors, 360 ONE FO |
| `/goal-planner` | Goal-mapped SIPs with glide path allocation — retirement, education, house. Gap analysis, direct MF recommendations | Dezerv, Scripbox, Kuvera Pro |

### 11 Subagents

Specialized AI agents that skills delegate to for deep analysis:

**Core:**
- **Portfolio Analyzer** — Holdings deep-dive, attribution, sector/geo exposure
- **Risk Profiler** — Quantitative risk metrics, correlation matrices, stress testing
- **Tax Strategist** — Tax-loss harvesting candidates, wash sale detection, lot optimization
- **Compliance Checker** — SEBI suitability rules, concentration limits, regulatory requirements
- **Market Researcher** — Nifty/Sensex, RBI policy, FII/DII flows, sector rotation

**India Wealth Management:**
- **HNI/UHNI Advisor** — Multi-asset allocation for Rs 5Cr+, PMS/AIF selection, tax structuring via HUF/trusts
- **PMS & AIF Analyst** — Due diligence on PMS managers and AIF products, fee analysis, peer comparison
- **Goal-Based Planner** — Goal-mapped investing, glide path allocation, SIP gap analysis
- **Family Office Advisor** — Multi-gen wealth, trusts, HUF, succession, philanthropy, governance
- **NRI Wealth Advisor** — Cross-border tax, FEMA, DTAA, NRE/NRO/FCNR, repatriation planning
- **Insurance & Estate Advisor** — Term life HLV, health insurance structuring, will/nomination audit

### 3 Connectors

- **Market Data** — Real-time quotes via yfinance (NSE `.NS` / BSE `.BO` tickers, no API key needed)
- **Portfolio Import** — CSV, JSON, Zerodha Console export, Groww export, manual entry
- **Document Generator** — Professional HTML reports with INR formatting (lakhs/crores)

### 4 CLI Commands

```bash
bin/fetch-quotes.sh RELIANCE.NS TCS.NS    # Fetch live quotes
bin/calc-returns.sh --portfolio <path>      # Calculate returns & risk metrics
bin/import-portfolio.sh --format zerodha <csv>  # Import from broker
bin/wealth-config.sh list                   # View/edit configuration
```

## India-First Defaults

| Setting | Default | Description |
|---------|---------|-------------|
| Currency | INR | Indian Rupees |
| Benchmark | ^NSEI | Nifty 50 |
| Exchange | NSE | National Stock Exchange |
| LTCG Rate | 12.5% | Long-term capital gains (new regime, FY 2025-26) |
| STCG Rate | 20% | Short-term capital gains (new regime) |
| LTCG Exemption | Rs 1,25,000 | Annual exemption threshold |
| Risk-Free Rate | 6.5% | Based on RBI repo rate |
| Tax Regime | New | Default to new tax regime |

Change any default:
```bash
bash bin/wealth-config.sh set currency USD
bash bin/wealth-config.sh set benchmark SPY
bash bin/wealth-config.sh set tax_bracket old_regime
```

## Broker Imports

Import directly from your broker's export:

```bash
# Zerodha (Kite Console → Holdings → Download)
bin/import-portfolio.sh --format zerodha holdings.csv

# Groww (Portfolio → Export)
bin/import-portfolio.sh --format groww portfolio.csv

# Generic CSV (columns: ticker, shares, cost_basis)
bin/import-portfolio.sh my-portfolio.csv
```

## Client Tiers

WealthStack adapts recommendations based on portfolio size:

| Tier | AUM | Service Model | Key Skills |
|------|-----|---------------|------------|
| Retail | < Rs 50L | Self-directed, MF/ETF focused | `/portfolio`, `/goal-planner`, `/tax-optimize` |
| Affluent | Rs 50L – 5Cr | Digital advisory, goal-based | `/goal-planner`, `/risk-assess`, `/financial-plan` |
| HNI | Rs 5Cr – 25Cr | PMS + AIF access, dedicated advisory | `/hni-advisory`, `/pms-aif`, `/tax-optimize` |
| UHNI | Rs 25Cr – 100Cr | Bespoke structuring, alternatives | `/hni-advisory`, `/pms-aif`, `/compliance` |
| Family Office | Rs 100Cr+ | Multi-gen, trusts, philanthropy | `/family-office`, `/nri-wealth`, `/compliance` |

## Architecture

```
wealthstack/
├── SKILL.md                    # Hub — /wealth-mgmt entry point
├── portfolio/SKILL.md          # /portfolio
├── risk-assess/SKILL.md        # /risk-assess
├── tax-optimize/SKILL.md       # /tax-optimize
├── rebalance/SKILL.md          # /rebalance
├── client-report/SKILL.md      # /client-report
├── market-brief/SKILL.md       # /market-brief
├── compliance/SKILL.md         # /compliance
├── financial-plan/SKILL.md     # /financial-plan
├── pms-aif/SKILL.md            # /pms-aif (India)
├── hni-advisory/SKILL.md       # /hni-advisory (India)
├── nri-wealth/SKILL.md         # /nri-wealth (India)
├── family-office/SKILL.md      # /family-office (India)
├── goal-planner/SKILL.md       # /goal-planner (India)
├── subagents/                  # Specialized AI agent definitions
│   ├── portfolio-analyzer.md
│   ├── risk-profiler.md
│   ├── tax-strategist.md
│   ├── compliance-checker.md
│   ├── market-researcher.md
│   ├── hni-uhni-advisor.md     # 360 ONE / Kotak / Nuvama model
│   ├── pms-aif-analyst.md      # Marcellus / ASK / 360 ONE model
│   ├── goal-based-planner.md   # Dezerv / Scripbox model
│   ├── family-office-advisor.md # Waterfield / Entrust model
│   ├── nri-wealth-advisor.md   # Cross-border specialist
│   └── insurance-estate-advisor.md
├── connectors/                 # External data integrations
│   ├── market-data.md
│   ├── portfolio-import.md
│   └── document-gen.md
├── bin/                        # CLI commands
│   ├── fetch-quotes.sh
│   ├── calc-returns.sh
│   ├── import-portfolio.sh
│   └── wealth-config.sh
├── setup                       # One-command installer
├── package.json
├── VERSION
├── LICENSE                     # MIT
└── README.md
```

Data is stored in `~/.wealth-mgmt/`:
```
~/.wealth-mgmt/
├── config.json          # Plugin settings
├── portfolios/          # Imported portfolio data
├── reports/             # Generated reports (HTML)
├── plans/               # Financial plans
└── cache/               # Cached market data
```

## How It Works

WealthStack is a collection of **Claude Code skills** — structured prompts that teach Claude how to perform wealth management tasks. When you type a slash command like `/portfolio`, Claude reads the corresponding SKILL.md file and follows its workflow:

1. **Skills** define the interactive workflow (questions, phases, output format)
2. **Subagents** are spawned via Claude's Agent tool for deep analysis
3. **Connectors** document how to fetch external data (market quotes, imports)
4. **CLI commands** are shell scripts that skills invoke for data processing

No separate server or API needed. It all runs locally through Claude Code.

## Requirements

- [Claude Code](https://claude.ai/claude-code) (CLI)
- Python 3.8+ (for market data via yfinance)
- `pip3 install yfinance` (auto-installed by setup)

## Contributing

PRs welcome! Areas where help is needed:

- More broker import formats (Angel One, Upstox, Kotak, ICICI Direct)
- Mutual fund NAV integration (AMFI API)
- NPS/PPF/EPF tracking
- Options/F&O position analysis
- Multi-currency portfolios (for NRI investors)
- Tax-saving investment recommendations (80C, 80D, etc.)

## Disclaimer

WealthStack is an informational tool. It is **not** investment advice, tax advice, or a substitute for qualified financial professionals. Always consult a SEBI-registered investment advisor or chartered accountant before making financial decisions. Past performance does not indicate future results. Tax laws change frequently — verify current rates with your tax advisor.

## License

MIT
