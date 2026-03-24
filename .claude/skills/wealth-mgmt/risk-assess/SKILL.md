---
name: risk-assess
version: 1.0.0
description: |
  Risk assessment and profiling for wealth management. Client risk questionnaire,
  portfolio risk metrics (Sharpe, Sortino, VaR, max drawdown), stress testing
  against historical scenarios, and risk-return optimization.
  Use when asked to "assess risk", "risk profile", "stress test", or "how risky".
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Agent
  - WebSearch
  - AskUserQuestion
---

# /risk-assess — Risk Assessment & Profiling

Comprehensive risk analysis: client profiling, portfolio risk metrics, and stress testing.

## Phase 1: Risk Profile Questionnaire

If no client risk profile exists, run the questionnaire. Use AskUserQuestion for each:

### Question 1: Investment Horizon
"What is your investment time horizon?"
- A) Less than 3 years (short-term)
- B) 3-7 years (medium-term)
- C) 7-15 years (long-term)
- D) 15+ years (very long-term)

### Question 2: Risk Tolerance
"How would you react if your portfolio dropped 20% in a month?"
- A) Sell everything immediately — I can't handle losses
- B) Sell some holdings to reduce exposure
- C) Hold steady and wait for recovery
- D) Buy more — this is a buying opportunity

### Question 3: Income Needs
"How dependent are you on this portfolio for current income?"
- A) This is my primary income source
- B) I need some income from it, but have other sources
- C) I don't need income — this is purely for growth
- D) I'm still accumulating — adding to the portfolio regularly

### Question 4: Experience
"How would you describe your investment experience?"
- A) Beginner — just getting started
- B) Intermediate — understand stocks, bonds, and funds
- C) Advanced — comfortable with options, alternatives, leverage
- D) Professional — this is my career

### Question 5: Loss Capacity
"What is the maximum portfolio loss you could absorb without affecting your lifestyle?"
- A) Less than 10%
- B) 10-20%
- C) 20-40%
- D) 40%+ — I have a long runway

### Scoring

| Answer | Points |
|--------|--------|
| A | 1 |
| B | 2 |
| C | 3 |
| D | 4 |

Total score → Risk profile:
- **5-8:** Conservative
- **9-12:** Moderate
- **13-16:** Growth
- **17-20:** Aggressive

Save profile to `~/.wealth-mgmt/risk-profile.json`.

## Phase 2: Portfolio Risk Metrics

Load the portfolio (ask user or read from `~/.wealth-mgmt/portfolios/`).

Invoke the **Risk Profiler** subagent via Agent tool:

> You are a Risk Profiler subagent. Calculate the following risk metrics for this portfolio:
>
> **Quantitative Metrics:**
> 1. **Portfolio Beta** — sensitivity to market (benchmark: S&P 500)
> 2. **Standard Deviation** — annualized volatility
> 3. **Sharpe Ratio** — risk-adjusted return (risk-free rate: current 3-month T-bill)
> 4. **Sortino Ratio** — downside risk-adjusted return
> 5. **Maximum Drawdown** — worst peak-to-trough decline
> 6. **Value at Risk (VaR)** — 95% confidence, 1-month horizon
> 7. **Correlation Matrix** — between top holdings
>
> Portfolio: [insert portfolio data]

Present metrics in a dashboard format:

```
RISK DASHBOARD
══════════════════════════════════════════
Portfolio Beta:      1.15  (above market)
Volatility (ann.):   18.3%
Sharpe Ratio:        0.82
Sortino Ratio:       1.05
Max Drawdown:       -24.7%
VaR (95%, 1-mo):    -8.2%
══════════════════════════════════════════
```

## Phase 3: Stress Testing

Run the portfolio through historical crisis scenarios:

| Scenario | Period | S&P 500 Drop | Description |
|----------|--------|-------------|-------------|
| 2008 Financial Crisis | Oct 2007 - Mar 2009 | -56.8% | Banking collapse, credit freeze |
| COVID Crash | Feb 2020 - Mar 2020 | -33.9% | Pandemic shock, rapid recovery |
| Dot-com Bust | Mar 2000 - Oct 2002 | -49.1% | Tech bubble burst |
| 2022 Rate Shock | Jan 2022 - Oct 2022 | -25.4% | Aggressive Fed tightening |
| Black Monday | Oct 1987 | -22.6% | Single-day crash |

For each scenario, estimate the portfolio impact based on holdings' sector exposure and beta.

## Phase 4: Risk-Profile Alignment

Compare the portfolio's actual risk level against the client's stated risk profile:

- **Aligned:** Portfolio risk matches client tolerance. No action needed.
- **Too aggressive:** Portfolio risk exceeds client tolerance. Recommend de-risking.
- **Too conservative:** Portfolio risk is below client tolerance. May be leaving returns on the table.

Present specific recommendations for any misalignment.

## Phase 5: Report

Output a structured risk assessment report and offer:
- A) Save risk report to `~/.wealth-mgmt/reports/`
- B) Run `/rebalance` to align portfolio with risk profile
- C) Run `/client-report` to include risk analysis in client report
