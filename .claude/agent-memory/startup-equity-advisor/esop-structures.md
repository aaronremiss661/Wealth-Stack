# ESOP Structures in India

Source: Companies Act 2013, Income Tax Act, SEBI SBEB Regulations

## ESOP Components

| Component | Description |
|-----------|------------|
| Grant | Company offers option to buy shares at exercise price |
| Cliff | Minimum period before any options vest (typically 1 year) |
| Vesting schedule | Gradual vesting (e.g., 25% per year over 4 years) |
| Exercise price | Price at which employee can buy shares (can be face value or discounted FMV) |
| Exercise window | Period to exercise after vesting (typically 5-10 years) |
| Post-exit window | Time to exercise after leaving company (typically 30-90 days) |

## Taxation (Two-Stage)

### Stage 1: At Exercise (Perquisite)
- Taxable amount = FMV on exercise date - Exercise price
- Taxed as salary income (perquisite) at slab rate
- TDS deducted by employer
- FMV for listed: Closing price on exercise date
- FMV for unlisted: Merchant banker valuation (Rule 3(8))

### Stage 2: At Sale (Capital Gains)
- Cost basis = FMV on exercise date (not exercise price)
- Listed shares: LTCG 12.5% (>12mo), STCG 20% (<12mo)
- Unlisted shares: LTCG 12.5% (>24mo), STCG at slab rate (<24mo)

### Startup India Benefit (Section 80-IAC eligible startups)
- Deferred taxation: Perquisite tax deferred for up to 5 years from exercise, or until sale/leaving company, whichever is earlier
- Only for eligible startups recognized by DPIIT with turnover <Rs 100Cr

## ESOP Design Best Practices

| Parameter | Common Range | Best Practice |
|-----------|-------------|--------------|
| Pool size | 10-20% of equity | 15% for early-stage startups |
| Vesting period | 3-4 years | 4 years with 1-year cliff |
| Cliff | 12 months | 12 months |
| Exercise price | Face value to FMV | Face value for early employees, FMV for later hires |
| Post-termination exercise | 30-90 days | 90 days minimum, longer is employee-friendly |
| Acceleration | Single/Double trigger | Double trigger on M&A (change of control + termination) |
| Buyback provision | Optional | Annual buyback window for illiquid companies |
| Good leaver / bad leaver | Different treatment | Good leaver keeps vested; bad leaver may forfeit unvested + vested |

## Vesting Schedule Variants

| Type | Year 1 | Year 2 | Year 3 | Year 4 | Notes |
|------|--------|--------|--------|--------|-------|
| Standard (4yr, 1yr cliff) | 25% | 25% | 25% | 25% | Most common in India |
| Back-loaded (Amazon-style) | 5% | 15% | 40% | 40% | Retention-heavy |
| Front-loaded | 40% | 30% | 20% | 10% | Hiring-incentive |
| Monthly (post-cliff) | 1/48 per month | Ongoing | Ongoing | Ongoing | More granular, employee-friendly |
| Milestone-based | On Series A | On revenue target | On profitability | On IPO | Performance-linked |

## ESOP vs Other Equity Instruments

| Instrument | Description | Tax Treatment | Use Case |
|-----------|------------|---------------|----------|
| ESOP | Option to buy shares | Perquisite + capital gains | Most common, flexible |
| ESPP | Purchase plan at discount | Discount taxed as perquisite | Listed companies |
| RSU | Restricted Stock Units | FMV taxed as perquisite at vesting | Global companies, India operations |
| SAR | Stock Appreciation Rights | Cash settled, taxed as salary | No dilution, cash-settled |
| Phantom Stock | Notional equity, cash payout | Taxed as salary/bonus | No real equity, simple |
| Sweat Equity | Shares for IP/know-how | FMV - consideration = perquisite | Founders, technical contributors |

## Key Decisions for Employees

1. **Exercise early or late?** Early = lower perquisite tax (lower FMV) + LTCG clock starts. Late = certainty but higher perquisite tax
2. **Exercise before or after IPO?** Before: Lower FMV, higher risk. After: Higher FMV, higher perquisite tax, but shares are liquid
3. **Sell immediately or hold?** Consider concentration risk — don't hold >20% of net worth in single stock post-listing
4. **Cash to exercise?** Use savings, LAS, or "sell to cover" (sell enough shares to pay exercise cost + tax)

## Regulatory Framework

### Companies Act 2013 (Section 62(1)(b))
- Board and shareholder approval required
- Minimum 1-year gap between grant and vesting
- Lock-in period of 1 year from allotment (can be relaxed)
- ESOP scheme must specify: eligibility, pricing, vesting, exercise, max ESOPs per employee

### SEBI SBEB Regulations (for Listed Companies)
- SEBI (Share Based Employee Benefits and Sweat Equity) Regulations, 2021
- Compensation committee (with independent directors) must approve
- Maximum 1% dilution per year without shareholder approval
- Annual disclosure of ESOP grants, exercises, and outstanding in annual report
