# Risk Metrics Guide — Interpretation & Application

## Sharpe Ratio

**Formula**: (Portfolio Return - Risk-Free Rate) / Portfolio Std Deviation

| Sharpe Ratio | Interpretation |
|-------------|----------------|
| < 0 | Negative — worse than risk-free (bad) |
| 0 - 0.5 | Poor — barely compensating for risk |
| 0.5 - 1.0 | Below average — acceptable for some strategies |
| 1.0 - 1.5 | Good — solid risk-adjusted returns |
| 1.5 - 2.0 | Very good — strong risk management |
| > 2.0 | Excellent — exceptional (verify sustainability) |
| > 3.0 | Suspicious — check for data issues or survivorship bias |

- Risk-free rate for India: Use 91-day T-Bill rate (~6.5-7.0% as of FY 2025-26)
- Calculate on 3-year and 5-year rolling basis for meaningful comparison
- Compare Sharpe ratios within same category (equity vs equity, not equity vs debt)

## Sortino Ratio

**Formula**: (Portfolio Return - Risk-Free Rate) / Downside Deviation

- Better than Sharpe for asymmetric return distributions
- Only penalizes downside volatility (not upside)
- Useful for funds with concentrated portfolios or options strategies

| Sortino Ratio | Interpretation |
|--------------|----------------|
| < 1.0 | Poor downside management |
| 1.0 - 2.0 | Good |
| > 2.0 | Excellent downside protection |

## Beta (Systematic Risk)

**Formula**: Covariance(Portfolio, Benchmark) / Variance(Benchmark)

| Beta | Interpretation | Suitable For |
|------|----------------|-------------|
| < 0.5 | Very low market sensitivity | Ultra-conservative |
| 0.5 - 0.8 | Low-to-moderate sensitivity | Conservative |
| 0.8 - 1.0 | Slightly less volatile than market | Moderate |
| 1.0 | Moves exactly with market | Index investors |
| 1.0 - 1.3 | Slightly more volatile | Aggressive |
| > 1.3 | High volatility vs market | Very aggressive / momentum |

- Mid/small cap funds typically have beta 1.1-1.5 vs Nifty 50
- Defensive sectors (pharma, FMCG): beta 0.5-0.8
- Cyclical sectors (metals, real estate): beta 1.2-1.8

## Alpha (Excess Return)

**Formula**: Portfolio Return - [Risk-Free + Beta * (Benchmark Return - Risk-Free)]

- Positive alpha = outperformance after adjusting for risk
- Benchmark: Must use appropriate index (not Nifty 50 for a small cap fund)
- Meaningful only over 3+ year periods
- Average alpha of active large cap funds vs Nifty 50: 0-1% (most underperform)
- Average alpha of active mid/small cap funds: 1-3% (more scope for alpha)

## Value at Risk (VaR)

**Interpretation**: Maximum expected loss over a given period at a confidence level.

| Confidence Level | Meaning |
|-----------------|---------|
| 95% VaR of 5% | 95% chance daily loss will NOT exceed 5% |
| 99% VaR of 8% | 99% chance daily loss will NOT exceed 8% |

### Typical VaR Numbers (Daily, 95% Confidence)

| Portfolio Type | Daily VaR (95%) | Monthly VaR (95%) |
|---------------|----------------|-------------------|
| Conservative (70% debt) | 0.3-0.5% | 1.5-2.5% |
| Moderate (50% equity) | 0.8-1.2% | 4-6% |
| Aggressive (80% equity) | 1.2-2.0% | 6-10% |
| Pure equity (Nifty 50) | 1.5-2.5% | 7-12% |
| Small cap heavy | 2.0-3.5% | 10-16% |

### VaR Calculation Methods
1. **Historical VaR**: Based on actual past returns (last 1-3 years)
2. **Parametric VaR**: Assumes normal distribution (fast but less accurate for tails)
3. **Monte Carlo VaR**: Simulation-based (most robust for complex portfolios)

## Standard Deviation Benchmarks

| Asset / Index | Annual Std Dev (3Y) |
|--------------|-------------------|
| Nifty 50 | 13-16% |
| Nifty Midcap 150 | 16-20% |
| Nifty Smallcap 250 | 20-28% |
| Nifty Bank | 16-22% |
| 10Y G-Sec | 3-5% |
| Gold (INR) | 12-15% |
| Liquid Fund | 0.3-0.5% |

## Information Ratio

**Formula**: (Portfolio Return - Benchmark Return) / Tracking Error

- Measures consistency of outperformance
- > 0.5: Good active manager
- > 1.0: Excellent
- Relevant for evaluating PMS and active MF managers
