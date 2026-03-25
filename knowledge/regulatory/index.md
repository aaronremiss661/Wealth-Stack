# Regulatory Knowledge Graph — Master Index

> Layer 5 of Wealth-Stack: Comprehensive Indian regulatory reference for wealth advisory.
> Last Updated: 2026-03-25 | Applicable FY: 2025-26 (AY 2026-27)

---

## Table of Contents

| # | File | Description |
|---|------|-------------|
| 1 | [sebi-rules.md](./sebi-rules.md) | SEBI regulations — RIA, PMS, AIF, Mutual Funds, Insider Trading |
| 2 | [income-tax-rules.md](./income-tax-rules.md) | Income Tax Act — Capital Gains, Deductions (80C/80D/80CCD), TDS, Regime Choice |
| 3 | [fema-rules.md](./fema-rules.md) | FEMA/RBI — NRI investments, LRS, NRE/NRO accounts, DTAA, Repatriation |
| 4 | [rbi-rules.md](./rbi-rules.md) | RBI — Monetary policy, MPC, DICGC, NBFC, Digital Lending, Gold Loans |
| 5 | [interactions.md](./interactions.md) | Cross-rule interactions — NRI+LTCG+DTAA, PMS+Tax, NPS+Annuity, SGB+LTCG, etc. |

---

## Quick Reference — Key Numbers (FY 2025-26)

### Tax Rates & Exemptions

| Parameter | Value | Reference |
|-----------|-------|-----------|
| Equity LTCG rate | 12.5% above Rs 1.25L exemption | income-tax-rules.md |
| Equity STCG rate | 20% | income-tax-rules.md |
| Debt MF gains (any holding) | Slab rate (no LTCG benefit post-2023) | income-tax-rules.md |
| Property LTCG | 12.5% without indexation (post July 2024) | income-tax-rules.md |
| Section 80C limit | Rs 1,50,000 | income-tax-rules.md |
| Section 80D (self, <60) | Rs 25,000 | income-tax-rules.md |
| Section 80D (senior citizen) | Rs 50,000 | income-tax-rules.md |
| NPS 80CCD(1B) additional | Rs 50,000 (old regime only) | income-tax-rules.md |
| STT — delivery (buy+sell) | 0.1% | income-tax-rules.md |
| STT — options sell | 0.0625% | income-tax-rules.md |

### SEBI Thresholds

| Parameter | Value | Reference |
|-----------|-------|-----------|
| RIA fee cap (individual, flat) | Rs 75,000/yr | sebi-rules.md |
| RIA fee cap (non-individual, flat) | Rs 1,50,000/yr | sebi-rules.md |
| RIA AUM-based fee cap | 2.5% p.a. | sebi-rules.md |
| PMS minimum investment | Rs 50,00,000 | sebi-rules.md |
| PMS minimum net worth | Rs 5,00,00,000 | sebi-rules.md |
| AIF minimum investment | Rs 1,00,00,000 | sebi-rules.md |
| AIF minimum corpus | Rs 20,00,00,000 | sebi-rules.md |
| MF equity direct expense ratio cap | ~1.05% | sebi-rules.md |
| MF equity regular expense ratio cap | ~2.25% | sebi-rules.md |

### FEMA & RBI

| Parameter | Value | Reference |
|-----------|-------|-----------|
| LRS annual limit | USD 250,000 | fema-rules.md |
| NRO repatriation limit | USD 1,000,000 per FY | fema-rules.md |
| Repo rate | 6.25% | rbi-rules.md |
| SDF rate | 6.00% | rbi-rules.md |
| MSF rate | 6.50% | rbi-rules.md |
| CRR | 4% | rbi-rules.md |
| SLR | 18% | rbi-rules.md |
| DICGC deposit insurance | Rs 5,00,000 per depositor per bank | rbi-rules.md |

---

## Cross-Reference Matrix

This matrix shows which regulatory domains interact. See [interactions.md](./interactions.md) for detailed analysis of each intersection.

| Interaction | SEBI | Income Tax | FEMA/RBI | RBI Banking |
|-------------|:----:|:----------:|:--------:|:-----------:|
| NRI equity investment | PIS route (SEBI) | LTCG 12.5% + TDS | NRE/NRO repatriation | - |
| PMS taxation | PMS regulations | Individual txn tax drag | NRI PMS via NRE/NRO | - |
| ELSS investment | MF regulations | 80C deduction + LTCG | - | - |
| NPS withdrawal | - | 80CCD + annuity tax | NRI NPS repatriation | - |
| SGB maturity | Listed on exchange | LTCG exempt at maturity | - | RBI issuance |
| Foreign MF via LRS | - | Slab rate taxation | LRS $250K limit | - |
| HUF + PMS | PMS 50L min | Separate entity tax | - | - |
| FD interest | - | TDS 10%/15G/15H | NRO FD taxable 30% | DICGC 5L cover |
| Insurance proceeds | IRDAI regulated | 10(10D) exemption | NRI policy rules | - |
| Digital lending | - | Interest deduction | - | LSP/DLA framework |
| AIF investment | Cat I/II/III rules | Pass-through (Cat I/II) | FPI route for NRI | - |
| Gold loans | - | Interest deduction | - | LTV 75% cap |

---

## How to Use This Knowledge Graph

1. **Single-domain query**: Go directly to the relevant file (e.g., `sebi-rules.md` for RIA fee structure).
2. **Multi-domain query**: Start with `interactions.md` to understand how rules combine.
3. **Quick number lookup**: Use the Quick Reference tables above.
4. **NRI-specific**: Start with `fema-rules.md`, then cross-reference `interactions.md` for tax treaty implications.
5. **Product comparison**: Cross-reference `sebi-rules.md` (product rules) with `income-tax-rules.md` (tax efficiency).

---

## Maintenance Notes

- Tax rates and slabs: Update after Union Budget (typically February each year).
- RBI rates: Update after each MPC meeting (6 times/year, bi-monthly).
- SEBI circulars: Monitor SEBI website for amendments to RIA/PMS/AIF/MF regulations.
- FEMA: Monitor RBI Master Directions for NRI investment rule changes.
- DTAA: Treaty amendments are infrequent but must be tracked per country.
