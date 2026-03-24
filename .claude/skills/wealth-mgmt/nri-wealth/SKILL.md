---
name: nri-wealth
version: 1.0.0
description: |
  NRI wealth management — residential status determination, NRE/NRO/FCNR account
  structuring, FEMA compliance, DTAA treaty optimization, PFIC rules for US NRIs,
  repatriation planning (Form 15CA/15CB), and returning NRI (RNOR) transition.
  Country-specific guidance for US, UAE, UK, Singapore, Canada NRIs.
  Use when asked to "NRI planning", "repatriation", "FEMA", "DTAA", or
  when client is a Non-Resident Indian.
allowed-tools:
  - Bash
  - Read
  - Write
  - Agent
  - WebSearch
  - AskUserQuestion
---

# /nri-wealth — NRI Wealth Management

Cross-border wealth management for Non-Resident Indians. Tax optimization across jurisdictions.

## Phase 1: Residential Status Determination

Use AskUserQuestion:

### Question 1: Country of Residence
"Which country do you currently reside in?"
- A) United States
- B) United Arab Emirates (Dubai, Abu Dhabi, etc.)
- C) United Kingdom
- D) Singapore
- E) Canada
- F) Other (specify)

### Question 2: Duration Abroad
"How many years have you been outside India?"
- A) Less than 1 year
- B) 1-3 years
- C) 3-10 years
- D) 10+ years

### Question 3: India Visits
"How many days did you spend in India in the last financial year (April-March)?"
- A) Less than 60 days
- B) 60-120 days
- C) 120-182 days
- D) More than 182 days

### Question 4: Future Plans
"What are your plans regarding India?"
- A) Staying abroad permanently
- B) May return in 5+ years
- C) Planning to return in 1-5 years
- D) Returning within the next year

### Status Determination

Based on answers, classify:

| Status | Criteria | Tax Implication |
|--------|----------|----------------|
| **NRI** | In India < 182 days AND (< 60 days OR 60+ but < 365 days in prior 4 years) | Only India-sourced income taxable |
| **RNOR** | Was NRI, recently returned — for 2 years post-return | Only India-sourced income taxable |
| **Resident** | In India >= 182 days | Global income taxable in India |
| **Deemed Resident** | Indian citizen, Rs 15L+ India income, not taxed elsewhere | Global income taxable |

## Phase 2: Account Structure Recommendation

Invoke the **NRI Wealth Advisory** subagent:

> You are an NRI Wealth Advisory Agent. Recommend the optimal account structure.
>
> Country of residence: [from Phase 1]
> Duration abroad: [from Phase 1]
> Residential status: [determined above]
> Future plans: [from Phase 1]
>
> Recommend NRE/NRO/FCNR account structure and investment plan.

### Account Recommendation Matrix

| Scenario | Primary Account | Why |
|----------|----------------|-----|
| Long-term NRI, no return plans | **NRE** (main) + NRO (India income) | Tax-free interest, full repatriation |
| UAE NRI, high India rental income | NRE + **NRO** (for rent) + FCNR (forex hedge) | NRO for India income, NRE for savings |
| US NRI, planning return in 2 years | NRE (park savings) + **FCNR** (currency hedge) | Convert to resident accounts on return |
| Returning NRI (RNOR period) | **Convert NRE → Resident** + keep FCNR (if any) | Use RNOR window to bring back foreign gains tax-free |

## Phase 3: Country-Specific Advisory

### US NRIs

```
US NRI — CRITICAL ISSUES
══════════════════════════════════════════
⚠ PFIC (Passive Foreign Investment Company):
  Indian mutual funds = PFICs under US tax law
  → Punitive US taxation (excess distribution method)
  → DO NOT invest in Indian MFs from US
  → Instead: use US-domiciled ETFs, direct Indian stocks

⚠ FBAR (FinCEN 114):
  Must report ALL foreign accounts if aggregate > USD 10,000
  → Include: NRE, NRO, demat, PPF, insurance cash value
  → Penalty for non-filing: up to USD 12,909 per account per year

⚠ FATCA (Form 8938):
  Report foreign financial assets
  → Single: > USD 50K (end of year) or > USD 75K (during year)
  → Joint: > USD 100K / USD 150K
  → Separate from FBAR — must file BOTH

⚠ India-US DTAA:
  → Claim Foreign Tax Credit (Form 1116) for India taxes paid
  → Dividends: India TDS 20% → claim as credit on US return
  → Capital gains: taxed in country of residence (US) primarily
  → Interest (NRO): India TDS 30% → claim credit

RECOMMENDED PORTFOLIO FOR US NRIs:
  ✅ Direct Indian stocks (via NRE/NRO demat)
  ✅ US-domiciled ETFs (VT, VWO for India exposure)
  ✅ NRE/FCNR fixed deposits (tax-free in India)
  ✅ Real estate in India (rental income via NRO)
  ❌ Indian mutual funds (PFIC trap)
  ❌ Indian insurance (PFIC + FBAR headache)
  ❌ PPF (cannot open new, existing continues)
══════════════════════════════════════════
```

### UAE NRIs

```
UAE NRI — KEY ADVANTAGES
══════════════════════════════════════════
✅ No income tax in UAE
✅ NRE interest: completely tax-free (India + UAE)
✅ No capital gains tax in UAE
✅ LRS remittance: TCS 20% above Rs 7L (claimable as credit)

RECOMMENDED STRATEGY:
  • Maximize NRE FDs (tax-free 7-8% returns)
  • Invest in Indian MFs (no PFIC issue unlike US)
  • Consider Indian real estate (rent taxable in India at slab)
  • SGBs not available for NRIs — use Gold ETFs instead
  • International diversification via UAE platforms

WATCH OUT:
  ⚠ UAE introducing corporate tax (9%) — doesn't affect individuals yet
  ⚠ India-UAE DTAA under renegotiation — track changes
  ⚠ No social security agreement — plan independently
══════════════════════════════════════════
```

### UK NRIs

```
UK NRI — KEY CONSIDERATIONS
══════════════════════════════════════════
  • UK has its own CGT (10%/20% depending on band)
  • Remittance basis: can choose to be taxed only on UK income
  • India-UK DTAA: comprehensive, covers dividends/interest/CG
  • ISA/pension contributions don't affect India tax
  • Indian MFs: no PFIC issue (UK doesn't have this concept)
  • National Insurance: check totalization agreement status

RECOMMENDED STRATEGY:
  ✅ Use ISA for UK investments (tax-free wrapper)
  ✅ Indian MFs fine (unlike US)
  ✅ NRE FDs for tax-free India returns
  ❌ Watch for double taxation on Indian rental income
══════════════════════════════════════════
```

### Singapore NRIs

```
SINGAPORE NRI — KEY CONSIDERATIONS
══════════════════════════════════════════
  ✅ No capital gains tax in Singapore
  ✅ India-SG DTAA (revised 2017 — no more CGT exemption for shares)
  ✅ Indian MFs allowed, no PFIC issue
  ⚠ Singapore PR vs EP: different tax residency implications
  ⚠ CPF contributions don't apply to India investments

RECOMMENDED STRATEGY:
  • Split investments: Singapore (growth, no CGT) + India (income, familiar)
  • Use NRE for India savings (tax-free interest)
  • Consider GIFT City funds for USD-denominated India exposure
══════════════════════════════════════════
```

## Phase 4: Repatriation Planning

If the client needs to move money from India to abroad:

### NRO Repatriation (up to USD 1M/year)

```
NRO REPATRIATION CHECKLIST
══════════════════════════════════════════
1. □ Ensure all India taxes paid on the funds
2. □ Obtain Form 15CA (online declaration by remitter)
3. □ Obtain Form 15CB (CA certificate — required if remittance > Rs 5L)
4. □ Submit to bank with remittance application
5. □ Bank deducts TDS (30% on interest/dividends) or as applicable
6. □ Claim TCS/TDS as credit in country of residence

COSTS:
  - CA fees for 15CB: Rs 5,000-15,000
  - Bank charges: Rs 500-2,000 per remittance
  - Wire transfer fees: varies by bank
  - Forex conversion spread: 0.25-0.5%
══════════════════════════════════════════
```

### NRE Repatriation (unlimited, freely repatriable)
- No tax clearance needed
- No limit on amount
- Must maintain trail that funds are from foreign sources

## Phase 5: Returning NRI (RNOR) Transition Plan

If the client is returning to India:

```
RNOR TRANSITION TIMELINE
══════════════════════════════════════════
BEFORE RETURN (3-6 months):
  □ Liquidate PFIC positions if coming from US
  □ Maximize NRE FD deposits (while still NRI)
  □ Remit foreign savings to NRE (freely repatriable later)
  □ Close/convert accounts that need action

YEAR 1-2 (RNOR STATUS):
  □ Foreign income NOT taxable in India — use this window!
  □ Bring back foreign investments during RNOR period
  □ Sell foreign property — gains not taxable in India
  □ Convert FCNR deposits at maturity (no premature conversion needed)

  RNOR WINDOW OPPORTUNITIES:
  ✅ Sell foreign stocks/MFs — no India tax
  ✅ Receive foreign rental income — no India tax
  ✅ Redeem foreign insurance — no India tax
  ❌ India-sourced income IS still taxable

AFTER RNOR (Ordinary Resident):
  □ All worldwide income now taxable in India
  □ File ITR with global income disclosure
  □ Use DTAA to avoid double taxation
  □ Convert NRE/NRO to regular resident accounts
══════════════════════════════════════════
```

## Phase 6: Save & Next Steps

Save NRI wealth plan to `~/.wealth-mgmt/plans/nri-plan-<date>.json`.

Offer:
- A) Run `/portfolio` to analyze current India investments
- B) Run `/tax-optimize` for India tax optimization
- C) Run `/hni-advisory` for full wealth structuring (if AUM > Rs 5Cr)
- D) Run `/compliance` to verify FEMA compliance
- E) Save plan and consult a cross-border tax advisor

## Important Disclaimer

> NRI taxation is complex and varies by country of residence, duration, and individual
> circumstances. This tool provides general guidance based on commonly applicable rules.
> Always consult a chartered accountant experienced in NRI taxation and a qualified
> advisor in your country of residence before making financial decisions. Tax treaties
> and regulations change frequently.
