# WealthStack — The Complete Guide

## What is WealthStack?

WealthStack is a free, open-source AI assistant that helps you manage your money — specifically designed for Indian investors. Think of it as having a personal wealth manager who understands Indian mutual funds, PMS, AIFs, NRI taxation, SEBI rules, and retirement planning.

You install it as a plugin inside Claude (Anthropic's AI), and it gives Claude superpowers for Indian wealth management.

It's built in 10 layers — 27 skills, 26 AI agents, 23 scripts, a regulatory knowledge base, curated knowledge packs, self-improving agent memory, and an autonomous research system.

---

## Who is it for?

| You are a... | WealthStack helps you... |
|-------------|------------------------|
| **Salaried professional** investing in SIPs | Pick the right mutual funds, plan for retirement, save tax |
| **Self-directed investor** with a stock portfolio | Analyze holdings, find tax-loss harvesting opportunities, rebalance |
| **HNI (Rs 5 Cr+)** exploring PMS and AIFs | Evaluate Marcellus, ASK, 360 ONE — fees, returns, tax drag |
| **NRI** investing in India | Navigate NRE/NRO accounts, FEMA rules, DTAA treaties, PFIC traps |
| **Family office (Rs 100 Cr+)** | Structure trusts, HUF, holding companies, plan succession |
| **Financial advisor** | Augment your practice with AI-powered analysis and reports |

---

## What can it do?

### For everyday investors

**"Which mutual fund should I pick?"**
WealthStack screens funds by category, compares expense ratios, tracks SIP performance, and always recommends direct plans (saving you 0.5-1% annually in commissions).

**"Am I saving enough for retirement?"**
It runs 1,000 simulated scenarios of your financial future. Tells you your FIRE number, required monthly SIP, and whether you're on track — with specific fixes if you're not.

**"How do I save tax on my investments?"**
Scans your portfolio for tax-loss harvesting opportunities. Knows the new tax rates (LTCG 12.5% above Rs 1.25 lakh, STCG 20%). Compares old regime vs new regime. Suggests HUF structuring for double exemption.

**"Analyze my Zerodha portfolio"**
Import your holdings CSV directly. Gets live prices, shows allocation by sector/market cap, flags concentration risk, compares performance vs Nifty 50.

**"What's happening in the market today?"**
Morning briefing with Nifty/Sensex levels, RBI policy updates, FII/DII flows, sector rotation signals, and earnings highlights.

### For HNIs and UHNIs

**"Should I invest in Marcellus PMS?"**
Evaluates any PMS: track record, fees (fixed + performance), tax drag vs comparable mutual funds, portfolio concentration, manager tenure. Compares side-by-side with peers.

**"What AIFs should I consider?"**
Analyzes Alternative Investment Funds across all three SEBI categories. Cat I (venture capital), Cat II (private equity, credit), Cat III (hedge funds). Checks lock-in periods, minimum tickets, and suitability.

**"Structure my Rs 50 Cr portfolio"**
Multi-asset allocation across listed equity, fixed income, alternatives, real estate (REITs), gold (SGBs), and international (LRS route). Tax structuring with HUF and trusts.

### For NRIs

**"I'm in the US, can I buy Indian mutual funds?"**
Warns you about the PFIC trap — Indian mutual funds are classified as Passive Foreign Investment Companies under US tax law, triggering punitive taxation. Recommends alternatives like direct equity or US-domiciled ETFs.

**"How do I send money back from India?"**
Explains the full repatriation process: NRO account limits (USD 1M/year), Form 15CA/15CB from your CA, TDS implications. NRE accounts are freely repatriable.

**"I'm moving back to India"**
Plans your RNOR (Returning NRI) transition — up to 2 years where foreign income isn't taxed in India. Tells you what to do before, during, and after the move.

### For family offices

**"Set up a family office structure"**
Recommends the right combination of entities: irrevocable trust for asset protection, private limited as holding company, HUF for each family branch, Section 8 company for philanthropy.

**"Plan succession for our business family"**
Will drafting checklist, nomination audit across all accounts (demat, bank, insurance, MF), business buy-sell agreements, and the critical reminder: nominee ≠ owner under Indian law.

---

## How does it work?

WealthStack is built in 10 layers:

```
Layer 10  Website & Docs         Marketing site, this guide, README
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

### 1. Skills (27 slash commands)

These are things you can ask it to do. Type the command and it runs a structured workflow.

**Core workflows:**

| Command | What happens |
|---------|-------------|
| `/wealthstack:portfolio` | Imports your holdings, fetches live prices, analyzes everything |
| `/wealthstack:goal-planner` | Maps your life goals to SIPs with automatic glide path |
| `/wealthstack:tax-optimize` | Finds every tax-saving opportunity in your portfolio |
| `/wealthstack:pms-aif` | Deep due diligence on any PMS or AIF product |
| `/wealthstack:nri-wealth` | Complete NRI financial planning for your corridor |
| `/wealthstack:retirement-calc` | FIRE number, Monte Carlo simulation, NPS optimization |
| `/wealthstack:market-brief` | Today's Nifty/Sensex, RBI policy, FII flows, sector analysis |
| `/wealthstack:client-report` | Generates a professional HTML report you can share |

**Operations & monitoring:**

| Command | What happens |
|---------|-------------|
| `/wealthstack:alerts` | Set threshold-based alerts on portfolio drift, price moves |
| `/wealthstack:market-shock` | Stress test your portfolio against crisis scenarios |
| `/wealthstack:onboarding` | New client intake with risk profiling |
| `/wealthstack:annual-review` | Yearly portfolio health check and rebalancing |
| `/wealthstack:client-switch` | Switch between multiple client portfolios |

**Research & self-improvement:**

| Command | What happens |
|---------|-------------|
| `/wealthstack:research` | Deep autonomous research on any financial topic |
| `/wealthstack:audit` | Self-checks knowledge freshness, flags stale data |

...plus 9 more covering compliance, insurance, FDs, bonds, stock screening, mutual funds, tax filing, rebalancing, HNI advisory, and family office.

### 2. Agents (26 AI specialists)

Behind each skill is a specialized AI agent — like departments in a wealth management firm:

**Analysis & Research**

| Agent | Think of it as... |
|-------|------------------|
| Portfolio Analyzer | Your research analyst who knows every holding |
| Risk Profiler | The quant who calculates Sharpe ratios and runs stress tests |
| Market Researcher | Your morning briefing analyst covering Nifty, RBI, and FII flows |
| Capital Markets Research | The desk tracking IPOs, derivatives, yield curves, and earnings |

**Advisory**

| Agent | Think of it as... |
|-------|------------------|
| Investment Counsellor | The SEBI RIA drafting your Investment Policy Statement |
| Fund Manager | The stock picker with forensic accounting skills |
| Asset Allocator | The strategist deciding equity vs debt vs alternatives |
| HNI Advisor | The private banker at 360 ONE or Kotak Private |
| PMS Analyst | The product research desk evaluating Marcellus vs ASK |

**Planning**

| Agent | Think of it as... |
|-------|------------------|
| Goal Planner | The Dezerv-style advisor mapping every rupee to a goal |
| Retirement Specialist | The pension planner optimizing NPS, EPF, and bucket strategy |
| Family Office Advisor | The Waterfield-style multi-generational wealth structurer |
| Liquidity Event Planner | The ESOP exit specialist — pre-IPO, secondary sales, lump sums |

**Tax & Compliance**

| Agent | Think of it as... |
|-------|------------------|
| Tax Strategist | Your CA who finds every deduction and harvesting opportunity |
| Compliance Checker | The SEBI compliance officer running suitability checks |
| NRI Advisor | The specialist who knows FEMA, DTAA, and PFIC inside out |

**Specialized**

| Agent | Think of it as... |
|-------|------------------|
| Insurance & Estate | The advisor auditing your term life, health cover, and will |
| Credit & Debt Advisor | The loan optimizer — CIBIL, refinancing, debt restructuring |
| NBFC Lending | The LAS/LAP specialist for loans against securities and property |
| Alternative Investments | The REIT, InvIT, SGB, and crypto allocation advisor |
| Private Equity | The LP due diligence analyst evaluating PE fund commitments |
| Early Stage Investor | The angel investing and AIF Cat I specialist |
| Startup Equity Advisor | The ESOP tax expert — exercise timing, secondary sales |
| Corporate Treasury | The CFO's desk — cash deployment, FD laddering, working capital |
| ESG Planner | The sustainability analyst — BRSR, carbon footprint, green bonds |
| Deck Creator | The presentation team generating client-ready portfolio reviews |

### 3. Scripts (23 CLI tools)

Calculators and data fetchers that the agents use under the hood:

**Data fetching** — Live stock quotes, MF NAVs, index data, FII/DII flows, RBI rates, historical prices

**Portfolio analysis** — CSV import (Zerodha/Groww/Angel One), XIRR calculation, portfolio enrichment, CAS PDF parsing

**Calculations** — SIP calculator, tax calculator (old vs new regime), lot-level tax optimizer (FIFO/HIFO/LIFO), Monte Carlo retirement simulation, goal gap analysis

**Analysis** — Stock screener, FD rate comparison, drift analyzer, SEBI suitability check, alert monitoring, strategy backtesting

**Client management** — Multi-client portfolio manager, knowledge base seeder

### 4. Knowledge Base

Hard-coded regulatory rules and historical scenarios that agents reference during analysis.

**Regulatory knowledge:**
- SEBI rules — PMS minimums, AIF categories, RIA regulations, suitability norms
- Income Tax Act — Sections, exemptions, deductions, capital gains rates
- FEMA — Foreign exchange rules for NRIs
- RBI — Monetary policy, repo rates, lending norms

**Historical scenarios:**
Agents use past crises to stress-test your portfolio and contextualize market events:
- 2008 Global Financial Crisis
- 2013 Taper Tantrum
- 2016 Demonetization
- 2020 COVID crash
- 2022 Rate Hike Cycle

### 5. Knowledge Packs

Curated, domain-specific knowledge bundles that supercharge specific agents:

| Pack | What it adds |
|------|-------------|
| **India Tax 2025** | Latest LTCG/STCG rates, TDS/TCS tables, deductions, new regime guide |
| **NRI US Corridor** | India-US DTAA, FBAR/FATCA rules, cross-border planning strategies |
| **PMS Landscape 2025** | Top PMS manager profiles, fee structures, PMS vs MF vs AIF comparison |
| **Retirement & FIRE** | FIRE India guide, NPS/EPF optimization, withdrawal strategies |

### 6. Agent Memory

Every agent has a persistent memory directory that survives across conversations. When the tax strategist learns something new about a recent budget change, or the NRI advisor discovers a DTAA nuance — they save it. Next time you ask, they already know.

26 agents, 26 independent memory stores — each getting smarter with every conversation.

### 7. Research System

Autonomous research capability, so WealthStack doesn't just answer — it actively learns:

- **Passive learning** — Agents save insights from every user conversation
- **Active research** — `/research` triggers deep investigation on any financial topic
- **Self-audit** — `/audit` checks knowledge freshness and flags outdated data

Research output is saved to `research/` and fed back into agent memory for future use.

---

## How to install

### Claude Code (terminal)

```bash
git clone https://github.com/revanupoju/Wealth-Stack.git
claude --plugin-dir ./Wealth-Stack
```

Then type any command like `/wealthstack:portfolio`.

### Claude.ai (web/desktop)

Once approved in the plugin marketplace, just search "WealthStack" in Browse Plugins and click Install.

---

## What makes it different?

| Traditional wealth management | WealthStack |
|------------------------------|-------------|
| Rs 75K+/year for SEBI RIA | Free (MIT license) |
| 1-2% AUM fee for PMS advisory | Free |
| RM covers 200+ clients | Dedicated to you |
| Generic global advice | India-specific (SEBI, Income Tax Act, FEMA) |
| Quarterly reports (if you're lucky) | Instant analysis anytime |
| Minimum Rs 50L for PMS access | Evaluates PMS/AIF for anyone |
| One-size-fits-all | Adapts from Rs 5L retail to Rs 100Cr+ family office |
| Static knowledge, annual training | Self-improving agents that learn with every conversation |
| No memory of past conversations | Persistent memory across sessions |

---

## What it does NOT do

- **Not a SEBI-registered advisor** — It's an AI tool, not a licensed RIA
- **Cannot execute trades** — It analyzes and recommends, you execute on your broker
- **Not real-time data** — Uses yfinance and AMFI API, slight delay possible
- **Not a replacement for professionals** — Complex tax situations need a CA, estate planning needs a lawyer
- **No guaranteed returns** — Past performance analysis doesn't predict future results

Always consult qualified professionals (CA, SEBI RIA, lawyer) before making financial decisions.

---

## India-specific knowledge built in

| Area | What it knows |
|------|--------------|
| **Tax** | LTCG 12.5% (above Rs 1.25L), STCG 20%, old vs new regime, 80C/80D/80G, HUF exemptions |
| **SEBI** | PMS minimum Rs 50L, AIF minimum Rs 1 Cr, RIA regulations, suitability rules |
| **Products** | Marcellus, ASK, 360 ONE, Motilal Oswal PMS. Cat I/II/III AIFs. Direct vs regular MFs |
| **NRI** | FEMA, DTAA (US/UAE/UK/SG), NRE/NRO/FCNR, PFIC, Form 15CA/15CB, LRS (USD 250K) |
| **Retirement** | EPF (8.15%), NPS (80CCD), PPF (7.1%), SWP bucket strategy |
| **Insurance** | Term life HLV, health super top-up structuring, ULIP evaluation |
| **Estate** | No inheritance tax in India, nominee ≠ owner, trust structures, Section 8 |
| **Gold** | SGBs (2.5% interest + tax-free at maturity), Gold ETFs |
| **Real estate** | REITs, fractional ownership platforms |
| **FDs** | Bank FD rates, corporate FD (Bajaj, Mahindra), small finance banks |
| **Crisis history** | 2008 GFC, 2013 Taper Tantrum, 2016 Demonetization, 2020 COVID, 2022 Rate Hikes |

---

## Open source — built by the community, for the community

WealthStack is MIT licensed. Free to use, modify, and distribute.

**GitHub**: [github.com/revanupoju/Wealth-Stack](https://github.com/revanupoju/Wealth-Stack)

Contributions welcome:
- More broker CSV formats (Angel One, Upstox, Dhan)
- AMFI MF NAV real-time integration
- NPS/PPF/EPF tracking
- F&O position analysis
- New knowledge packs (NRI-UK corridor, NRI-Singapore corridor)
- Historical scenarios (2024 election rally, 2025 tariff wars)
- Regional language support (Hindi, Tamil, Telugu, Kannada, Marathi)

---

*Built for the Indian wealth management community.*
