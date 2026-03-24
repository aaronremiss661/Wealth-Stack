---
name: compliance
description: SEBI regulatory compliance checking — suitability analysis, concentration limits, documentation checklist. Use when asked for compliance check or suitability review.
context: fork
agent: compliance-checker
---

# Compliance Check

## Step 1: Scope

Ask the user:
- A) Suitability Review — does portfolio match risk profile?
- B) Concentration Limits — position/sector limit check
- C) Documentation — required disclosures and KYC status
- D) Full Compliance Audit — all checks

## Step 2: Run Checks

Load portfolio from `~/.wealthstack/portfolios/` and risk profile from `~/.wealthstack/risk-profile.json`.

**Suitability**: risk alignment, time horizon, income needs, liquidity, sophistication.
**Concentration**: single stock <10%, single sector <25%, illiquid <15%, alternatives <20%.
**Documentation**: IPS, risk questionnaire, fee disclosure, KYC/CKYC status.

## Step 3: Report

Each check: PASS / WARN / FAIL with specific remediation.

Save to `~/.wealthstack/reports/compliance-{date}.json`.

Note: "This is a compliance screening tool. Consult SEBI-registered compliance professionals for formal regulatory compliance."
