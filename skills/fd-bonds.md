
# /fd-bonds — Fixed Deposits & Bond Analysis

Compare FDs, evaluate bonds, and build a fixed-income portfolio.

## Phase 1: What Are You Looking For?

Ask the user:

"What fixed-income instrument are you interested in?"
- A) Fixed Deposits — compare rates across banks
- B) Corporate Bonds / NCDs — evaluate yield and credit risk
- C) Sovereign Gold Bonds (SGBs) — track and plan purchases
- D) Government Securities (G-Sec / SDL) — risk-free investing
- E) Tax-Free Bonds — for high tax bracket investors
- F) Debt Ladder — build a maturity-matched fixed income portfolio
- G) FD vs Debt MF — which is better after tax?

## Phase 2: FD Rate Comparison (Option A)

```bash
bash commands/fd-compare.sh --tenure <years>
```

Or use web search for latest rates.

```
FD RATES COMPARISON — 1 YEAR TENURE
══════════════════════════════════════════════════════════════
Bank/NBFC              General    Senior(60+)   Min Amount
──────────────────────────────────────────────────────────────
SBI                    6.80%      7.30%         Rs 1,000
HDFC Bank              7.00%      7.50%         Rs 5,000
ICICI Bank             7.00%      7.50%         Rs 10,000
Kotak Mahindra         7.10%      7.60%         Rs 5,000
Axis Bank              6.90%      7.40%         Rs 5,000
IndusInd Bank          7.50%      8.00%         Rs 10,000
Bajaj Finance          8.05%      8.30%         Rs 15,000
Shriram Finance        8.54%      9.04%         Rs 5,000
Mahindra Finance       8.05%      8.30%         Rs 5,000
PNB Housing Finance    7.90%      8.15%         Rs 10,000
──────────────────────────────────────────────────────────────
POST-TAX COMPARISON (30% bracket):
  SBI FD 6.80%        → 4.76% after tax
  Bajaj Finance 8.05% → 5.64% after tax
  Shriram 8.54%       → 5.98% after tax
  Debt MF (3yr hold)  → ~5.5-6.5% post-tax (slab rate)
──────────────────────────────────────────────────────────────
⚠ NBFC FDs (Bajaj, Shriram) are NOT covered by DICGC insurance.
  Bank FDs insured up to Rs 5L per depositor per bank.
══════════════════════════════════════════════════════════════
```

## Phase 3: Corporate Bond / NCD Evaluation (Option B)

### NCD Due Diligence

| Check | Criteria | Why |
|-------|----------|-----|
| Credit rating | AA- or above (CRISIL/ICRA/CARE) | Lower default risk |
| Issuer track record | Listed company, profitable | Can service debt |
| Secured vs unsecured | Prefer secured | Asset backing in default |
| Yield vs FD spread | At least 1-2% above FD | Premium for risk |
| Liquidity | Listed on NSE/BSE | Can sell before maturity |
| Coupon frequency | Monthly/quarterly/annual | Cash flow needs |

### Sample NCD Analysis

```
NCD EVALUATION — [ISSUER]
══════════════════════════════════════════
Issuer:          [Company Name]
Rating:          AA+ (CRISIL)
Type:            Secured
Tenure:          3 years
Coupon:          9.2% annual
Face Value:      Rs 1,000
Current Price:   Rs 1,015 (premium)
YTM:             8.85%

COMPARISON:
  FD (3yr):      7.0% → 4.9% post-tax
  This NCD:      9.2% → 6.4% post-tax
  Spread:        +2.2% pre-tax, +1.5% post-tax

RISK ASSESSMENT:
  ✅ AA+ rated — investment grade
  ✅ Secured against assets
  ⚠ Taxed at slab rate (no indexation)
  ⚠ Liquidity risk if selling before maturity
══════════════════════════════════════════
```

## Phase 4: Sovereign Gold Bond (Option C)

```
SOVEREIGN GOLD BOND TRACKER
══════════════════════════════════════════
YOUR SGBs:
  Series        Purchase   Price      Current    Return   Maturity
  SGB 2020-21   Oct 2020   Rs 5,051   Rs 7,200   +42.5%   Oct 2028
  SGB 2021-22   Mar 2022   Rs 4,852   Rs 7,200   +48.4%   Mar 2030
  + 2.5% annual coupon (paid semi-annually)

UPCOMING TRANCHES:
  Check RBI website for next SGB issuance dates
  Apply via: Bank, post office, demat, or Stock Holding Corp

KEY BENEFITS:
  ✅ Tax-free capital gains if held to maturity (8 years)
  ✅ 2.5% annual coupon (taxable at slab rate)
  ✅ Sovereign guarantee (zero default risk)
  ✅ Can exit after 5 years (on coupon dates)
  ✅ Can trade on NSE (usually at slight premium/discount)

⚠ NRIs cannot buy SGBs
⚠ Max limit: 4 kg/individual, 20 kg/trust per FY
══════════════════════════════════════════
```

## Phase 5: Debt Ladder (Option F)

Build a maturity-matched fixed income portfolio:

```
DEBT LADDER — Rs 50L CORPUS
══════════════════════════════════════════
Maturity    Instrument              Amount    Yield
──────────────────────────────────────────────────
< 1 year    Liquid MF / Overnight   Rs 10L    6.5%
1-2 years   Short duration debt MF  Rs 10L    7.2%
2-3 years   Corporate bond MF       Rs 10L    7.5%
3-5 years   SGB + NCD               Rs 10L    8.5%
5+ years    Gilt fund / Tax-free    Rs 10L    7.8%
──────────────────────────────────────────────────
BLENDED YIELD:                                7.5%
POST-TAX (30% bracket):                       5.3%
══════════════════════════════════════════

BENEFITS:
  • Maturity every 1-2 years → liquidity
  • Reinvest at new rates → interest rate hedge
  • Mix of instruments → diversification
══════════════════════════════════════════
```

## Phase 6: FD vs Debt MF Comparison (Option G)

```
FD vs DEBT MF — POST-TAX COMPARISON
══════════════════════════════════════════
                    FD 7.0%     Debt MF 7.0%
──────────────────────────────────────────────
Pre-tax return      7.0%        7.0%
Tax treatment       Slab rate   Slab rate
                    (yearly)    (on redemption)

AT 30% TAX BRACKET:
  1 year hold:      4.90%       4.90%  (same)
  3 year hold:      4.90%       ~5.1%  (tax deferral benefit)
  5 year hold:      4.90%       ~5.2%  (compounding on gross)

VERDICT:
  Short term (< 1yr): FD wins (simpler, insured)
  Long term (3yr+):   Debt MF wins slightly (tax deferral)
  High bracket:       Debt MF edge is larger

  NOTE: Post-2023, debt MFs have NO indexation benefit.
  Both taxed at slab rate. MF advantage is only tax deferral.
══════════════════════════════════════════
```

Save to `~/.wealth-mgmt/reports/fd-bonds-<date>.json`.
