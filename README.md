# WealthStack

AI-powered wealth management plugin for Indian investors.

**27 skills. 26 AI agents. 23 scripts. 10 layers deep. Built for India.**

PMS/AIF due diligence, NRI tax planning, HNI/UHNI advisory, family office governance, goal-based SIPs, SEBI compliance, autonomous research, self-improving agent memory — all from your terminal.

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

## Architecture

WealthStack is built in 10 layers, each adding capability on top of the last:

```
Layer 10  Website & Docs         Marketing site, GUIDE.md, README
Layer 9   Research System         Autonomous research, self-audit, active learning
Layer 8   Agent Memory            26 persistent memory directories, self-improving
Layer 7   Knowledge Packs         4 curated domain bundles (tax, NRI, PMS, retirement)
Layer 6   Knowledge Base          Regulatory rules + historical crisis scenarios
Layer 5   Scripts                 23 CLI tools — data fetching, calculations, analysis
Layer 4   Agents                  26 AI specialists with distinct personas
Layer 3   Skills                  27 slash commands — structured workflows
Layer 2   Plugin Infrastructure   Manifest, settings, configuration
Layer 1   Claude Code             Foundation model + tool access
```

## What's Inside

### Skills (27 slash commands)

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

**Products & Analysis**

| Skill | What It Does |
|-------|-------------|
| `/mutual-funds` | MF screening, comparison, direct plan recommendations |
| `/stock-screener` | NSE/BSE fundamentals — PE, ROE, debt, dividends |
| `/fd-bonds` | FD rate comparison, NCD analysis, G-Sec yields |
| `/insurance-audit` | Term life HLV, health structuring, ULIP evaluation |
| `/tax-filing` | Old vs new regime, 80C/80D optimization, capital gains |
| `/retirement-calc` | FIRE planning, NPS optimization, withdrawal strategy |
| `/wealth-overview` | Lists all skills and capabilities |

**Operations & Monitoring**

| Skill | What It Does |
|-------|-------------|
| `/alerts` | Portfolio monitoring, threshold-based alerts, rebalancing triggers |
| `/market-shock` | Crisis scenario testing, stress modeling |
| `/onboarding` | Client intake, risk profile questionnaire |
| `/annual-review` | Yearly portfolio review and rebalancing |
| `/client-switch` | Multi-client portfolio management |

**Research & Self-Improvement**

| Skill | What It Does |
|-------|-------------|
| `/research` | Autonomous deep research on any financial topic |
| `/audit` | Self-audit of knowledge freshness and accuracy |

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

### Scripts (23 CLI tools)

**Data Fetching**

| Script | What It Does |
|--------|-------------|
| `fetch-quotes.sh` | Stock/ETF quotes via yfinance (NSE/BSE) |
| `fetch-mf-nav.sh` | Mutual fund NAV from AMFI API |
| `fetch-indices.sh` | Nifty/Sensex index data |
| `fetch-fii-dii.sh` | FII/DII flow data |
| `fetch-rbi-rates.sh` | RBI repo rate and policy data |
| `fetch-historical.sh` | Historical prices for backtesting |

**Portfolio Analysis**

| Script | What It Does |
|--------|-------------|
| `import-portfolio.sh` | Import CSV from Zerodha/Groww/Angel One/custom format |
| `portfolio-xirr.sh` | XIRR from portfolio cashflows |
| `enrich-portfolio.sh` | Add sector, market-cap, fundamentals data |
| `parse-cas-pdf.sh` | Parse MF Consolidated Account Statement PDFs |

**Calculations**

| Script | What It Does |
|--------|-------------|
| `sip-calculator.sh` | SIP future value and required SIP calculator |
| `tax-calculator.sh` | Old vs new regime comparison (FY 2025-26) |
| `tax-lot-optimizer.sh` | Lot-level tax optimization (FIFO/HIFO/LIFO) |
| `monte-carlo.sh` | Retirement corpus probability simulation |
| `goal-gap-analyzer.sh` | Goal vs current savings gap analysis |

**Analysis**

| Script | What It Does |
|--------|-------------|
| `nse-screener.sh` | Stock screening by value/quality/growth/dividend |
| `fd-compare.sh` | FD rates across major banks and NBFCs |
| `drift-analyzer.sh` | Portfolio drift from target allocation |
| `suitability-check.sh` | SEBI suitability rule compliance |
| `check-alerts.sh` | Monitor portfolio for alert conditions |
| `backtest.sh` | Historical strategy backtesting |

**Client Management**

| Script | What It Does |
|--------|-------------|
| `client-manager.sh` | Multi-client portfolio management |
| `seed-knowledge.sh` | Initialize knowledge base |

### Knowledge Base

Regulatory rules and historical crisis scenarios that agents reference during analysis.

**Regulatory** (`knowledge/regulatory/`)

| File | Coverage |
|------|----------|
| `sebi-rules.md` | PMS, AIF, RIA regulations, suitability norms |
| `income-tax-rules.md` | Income Tax Act sections, exemptions, deductions |
| `fema-rules.md` | Foreign exchange management for NRIs |
| `rbi-rules.md` | Monetary policy, lending rates, banking rules |

**Historical Scenarios** (`knowledge/scenarios/`)

| Scenario | What agents learn from it |
|----------|--------------------------|
| 2008 Global Financial Crisis | Systemic risk, correlation spikes, recovery patterns |
| 2013 Taper Tantrum | EM currency and debt impact |
| 2016 Demonetization | India-specific liquidity shock |
| 2020 COVID crash | V-shaped recovery, sectoral divergence |
| 2022 Rate Hike Cycle | Duration risk, growth-to-value rotation |

### Knowledge Packs (4 curated bundles)

Shareable, domain-specific knowledge sets in `packs/`:

| Pack | Contents | Enhances |
|------|----------|----------|
| **India Tax 2025** | LTCG/STCG rates, TDS/TCS, deductions, new regime guide | tax-strategist, compliance-checker |
| **NRI US Corridor** | India-US DTAA, FBAR/FATCA, cross-border planning | nri-advisor, tax-strategist |
| **PMS Landscape 2025** | Top PMS managers, fee comparison, PMS vs MF vs AIF | pms-analyst, hni-advisor |
| **Retirement & FIRE** | FIRE India guide, NPS/EPF optimization, withdrawal strategies | retirement-specialist, goal-planner |

### Agent Memory (self-improving knowledge)

Every agent has a persistent memory directory at `.claude/agent-memory/<agent-name>/` that survives across conversations.

**How it works:**
1. Agent checks its memory before responding
2. Evaluates whether a new insight was discovered
3. Saves dated findings (e.g., `ltcg-rate-change-2025.md`)
4. Updates its `MEMORY.md` index
5. Next conversation benefits from accumulated knowledge

26 agents, 26 independent memory stores — each getting smarter with use.

### Research System

Autonomous research capability inspired by Karpathy's autoresearch, accessible via `/research` and `/audit`.

| Mode | How it works |
|------|-------------|
| **Passive Learning** | Agents learn from every user conversation |
| **Active Research** | `/research` triggers deep autonomous research on any topic |
| **Self-Audit** | `/audit` verifies knowledge freshness and flags stale data |

Research output is saved to `research/` and fed back into agent memory.

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
│   └── plugin.json           # Plugin manifest
├── skills/                   # 27 skill directories
│   ├── portfolio/SKILL.md
│   ├── research/SKILL.md
│   ├── alerts/SKILL.md
│   └── ...
├── agents/                   # 26 subagent definitions
│   ├── portfolio-analyzer.md
│   ├── hni-advisor.md
│   └── ...
├── scripts/                  # 23 CLI tools
│   ├── sip-calculator.sh
│   ├── monte-carlo.sh
│   ├── backtest.sh
│   └── ...
├── knowledge/                # Regulatory + historical scenarios
│   ├── regulatory/           # SEBI, Income Tax, FEMA, RBI
│   └── scenarios/            # 2008 GFC, 2020 COVID, etc.
├── packs/                    # 4 knowledge packs
│   ├── india-tax-2025/
│   ├── nri-us-corridor/
│   ├── pms-landscape-2025/
│   └── retirement-fire/
├── research/                 # Autonomous research output
│   └── program.md            # Research framework
├── .claude/agent-memory/     # 26 persistent agent memories
├── docs/                     # Marketing website
├── settings.json             # Default plugin settings
├── GUIDE.md                  # Complete user guide
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
- New knowledge packs (e.g., NRI-UK corridor, NRI-Singapore corridor)
- Historical scenarios (e.g., 2024 election rally)
- Regional language support

## Disclaimer

WealthStack is for informational purposes only. It does not constitute financial, tax, or legal advice. Consult qualified professionals before making investment decisions. Tax laws and regulations change frequently.

## License

MIT

Built for the Indian wealth management community.
