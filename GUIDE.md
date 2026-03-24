# WealthStack — The Complete Guide

## What is WealthStack?

WealthStack is a free, open-source AI assistant that helps you manage your money — specifically designed for Indian investors. Think of it as having a personal wealth manager who understands Indian mutual funds, PMS, AIFs, NRI taxation, SEBI rules, and retirement planning.

You install it as a plugin inside Claude (Anthropic's AI), and it gives Claude superpowers for Indian wealth management.

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

WealthStack has three layers:

### 1. Skills (20 slash commands)

These are things you can ask it to do. Type the command and it runs a structured workflow.

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

...and 12 more covering compliance, insurance, FDs, bonds, stock screening, mutual funds, tax filing, rebalancing, HNI advisory, and family office.

### 2. Agents (11 AI specialists)

Behind each skill is a specialized AI agent — like departments in a wealth management firm:

| Agent | Think of it as... |
|-------|------------------|
| Portfolio Analyzer | Your research analyst who knows every holding |
| Risk Profiler | The quant who calculates Sharpe ratios and runs stress tests |
| Tax Strategist | Your CA who finds every deduction and harvesting opportunity |
| HNI Advisor | The private banker at 360 ONE or Kotak Private |
| PMS Analyst | The product research desk evaluating Marcellus vs ASK |
| Goal Planner | The Dezerv-style advisor mapping every rupee to a goal |
| NRI Advisor | The specialist who knows FEMA, DTAA, and PFIC inside out |
| Family Office Advisor | The Waterfield-style multi-generational wealth structurer |
| Market Researcher | Your morning briefing analyst covering Nifty, RBI, and FII flows |
| Compliance Checker | The SEBI compliance officer running suitability checks |
| Insurance & Estate | The advisor auditing your term life, health cover, and will |

### 3. Scripts (8 CLI tools)

Calculators and data fetchers that the agents use:

- **SIP Calculator** — How much to invest monthly to reach any goal
- **Tax Calculator** — Old regime vs new regime, instant comparison
- **XIRR Calculator** — True returns on your portfolio (time-weighted)
- **FD Comparator** — Rates across SBI, HDFC, Kotak, Bajaj Finance, small finance banks
- **Stock Screener** — Filter NSE/BSE by PE, ROE, debt, dividends
- **MF NAV Fetcher** — Live mutual fund NAVs from AMFI
- **Quote Fetcher** — Live stock prices from NSE/BSE
- **Portfolio Importer** — Parse CSVs from Zerodha, Groww, or custom format

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

---

## Open source — built by the community, for the community

WealthStack is MIT licensed. Free to use, modify, and distribute.

**GitHub**: [github.com/revanupoju/Wealth-Stack](https://github.com/revanupoju/Wealth-Stack)

Contributions welcome:
- More broker CSV formats (Angel One, Upstox, Dhan)
- AMFI MF NAV real-time integration
- NPS/PPF/EPF tracking
- F&O position analysis
- Regional language support (Hindi, Tamil, Telugu, Kannada, Marathi)

---

*Built for the Indian wealth management community.*
