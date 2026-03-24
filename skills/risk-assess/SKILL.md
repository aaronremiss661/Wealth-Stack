---
name: risk-assess
description: Risk assessment — client profiling, portfolio stress testing, Sharpe ratio, VaR, max drawdown. Use when asked about risk, stress test, or portfolio safety.
context: fork
agent: risk-profiler
---

# Risk Assessment

## Step 1: Risk Profile Questionnaire

If no risk profile exists at `~/.wealthstack/risk-profile.json`, run the questionnaire:

1. **Investment horizon?** A) <3yr B) 3-7yr C) 7-15yr D) 15yr+
2. **React to 20% drop?** A) Sell all B) Sell some C) Hold D) Buy more
3. **Income dependency?** A) Primary source B) Some C) None D) Still accumulating
4. **Experience?** A) Beginner B) Intermediate C) Advanced D) Professional
5. **Max tolerable loss?** A) <10% B) 10-20% C) 20-40% D) 40%+

Score: A=1, B=2, C=3, D=4. Total 5-8=Conservative, 9-12=Moderate, 13-16=Growth, 17-20=Aggressive.

Save to `~/.wealthstack/risk-profile.json`.

## Step 2: Portfolio Risk Metrics

Load portfolio from `~/.wealthstack/portfolios/`. Calculate:
- Portfolio Beta (vs Nifty 50)
- Annualized Volatility
- Sharpe Ratio (risk-free = RBI repo rate)
- Sortino Ratio
- Maximum Drawdown (trailing 3yr)
- VaR (95% confidence, 1-month)

## Step 3: Stress Testing

Run through: 2008 Crisis (-60% Nifty), COVID Crash (-38%), 2022 Rate Shock (-17%), Taper Tantrum 2013 (-12%), Demonetization (-6%).

## Step 4: Alignment

Compare portfolio risk vs client profile. Report: ALIGNED / TOO_AGGRESSIVE / TOO_CONSERVATIVE with specific remediation.
