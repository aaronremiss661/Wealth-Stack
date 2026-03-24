# WealthStack

AI-powered wealth management plugin for Indian investors.

**20 skills. 26 AI agents. Built for India.**

PMS/AIF due diligence, NRI tax planning, HNI/UHNI advisory, family office governance, goal-based SIPs, SEBI compliance — all from your terminal.

## Install

### Claude Code (plugin)

```bash
claude plugin install wealthstack
```

Or load locally during development:

```bash
git clone https://github.com/revanupoju/Wealth-Stack.git
claude --plugin-dir ./Wealth-Stack
```

Then type `/wealthstack:portfolio` or any skill name.

### Claude Desktop / Web

Upload the contents of any `skills/*/SKILL.md` or `agents/*.md` file as **Project Knowledge** in your Claude project.

## What's Inside

### Skills (slash commands)

**Core**

| Skill | What It Does |
|-------|-------------|
| `/portfolio` | Holdings analysis, allocation breakdown, concentration risk |
| `/risk-assess` | Risk questionnaire, Sharpe/VaR/drawdown, stress testing |
| `/tax-optimize` | LTCG/STCG harvesting, wash sale detection, lot optimization |
| `/rebalance` | Drift analysis, trade generation, tax-aware rebalancing |
| `/client-report` | Professional HTML reports for client meetings |
| `/market-brief` | Nifty/Sensex, RBI policy, FII/DII flows, sector analysis |
| `/compliance` | SEBI suitability, concentration limits, documentation audit |
| `/financial-plan` | Retirement Monte Carlo, estate planning, education funding |

**India Wealth Management**

| Skill | What It Does |
|-------|-------------|
| `/pms-aif` | PMS manager evaluation, AIF Cat I/II/III due diligence, fee analysis |
| `/hni-advisory` | Rs 5Cr+ multi-asset structuring, PMS/AIF, LRS international |
| `/nri-wealth` | FEMA, DTAA, PFIC, NRE/NRO/FCNR, repatriation planning |
| `/family-office` | Trusts, HUF, succession, philanthropy, governance |
| `/goal-planner` | Goal-mapped SIPs with glide path allocation |

**More**

| Skill | What It Does |
|-------|-------------|
| `/mutual-funds` | MF screening, comparison, direct plan recommendations |
| `/stock-screener` | NSE/BSE fundamentals — PE, ROE, debt, dividends |
| `/fd-bonds` | FD rate comparison, NCD analysis, G-Sec yields |
| `/insurance-audit` | Term life HLV, health structuring, ULIP evaluation |
| `/tax-filing` | Old vs new regime, 80C/80D optimization, capital gains |
| `/retirement-calc` | FIRE planning, NPS optimization, withdrawal strategy |
| `/wealth-overview` | Lists all skills and capabilities |

### Agents (26 subagents)

**Analysis & Research**

| Agent | Specialization |
|-------|---------------|
| `portfolio-analyzer` | Holdings, allocation, performance attribution |
| `risk-profiler` | Sharpe, Sortino, VaR, stress testing |
| `market-researcher` | Nifty, RBI, FII/DII, sector rotation |
| `capital-markets-research` | IPO analysis, yield curve, derivatives, earnings |

**Advisory**

| Agent | Specialization |
|-------|---------------|
| `investment-counsellor` | IPS drafting, behavioral coaching, suitability |
| `fund-manager` | Stock picking, forensic accounting, portfolio construction |
| `asset-allocator` | Multi-asset models, tactical shifts, rebalancing |
| `hni-advisor` | Rs 5Cr+ structuring, PMS/AIF, LRS |
| `pms-analyst` | PMS/AIF due diligence, fee comparison, tax drag |

**Planning**

| Agent | Specialization |
|-------|---------------|
| `goal-planner` | SIP calculations, glide path, FIRE |
| `retirement-specialist` | Bucket strategy, SWP, NPS optimization |
| `family-office` | Trusts, succession, philanthropy, governance |
| `liquidity-event-planner` | ESOP exits, property sales, lump sum deployment |

**Tax & Compliance**

| Agent | Specialization |
|-------|---------------|
| `tax-strategist` | LTCG/STCG, harvesting, wash sales, HUF |
| `compliance-checker` | SEBI suitability, concentration limits |
| `nri-advisor` | FEMA, DTAA, PFIC, repatriation |

**Specialized**

| Agent | Specialization |
|-------|---------------|
| `insurance-estate` | Term life, health, will/nomination audit |
| `credit-debt-advisor` | Loan optimization, CIBIL, debt restructuring |
| `nbfc-lending` | LAS, LAP, gold loans, MSME lending |
| `alternative-investments` | REITs, InvITs, SGBs, crypto |
| `private-equity` | LP due diligence, J-curve, co-invest |
| `early-stage-investor` | Angel investing, term sheets, AIF Cat I |
| `startup-equity-advisor` | ESOP tax, exercise timing, secondary sales |
| `corporate-treasury` | Cash deployment, FD laddering, working capital |
| `esg-planner` | ESG scoring, BRSR, carbon footprint, green bonds |

**Output**

| Agent | Specialization |
|-------|---------------|
| `deck-creator` | Client-ready portfolio review presentations |

### Scripts (CLI tools)

| Script | What It Does |
|--------|-------------|
| `fetch-quotes.sh` | Stock/ETF quotes via yfinance (NSE/BSE) |
| `sip-calculator.sh` | SIP future value and required SIP calculator |
| `tax-calculator.sh` | Old vs new regime comparison (FY 2025-26) |
| `portfolio-xirr.sh` | XIRR from portfolio cashflows |
| `fd-compare.sh` | FD rates across major banks and NBFCs |
| `fetch-mf-nav.sh` | Mutual fund NAV from AMFI API |
| `nse-screener.sh` | Stock screening by value/quality/growth/dividend |
| `import-portfolio.sh` | Import CSV from Zerodha/Groww/custom format |

## Client Tiers

| Tier | AUM | Recommended Skills |
|------|-----|--------------------|
| Retail | < Rs 50L | `/goal-planner` `/mutual-funds` `/tax-filing` |
| Affluent | Rs 50L – 5Cr | `/goal-planner` `/risk-assess` `/financial-plan` |
| HNI | Rs 5Cr – 25Cr | `/hni-advisory` `/pms-aif` `/tax-optimize` |
| UHNI | Rs 25Cr – 100Cr | `/hni-advisory` `/pms-aif` `/compliance` |
| Family Office | Rs 100Cr+ | `/family-office` `/nri-wealth` `/compliance` |

## Directory Structure

```
wealthstack/
├── .claude-plugin/
│   └── plugin.json        # Plugin manifest
├── skills/                # 20 skill directories
│   ├── portfolio/SKILL.md
│   ├── risk-assess/SKILL.md
│   └── ...
├── agents/                # 26 subagent definitions
│   ├── portfolio-analyzer.md
│   ├── hni-advisor.md
│   └── ...
├── scripts/               # 8 CLI tools
│   ├── sip-calculator.sh
│   └── ...
├── settings.json          # Default plugin settings
├── LICENSE
└── README.md
```

## Contributing

PRs welcome for:
- Zerodha/Groww/Angel One CSV import formats
- AMFI MF NAV API integration
- NPS/PPF/EPF tracking
- F&O position analysis
- More broker formats
- Regional language support

## Disclaimer

WealthStack is for informational purposes only. It does not constitute financial, tax, or legal advice. Consult qualified professionals before making investment decisions. Tax laws and regulations change frequently.

## License

MIT

Built for the Indian wealth management community.
