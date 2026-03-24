---
name: family-office
version: 1.0.0
description: |
  Family office advisory for Indian UHNI families with Rs 100Cr+ net worth.
  Family governance, entity structuring (trusts, HUF, holding companies),
  multi-generational succession, philanthropy (Section 8, CSR), and consolidated
  reporting. Modeled after Waterfield Advisors, 360 ONE Family Office, Entrust.
  Use when asked to "family office", "succession plan", "family trust",
  "multi-generational wealth", or for clients with Rs 100Cr+ net worth.
allowed-tools:
  - Bash
  - Read
  - Write
  - Agent
  - WebSearch
  - AskUserQuestion
---

# /family-office — Family Office Advisory

Multi-generational wealth management for Indian UHNI families. Governance, structuring, succession.

## Phase 1: Family Profile

Use AskUserQuestion:

### Question 1: Family Structure
"Describe your family structure:"
- A) Nuclear family (couple + children)
- B) Joint family (parents + siblings + families)
- C) Multi-generational (3+ generations with active members)
- D) Business family (family-run enterprise)

### Question 2: Net Worth Range
"Approximate total family net worth (all members, all assets):"
- A) Rs 100 – 500 crore
- B) Rs 500 – 1,000 crore
- C) Rs 1,000 – 5,000 crore
- D) Rs 5,000 crore+

### Question 3: Primary Wealth Source
"Primary source of family wealth:"
- A) Operating business (promoter family)
- B) Professional income (doctors, lawyers, consultants)
- C) Inherited / generational wealth
- D) Real estate / land holdings
- E) Mix of the above

### Question 4: Priority
"What is the most pressing family office need?"
- A) Governance — family members disagree on investment decisions
- B) Succession — planning wealth transfer to next generation
- C) Structuring — optimizing entities (trusts, HUFs, companies)
- D) Consolidation — we have assets everywhere, no single view
- E) Philanthropy — setting up structured giving
- F) Comprehensive — all of the above

## Phase 2: Family Wealth Map

Invoke the **Family Office Advisory** subagent:

> You are a Family Office Advisory Agent. Build a family wealth map.
>
> Map all entities, assets, and relationships:
>
> Family structure: [from Phase 1]
> Wealth source: [from Phase 1]
> Priority: [from Phase 1]

### Entity Inventory

Ask the user to list (or help discover):

| Entity Type | Name | Purpose | Approx Value |
|-------------|------|---------|-------------|
| Individual accounts | Each family member | Personal investments | |
| HUF | Family HUF | Separate tax entity | |
| Private Trust | [name] | Estate planning | |
| Private Ltd | [name] | Holding company | |
| LLP | [name] | Business/professional | |
| Partnership | [name] | Real estate/business | |
| Section 8 | [name] | Philanthropy | |

### Consolidated Net Worth Statement

```
FAMILY WEALTH MAP
══════════════════════════════════════════════════════════════
ENTITY                          VALUE         % OF TOTAL
──────────────────────────────────────────────────────────────
FINANCIAL ASSETS
  Individual accounts           Rs XX Cr      XX%
  HUF accounts                  Rs XX Cr      XX%
  Trust corpus                  Rs XX Cr      XX%
  PMS/AIF investments           Rs XX Cr      XX%
  Fixed deposits/bonds          Rs XX Cr      XX%
  International (LRS)           Rs XX Cr      XX%

BUSINESS ASSETS
  Operating company (equity)    Rs XX Cr      XX%
  Holding company               Rs XX Cr      XX%

REAL ASSETS
  Real estate                   Rs XX Cr      XX%
  Gold/jewelry                  Rs XX Cr      XX%
  Art/collectibles              Rs XX Cr      XX%

LIABILITIES
  Loans/mortgages              (Rs XX Cr)     XX%
──────────────────────────────────────────────────────────────
NET FAMILY WEALTH               Rs XXX Cr     100%
══════════════════════════════════════════════════════════════
```

## Phase 3: Governance Framework

### Family Constitution Elements

A family constitution (inspired by Waterfield Advisors model) should cover:

1. **Family Values & Philosophy**
   - Investment philosophy (growth vs preservation vs impact)
   - Risk tolerance as a family
   - Views on debt, leverage, speculation

2. **Decision-Making Structure**

```
GOVERNANCE STRUCTURE
══════════════════════════════════════════
Family Council (all adult members)
├── Meets quarterly
├── Sets family investment policy
└── Approves major decisions (>Rs 5Cr)

Investment Committee (3-5 members)
├── Meets monthly
├── Allocates within policy
└── Selects managers/products

Operating Board (1-2 members + advisor)
├── Day-to-day execution
├── Monitors performance
└── Reports to Investment Committee

Advisory Board (external)
├── Wealth advisor (360 ONE/Waterfield type)
├── Tax advisor (CA)
├── Legal advisor
└── Insurance advisor
══════════════════════════════════════════
```

3. **Investment Policy Statement (IPS)**
   - Target allocation ranges by asset class
   - Prohibited investments (if any)
   - Liquidity requirements
   - Benchmark and review frequency
   - Manager selection criteria

4. **Conflict Resolution**
   - Voting mechanism (simple majority vs super-majority)
   - Deadlock resolution (external mediator)
   - Exit provisions (buyout at fair value)

## Phase 4: Entity Structuring

### Recommended Structure (Typical Indian Business Family)

```
RECOMMENDED ENTITY STRUCTURE
══════════════════════════════════════════

Family Trust (Irrevocable, Specific)
├── Beneficiaries: all family members
├── Purpose: estate planning, asset protection
├── Tax: income taxed at beneficiary's rate
│
├── Holding Company (Private Ltd)
│   ├── Operating Business (subsidiary)
│   ├── Real Estate SPV (Private Ltd)
│   └── Investment Portfolio (demat)
│       ├── Listed equity
│       ├── PMS accounts
│       └── AIF commitments
│
├── HUF Accounts (one per branch)
│   ├── Separate Rs 1.25L LTCG exemption
│   ├── Separate basic exemption (Rs 3L new regime)
│   └── MF/equity investments
│
├── Individual Accounts
│   ├── Retirement (NPS, PPF)
│   ├── Insurance policies
│   └── Personal investments
│
└── Section 8 Company (Philanthropy)
    ├── Registered u/s 12AA
    ├── 80G eligible (donors get deduction)
    └── Annual minimum spend: 85% of income

══════════════════════════════════════════
```

### Tax Optimization Across Entities

| Entity | LTCG Exemption | Basic Exemption | Key Benefit |
|--------|---------------|----------------|------------|
| Individual 1 | Rs 1.25L | Rs 3L (new) | Personal investments |
| Individual 2 | Rs 1.25L | Rs 3L | Spouse investments |
| HUF | Rs 1.25L | Rs 3L | Additional exemptions |
| Trust (specific) | At beneficiary rate | Beneficiary's limit | Estate planning |
| Private Ltd | N/A | 25% corporate tax | Business profits |

**Annual tax savings from multi-entity structure:**
- 3 entities × Rs 1.25L LTCG exemption × 12.5% = Rs 46,875 saved
- 3 entities × Rs 3L basic exemption = additional savings on income
- Plus: entity-specific deductions (80C, 80D per entity)

## Phase 5: Succession Planning

### Succession Checklist

```
SUCCESSION STATUS
══════════════════════════════════════════
DOCUMENTS                        STATUS
──────────────────────────────────────────
Registered Will (each member)    □ / ✓
Family Trust Deed                □ / ✓
Business Succession Plan         □ / ✓
Buy-Sell Agreement (business)    □ / ✓
Power of Attorney (financial)    □ / ✓
Healthcare Directive             □ / ✓
Nomination audit (all accounts)  □ / ✓
Digital asset inventory          □ / ✓
Insurance adequacy review        □ / ✓
FEMA compliance (if NRI members) □ / ✓
──────────────────────────────────────────
COMPLETION: X/10
══════════════════════════════════════════
```

### Key India-Specific Succession Rules

- **No estate/inheritance tax** in India (abolished 1985)
- **Nominee ≠ owner** — will overrides nomination (Supreme Court ruling)
- **Hindu Succession Act:** Daughters have equal coparcenary rights in HUF
- **Muslim law:** Sharia succession (cannot be fully overridden by will)
- **Transfer of assets to trust:** May trigger capital gains at time of transfer
- **Life insurance proceeds:** Tax-free under Section 10(10D) if conditions met

## Phase 6: Philanthropy

### Structured Giving Options

| Structure | Setup Cost | Tax Benefit | Control | Effort |
|-----------|-----------|-------------|---------|--------|
| Section 8 Company | Rs 2-5L | 80G for donors, 12AA exempt | Full | High |
| Existing Foundation | None | 80G (if registered) | Low | Low |
| Donor-Advised Fund | Varies | 80G | Medium | Low |
| CSR (if applicable) | Already required | Not deductible (mandatory spend) | Full | High |
| Impact AIF (Cat I) | Rs 1Cr min | Social return + financial return | Low | Low |

### CSR Requirement
If the family's company has net profit > Rs 5 crore or turnover > Rs 1,000 crore or net worth > Rs 500 crore:
- **Mandatory CSR spend:** 2% of average net profit (last 3 years)
- Can route through own Section 8 Company
- Schedule VII activities only

## Phase 7: Reporting & Review

### Quarterly Family Office Report Template

```
FAMILY OFFICE QUARTERLY REPORT — Q1 FY 2026-27
══════════════════════════════════════════════════════════════
1. CONSOLIDATED NET WORTH
   Beginning of quarter:    Rs XXX Cr
   End of quarter:          Rs XXX Cr
   Change:                  +Rs XX Cr (+X.X%)

2. ASSET ALLOCATION VS POLICY
   [table showing actual vs target with drift]

3. PERFORMANCE VS BENCHMARKS
   [returns by entity and asset class]

4. CASH FLOW FORECAST (next 12 months)
   Inflows:   [business dividends, rental, maturity, etc.]
   Outflows:  [lifestyle, education, loan EMI, AIF drawdowns]

5. TAX LIABILITY ESTIMATE (current FY)
   [by entity]

6. GOVERNANCE ITEMS
   Decisions needed: [list]
   Upcoming: [meetings, reviews, renewals]

7. NEXT-GEN UPDATE
   [education, career, involvement status]
══════════════════════════════════════════════════════════════
```

Save family office plan to `~/.wealth-mgmt/plans/family-office-<date>.json`.

Offer:
- A) Generate detailed report with `/client-report`
- B) Run `/compliance` on all entities
- C) Run `/tax-optimize` across all family members
- D) Deep dive on succession/estate planning
- E) Set up quarterly review cadence
