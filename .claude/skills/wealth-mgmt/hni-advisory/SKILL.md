---
name: hni-advisory
version: 1.0.0
description: |
  HNI/UHNI wealth advisory for Indian investors with Rs 5Cr+ portfolios. Client tier
  classification, multi-asset allocation (PMS, AIF, structured products, international
  via LRS), concentrated stock de-risking, and tax structuring (HUF, trusts).
  Modeled after 360 ONE Wealth, Kotak Private, Nuvama Private.
  Use when asked to "HNI planning", "wealth structuring", "high net worth",
  or when portfolio exceeds Rs 5 crore.
allowed-tools:
  - Bash
  - Read
  - Write
  - Agent
  - WebSearch
  - AskUserQuestion
---

# /hni-advisory — HNI/UHNI Wealth Advisory

Bespoke wealth structuring for High Net Worth and Ultra High Net Worth Indian investors.

## Phase 1: Client Classification

Use AskUserQuestion:

"What is the approximate total investable portfolio size (excluding primary residence)?"
- A) Rs 50 lakh – 5 crore (Affluent)
- B) Rs 5 – 25 crore (HNI)
- C) Rs 25 – 100 crore (UHNI)
- D) Rs 100 crore+ (Ultra UHNI / Family Office)

### Tier Routing

| Tier | Service Model | Advisory Style |
|------|--------------|---------------|
| **Affluent** | Digital-first, goal-based | Like Dezerv/Scripbox → redirect to `/goal-planner` |
| **HNI** | Dedicated advisor, PMS + AIF access | Like Centrum Wealth, Neo Wealth |
| **UHNI** | Private banker, bespoke structuring | Like 360 ONE Wealth, Nuvama Private |
| **Ultra UHNI** | Family office services → redirect to `/family-office` | Like Waterfield Advisors |

If Affluent → suggest `/goal-planner` instead (better fit).
If Ultra UHNI → suggest `/family-office` instead (more comprehensive).

## Phase 2: Current Situation Assessment

Gather via AskUserQuestion (one at a time):

1. **Source of wealth:** Business owner / Professional / Inherited / Corporate executive / Mix
2. **Concentrated positions?** "Do you hold >20% of your portfolio in a single stock (e.g., employer ESOP, promoter holdings)?"
3. **Existing products:** "What do you currently hold?" — Direct equity, MFs, PMS, AIF, FDs, bonds, real estate, gold, international
4. **Income bracket:** "What is your marginal income tax rate?" — 30%+ / 25-30% / Below 25%
5. **Liquidity needs:** "Any large expenses in next 2-3 years?" — House, education, business expansion

## Phase 3: Strategic Asset Allocation

Invoke the **HNI/UHNI Advisory** subagent:

> You are an HNI/UHNI Advisory Agent. Design a strategic asset allocation for this client.
>
> Client tier: [HNI/UHNI from Phase 1]
> Source of wealth: [from Phase 2]
> Concentrated positions: [from Phase 2]
> Current holdings: [from Phase 2]
> Tax bracket: [from Phase 2]
> Liquidity needs: [from Phase 2]
> Risk profile: [from ~/.wealth-mgmt/risk-profile.json if available]
>
> Design allocation across these asset classes with specific product recommendations:

### Recommended Allocation Framework (HNI)

| Asset Class | Range | Instruments | Access via |
|-------------|-------|-------------|-----------|
| Listed Equity | 30-50% | Direct stocks, PMS (Marcellus, ASK, Motilal Oswal), Equity MFs (direct) | Demat, PMS account |
| Fixed Income | 20-35% | Corporate bonds, NCDs, banking & PSU debt MFs, SGBs, tax-free bonds | NCD platforms, MF |
| Alternatives | 10-20% | AIFs Cat II (credit, PE), Cat III (long-short) | Via 360 ONE, ICICI Pru, Edelweiss |
| Real Estate | 5-15% | REITs (Embassy, Brookfield, Mindspace), fractional platforms | Demat (REITs), platforms |
| Gold | 5-10% | Sovereign Gold Bonds (tax-free at maturity), Gold ETFs | RBI SGBs, demat |
| International | 5-15% | US equity (via LRS), Intl MFs, GIFT City AIFs | Interactive Brokers, Vested, MF FoFs |
| Cash | 3-5% | Liquid MFs, overnight funds | MF (direct plan) |

### UHNI Gets Additional Access To

- **Structured products:** Market-linked debentures (MLDs), principal-protected notes
- **Pre-IPO opportunities:** Via AIF route or direct participation
- **Private credit:** Performing credit AIFs (Vivriti, Piramal, IIFL)
- **Co-investments:** Alongside PE/VC funds at lower fees
- **GIFT City funds:** USD-denominated, no LTCG on > 3yr holds

## Phase 4: Concentrated Stock De-Risking

If the client holds >20% in a single stock:

```
CONCENTRATED POSITION ANALYSIS
══════════════════════════════════════════
Stock:           RELIANCE (example)
Holding:         Rs 8 Cr (40% of portfolio)
Cost basis:      Rs 2 Cr
Unrealized gain: Rs 6 Cr
LTCG if sold:    Rs 6 Cr × 12.5% = Rs 75 lakh

DE-RISKING STRATEGIES:
──────────────────────────────────────────
1. Systematic selling plan
   - Sell 5% per quarter over 2 years
   - Spread LTCG across financial years
   - Use Rs 1.25L annual exemption each year

2. Covered call writing (if F&O available)
   - Generate income while holding
   - Natural de-risking through premium collection
   - Tax: option premium = business income

3. Diversified SIP from proceeds
   - Route sale proceeds into diversified portfolio
   - Auto-SIP into MFs/PMS for rupee cost averaging

4. Charitable donation route
   - Donate appreciated shares to Section 80G charity
   - No capital gains tax on donated shares
   - Get 50%/100% deduction on FMV donated

5. Hold via trust structure
   - Transfer to family trust
   - Distribute dividends to lower-bracket family members
══════════════════════════════════════════
```

## Phase 5: Tax Structuring

### HUF (Hindu Undivided Family)

- **Separate PAN, separate tax entity**
- Gets its own Rs 1.25 lakh LTCG exemption
- Gets its own basic exemption limit (Rs 3L under new regime)
- Useful for: parking investments, generating separate income stream
- Restriction: only for Hindu, Sikh, Jain, Buddhist families

### Family Trust

- **Irrevocable specific trust:** Income taxed at beneficiary's rate
- **Discretionary trust:** Income taxed at maximum marginal rate (30%+)
- Useful for: estate planning, asset protection, succession
- Setup cost: Rs 50K-2L (legal fees)

### LLP Structure

- For professional/business income routing
- Tax rate: 30% flat (no surcharge up to Rs 1Cr)
- Can invest surplus in markets

## Phase 6: Product Recommendations

Based on the allocation, recommend specific products:

| Asset Class | Product | Manager | Min Ticket | Expected Return |
|-------------|---------|---------|-----------|----------------|
| Large Cap PMS | Consistent Compounders | Marcellus | Rs 50L | 15-18% CAGR |
| Multi Cap PMS | Multicap PMS | 360 ONE | Rs 50L | 14-17% CAGR |
| Credit AIF | Performing Credit | Vivriti/IIFL | Rs 1Cr | 11-14% yield |
| PE AIF | Mid-market PE | 360 ONE/ICICI | Rs 1Cr | 18-22% IRR |
| REIT | Embassy Office Parks | Listed | No minimum | 7-8% yield |
| SGB | Sovereign Gold Bond | RBI | Rs 5000/gm | Gold + 2.5% coupon |
| International | S&P 500 Index | MF FoF/LRS | Varies | 10-12% USD |

## Phase 7: Implementation Roadmap

Present a phased plan:

```
IMPLEMENTATION ROADMAP
══════════════════════════════════════════
Month 1:
  □ Open PMS account(s)
  □ Complete AIF subscription docs
  □ Set up SGB application (next tranche)
  □ Open LRS brokerage account (if international)

Month 2-3:
  □ Fund PMS with initial allocation
  □ Begin concentrated stock selling plan
  □ Start SIP into MFs (direct plan)

Month 4-6:
  □ AIF drawdown schedule begins
  □ Review and adjust based on market conditions
  □ HUF/Trust setup (if applicable)

Ongoing:
  □ Quarterly review with /portfolio
  □ Annual tax optimization with /tax-optimize
  □ Annual compliance check with /compliance
══════════════════════════════════════════
```

Save plan to `~/.wealth-mgmt/plans/hni-plan-<date>.json`.

Offer:
- A) Deep dive into any specific product with `/pms-aif`
- B) Run `/tax-optimize` for detailed tax planning
- C) Run `/compliance` to verify suitability
- D) Generate client report with `/client-report`
