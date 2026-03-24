---
name: client-report
version: 1.0.0
description: |
  Generate comprehensive client-facing portfolio reports. Combines portfolio
  analysis, performance, risk metrics, and recommendations into a professional
  HTML report. Use when asked to "generate report", "client report",
  "portfolio summary", or "prepare for client meeting".
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Agent
  - AskUserQuestion
---

# /client-report — Client Report Generator

Produce professional, client-ready portfolio reports combining all analyses.

## Phase 1: Report Configuration

Use AskUserQuestion:

"What type of report would you like to generate?"
- A) Quarterly Review — full portfolio analysis with performance and outlook
- B) Rebalancing Proposal — current state + recommended changes
- C) Tax Planning — year-end tax optimization summary
- D) Financial Plan Update — progress toward goals
- E) Custom — I'll specify the sections

### Client Details

Ask for:
- Client name (or "Personal" for self-directed)
- Report period (e.g., "Q1 2026" or "2025 Year-End")
- Any specific topics to highlight

## Phase 2: Data Collection

Gather all available data from `~/.wealth-mgmt/`:

```bash
ls ~/.wealth-mgmt/portfolios/ 2>/dev/null
ls ~/.wealth-mgmt/reports/ 2>/dev/null
cat ~/.wealth-mgmt/risk-profile.json 2>/dev/null
cat ~/.wealth-mgmt/target-allocation.json 2>/dev/null
```

If data is missing, run the relevant skills to generate it:
- No portfolio → suggest `/portfolio`
- No risk profile → suggest `/risk-assess`
- No target allocation → suggest `/rebalance`

## Phase 3: Report Generation

Generate an HTML report using the template. The report includes these sections:

### Section 1: Executive Summary
- Portfolio value and period return
- Key highlights (top performers, notable changes)
- Recommended actions (1-3 bullet points)

### Section 2: Portfolio Overview
- Total value, cash position, invested amount
- Asset allocation pie chart (rendered as an HTML/CSS chart)
- Holdings table with current values and weights

### Section 3: Performance
- Period return vs benchmark (S&P 500, 60/40, or custom)
- Attribution: which holdings contributed most to gains/losses
- Historical performance table (1mo, 3mo, YTD, 1yr, 3yr)

### Section 4: Risk Analysis
- Risk dashboard metrics (beta, Sharpe, volatility)
- Risk profile alignment status
- Stress test summary

### Section 5: Recommendations
- Rebalancing needs (if drift exceeds threshold)
- Tax optimization opportunities (if applicable)
- Holdings to review (concentration, underperformance)

### Section 6: Market Outlook
- Brief macro summary
- Sector commentary relevant to the portfolio

Write the report to `~/.wealth-mgmt/reports/`:

```bash
mkdir -p ~/.wealth-mgmt/reports
REPORT_FILE=~/.wealth-mgmt/reports/client-report-$(date +%Y-%m-%d).html
```

## Phase 4: Report Template

Generate the HTML report with professional styling:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Portfolio Report — {CLIENT_NAME} — {PERIOD}</title>
  <style>
    body { font-family: 'Helvetica Neue', Arial, sans-serif; max-width: 900px; margin: 0 auto; padding: 40px; color: #1a1a2e; }
    h1 { color: #16213e; border-bottom: 3px solid #0f3460; padding-bottom: 12px; }
    h2 { color: #0f3460; margin-top: 40px; }
    table { width: 100%; border-collapse: collapse; margin: 20px 0; }
    th { background: #0f3460; color: white; padding: 12px; text-align: left; }
    td { padding: 10px 12px; border-bottom: 1px solid #e0e0e0; }
    tr:hover { background: #f5f5f5; }
    .metric-card { display: inline-block; background: #f8f9fa; border-radius: 8px; padding: 20px; margin: 8px; min-width: 150px; text-align: center; }
    .metric-value { font-size: 24px; font-weight: bold; color: #0f3460; }
    .metric-label { font-size: 12px; color: #666; text-transform: uppercase; }
    .positive { color: #27ae60; }
    .negative { color: #e74c3c; }
    .disclaimer { font-size: 11px; color: #999; margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px; }
  </style>
</head>
<body>
  <!-- Populate with actual data -->
</body>
</html>
```

## Phase 5: Delivery

Save the report and present the user with options:

- A) Open report in browser: `open <report-path>`
- B) Save and continue — report saved to `~/.wealth-mgmt/reports/`
- C) Regenerate with different sections
- D) Export data as JSON for external tools
