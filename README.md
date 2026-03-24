# WealthStack

**Open-source AI wealth management for Indian investors**

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/revanupoju/Wealth-Stack/pulls)
[![Made in India](https://img.shields.io/badge/Made%20in-India-orange.svg)](#)

The wealth management brain that knows PMS, AIFs, NRI taxation, SEBI rules, and goal-based SIPs. Works on Claude, Cursor, ChatGPT, or any AI tool.

---

## Works Everywhere

| Platform | How to Use |
|----------|-----------|
| **Claude Desktop / Web** | Upload `wealthstack.md` as Project Knowledge |
| **Cursor** | Add `wealthstack.md` to `.cursor/rules/` or project context |
| **Windsurf** | Add `wealthstack.md` to `.windsurfrules` |
| **Claude Code** | `git clone` to `~/.claude/skills/wealthstack` |
| **ChatGPT** | Paste `wealthstack.md` as Custom Instructions |
| **Any LLM** | Use `wealthstack.md` as system prompt |

```bash
git clone https://github.com/revanupoju/Wealth-Stack.git
# Upload wealthstack.md to your AI tool of choice
```

---

## What's Inside

| | Count | Examples |
|-|-------|---------|
| Skills | **20** | `/portfolio` `/pms-aif` `/nri-wealth` `/goal-planner` `/family-office` |
| Subagents | **11** | HNI Advisor, PMS Analyst, Tax Strategist, NRI Specialist |
| CLI Commands | **10** | SIP calculator, XIRR, tax calculator, MF NAV fetcher |
| Connectors | **3** | Market data, portfolio import, document generation |

---

## Skills

### Core Skills

| Skill | Description |
|-------|-------------|
| `portfolio` | Analyze holdings, allocation, performance, concentration risk |
| `risk-assess` | Client risk profiling, stress testing, drawdown analysis |
| `tax-optimize` | LTCG/STCG harvesting, wash sale detection (new regime FY25-26) |
| `rebalance` | Drift analysis, target allocation, tax-aware trade generation |
| `client-report` | Professional HTML reports for client meetings |
| `market-brief` | Nifty 50, Sensex, RBI policy, FII/DII flows, sector analysis |
| `compliance` | SEBI suitability checks, concentration limits, disclosure review |
| `financial-plan` | Retirement projections, estate planning, education funding |

### India Wealth Management Skills

| Skill | Description |
|-------|-------------|
| `pms-aif` | Evaluate PMS managers (Marcellus, ASK, 360 ONE) and AIFs (Cat I/II/III) |
| `hni-advisory` | Rs 5Cr+ structuring — PMS, AIF, structured products, LRS |
| `nri-wealth` | NRI/RNOR tax, FEMA, DTAA, NRE/NRO/FCNR, repatriation |
| `family-office` | Rs 100Cr+ families — trusts, HUF, succession, philanthropy |
| `goal-planner` | Goal-mapped SIPs with glide path — retirement, education, house |
| `mutual-funds` | MF screening, SIP tracking, direct vs regular comparison |
| `stock-screener` | Screen NSE/BSE stocks by fundamentals |
| `fd-bonds` | FD rate comparison, NCD/bond analysis, SGB tracking |
| `tax-filing` | ITR preparation, 80C/80D/80G optimization, old vs new regime |
| `insurance-audit` | Term life HLV, health insurance structuring, ULIP evaluation |
| `retirement-calc` | FIRE calculator, Monte Carlo projections, SWP planning |

---

## Client Tiers

WealthStack adapts recommendations based on portfolio size:

| Tier | AUM | What You Get |
|------|-----|-------------|
| Retail | < Rs 50L | Goal-based SIPs, MF screening, tax optimization |
| Affluent | Rs 50L – 5Cr | Risk assessment, financial planning, MF + ETF advisory |
| HNI | Rs 5Cr – 25Cr | PMS/AIF access, dedicated advisory, tax structuring |
| UHNI | Rs 25Cr – 100Cr | Bespoke allocation, alternatives, SEBI compliance |
| Family Office | Rs 100Cr+ | Multi-gen trusts, succession, philanthropy, governance |

---

## Who Is This For?

- **Retail investors** managing their own SIPs and mutual funds
- **HNIs** evaluating PMS and AIF products
- **NRIs** navigating cross-border taxation (US, UAE, UK, Singapore)
- **Family offices** structuring multi-generational wealth
- **Financial advisors** augmenting their practice with AI
- **Fintech builders** adding AI wealth features to their products

---

## Directory Structure

```
WealthStack/
├── wealthstack.md       # Main prompt — upload this to any AI tool
├── README.md
├── LICENSE
├── skills/              # 20 skill definitions
│   ├── portfolio.md
│   ├── pms-aif.md
│   ├── nri-wealth.md
│   ├── goal-planner.md
│   └── ...
├── subagents/           # 11 specialized AI agents
│   ├── hni-uhni-advisor.md
│   ├── pms-aif-analyst.md
│   ├── nri-wealth-advisor.md
│   └── ...
├── connectors/          # 3 external integrations
│   ├── market-data.md
│   ├── portfolio-import.md
│   └── document-gen.md
└── commands/            # 10 CLI tools
    ├── sip-calculator.sh
    ├── tax-calculator.sh
    ├── portfolio-xirr.sh
    └── ...
```

---

## Contributing

PRs welcome! Areas where we need help:

- **Broker imports** — Angel One, Upstox, Dhan, Zerodha Kite CSV formats
- **AMFI NAV API** — real-time MF NAV integration
- **NPS tracking** — National Pension System portfolio analysis
- **F&O analysis** — Options and futures position tracking
- **More tax scenarios** — Hindu Undivided Family, trust taxation, NRI edge cases
- **Regional languages** — Hindi, Tamil, Telugu, Kannada, Marathi support

---

## Disclaimer

WealthStack is an AI-powered informational tool. It is **not** a registered investment advisor, tax consultant, or financial planner. All outputs are for informational and educational purposes only.

- Consult a SEBI-registered investment advisor before making investment decisions
- Consult a qualified CA/tax professional before implementing tax strategies
- Past performance data referenced in skills does not guarantee future results
- Tax laws and SEBI regulations change frequently — verify current rules

---

## License

MIT License. See [LICENSE](LICENSE) for details.

Built for the Indian wealth management community.
