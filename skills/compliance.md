
# /compliance — Regulatory Compliance Check

Review portfolio and advisory practices against regulatory guidelines and best practices.

## Phase 1: Compliance Scope

Ask the user:

"What compliance check would you like to run?"
- A) Suitability Review — does the portfolio match the client's risk profile?
- B) Concentration Limits — check against position/sector limits
- C) Disclosure Review — review required disclosures and documentation
- D) Full Compliance Audit — run all checks

## Phase 2: Suitability Analysis

Delegate to the **Compliance Checker** subagent:

> You are a Compliance Checker subagent. Perform a suitability review.
>
> Check the portfolio against the client's risk profile for:
> 1. **Risk alignment** — does portfolio risk match stated risk tolerance?
> 2. **Time horizon match** — are holdings appropriate for the investment horizon?
> 3. **Income needs** — does the portfolio generate required income?
> 4. **Liquidity** — are holdings sufficiently liquid for the client's needs?
> 5. **Sophistication** — are complex instruments appropriate for the client's experience?
>
> Client risk profile: [from ~/.wealth-mgmt/risk-profile.json]
> Portfolio: [from ~/.wealth-mgmt/portfolios/]

### Suitability Flags

| Check | Status | Finding |
|-------|--------|---------|
| Risk Alignment | PASS/WARN/FAIL | Details |
| Time Horizon | PASS/WARN/FAIL | Details |
| Income Needs | PASS/WARN/FAIL | Details |
| Liquidity | PASS/WARN/FAIL | Details |
| Sophistication | PASS/WARN/FAIL | Details |

## Phase 3: Concentration Limits

Check against standard concentration guidelines:

| Rule | Limit | Current | Status |
|------|-------|---------|--------|
| Single stock | < 10% of portfolio | X% | PASS/FAIL |
| Single sector | < 25% of portfolio | X% | PASS/FAIL |
| Single issuer (bonds) | < 5% of portfolio | X% | PASS/FAIL |
| Illiquid holdings | < 15% of portfolio | X% | PASS/FAIL |
| Alternative investments | < 20% of portfolio | X% | PASS/FAIL |
| Cash drag | > 2% in cash | X% | PASS/WARN |

Flag any violations with specific remediation steps.

## Phase 4: Disclosure Checklist

Review required documentation:

- [ ] Investment Policy Statement (IPS) on file
- [ ] Risk tolerance questionnaire completed and dated
- [ ] Fee disclosure provided
- [ ] Account agreements signed
- [ ] Beneficiary designations current
- [ ] Annual review documented
- [ ] Material changes communicated

## Phase 5: Compliance Report

```
COMPLIANCE REPORT
══════════════════════════════════════════
Date:          {DATE}
Client:        {CLIENT_NAME}
Overall:       PASS / PASS WITH WARNINGS / FAIL

Suitability:   [STATUS] — [summary]
Concentration:  [STATUS] — [summary]
Documentation:  [STATUS] — [summary]

FINDINGS:
  [numbered list of issues found]

REQUIRED ACTIONS:
  [numbered list of actions to take]

NEXT REVIEW:   [suggested date]
══════════════════════════════════════════
```

Save to `~/.wealth-mgmt/reports/compliance-<date>.json`.

## Important Note

> This tool assists with compliance tracking but does not replace qualified
> compliance oversight. Regulatory requirements vary by jurisdiction, firm type,
> and client classification. Always consult your compliance department or
> qualified compliance professional.
