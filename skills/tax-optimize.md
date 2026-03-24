
# /tax-optimize — Tax Optimization

Find tax savings opportunities: tax-loss harvesting, gain deferral, lot optimization, and wash sale avoidance.

## Phase 1: Portfolio & Tax Context

Load the portfolio from `~/.wealth-mgmt/portfolios/` or ask the user to provide one.

Gather tax context by asking:

### Question 1: Tax Filing Status
"What is your tax filing status?"
- A) Single
- B) Married Filing Jointly
- C) Married Filing Separately
- D) Head of Household

### Question 2: Tax Bracket
"What is your approximate federal marginal tax rate?"
- A) 10-12% (taxable income under ~$45K single / ~$90K joint)
- B) 22-24% (taxable income ~$45K-$190K single / ~$90K-$380K joint)
- C) 32-35% (taxable income ~$190K-$580K single / ~$380K-$730K joint)
- D) 37% (taxable income above ~$580K single / ~$730K joint)

### Question 3: Realized Gains This Year
"Have you realized any capital gains this year already?"
- A) No realized gains yet
- B) Yes — short-term gains (held < 1 year)
- C) Yes — long-term gains (held > 1 year)
- D) Yes — both short-term and long-term gains

If yes, ask for approximate amounts.

## Phase 2: Tax-Loss Harvesting Analysis

Delegate to the **Tax Strategist** subagent:

> You are a Tax Strategist subagent. Analyze this portfolio for tax-loss harvesting opportunities.
>
> For each holding with an unrealized loss:
> 1. Current unrealized loss amount
> 2. Holding period (short-term vs long-term)
> 3. Tax savings estimate at the client's marginal rate
> 4. Suggested replacement security (similar exposure, avoids wash sale)
> 5. 30-day wash sale window status
>
> Portfolio: [insert portfolio data with cost basis]
> Tax bracket: [from questionnaire]
> Realized gains this year: [from questionnaire]

Present findings in a table:

| Holding | Unrealized Loss | Type | Est. Tax Savings | Replacement | Wash Sale Risk |
|---------|----------------|------|-----------------|-------------|---------------|

## Phase 3: Gain Deferral Analysis

Identify holdings with large unrealized gains and evaluate:

- **Short-term vs long-term:** Holdings approaching the 1-year mark — should the client wait?
- **Gain netting:** Can existing losses offset gains if the client needs to sell?
- **Charitable giving:** Would donating appreciated shares be more tax-efficient than selling?

## Phase 4: Lot-Level Optimization

For holdings with multiple tax lots (bought at different times/prices):

- **Specific lot identification:** Which lots to sell first for best tax outcome
- **HIFO vs FIFO vs specific ID:** Compare methods
- **Short-term/long-term splitting:** Sell long-term lots to get preferential rate

## Phase 5: Wash Sale Detection

Check all proposed trades against wash sale rules:

- **30-day window:** Flag any repurchase of substantially identical securities within 30 days before or after a loss sale
- **Cross-account:** Remind client that wash sale rules apply across ALL accounts (IRA, 401k, spouse accounts)
- **Substantially identical:** ETFs tracking same index may trigger wash sale rules

## Phase 6: Tax Optimization Summary

```
TAX OPTIMIZATION SUMMARY
══════════════════════════════════════════
Total Harvestable Losses:     $XX,XXX
  Short-term losses:          $XX,XXX
  Long-term losses:           $XX,XXX
Estimated Tax Savings:        $X,XXX
Gains That Can Be Offset:     $XX,XXX
Net Tax Position After Harvest: [improved/neutral]
══════════════════════════════════════════
```

Offer next steps:
- A) Generate specific trade list for tax-loss harvesting
- B) Run `/rebalance` to combine tax optimization with rebalancing
- C) Save tax analysis to `~/.wealth-mgmt/reports/`
- D) Run `/client-report` to include in client report

## Important Disclaimers

Always include:
> This analysis is for informational purposes. Tax situations are individual —
> consult a qualified tax advisor before executing any tax strategy. Tax laws
> change frequently and this tool uses general rules that may not apply to
> your specific situation.
