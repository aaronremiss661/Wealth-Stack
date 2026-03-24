---
name: research
description: Autonomous wealth research — searches the web for latest Indian tax, SEBI, RBI, and market updates, then saves findings to agent memory. Run periodically to keep WealthStack current.
allowed-tools: Bash, Read, Write, WebSearch, Grep, Glob
---

# /research — Autonomous Wealth Research

Run an autonomous research loop to update WealthStack's knowledge base.

## Usage

```
/wealthstack:research "topic or area to research"
```

If no topic provided, research all priority areas from `research/program.md`.

## Research Loop

For each topic:

### Step 1: Check existing knowledge
Read the relevant agent's memory directory to see what's already known:
```
ls .claude/agent-memory/<agent-name>/ 2>/dev/null
cat .claude/agent-memory/<agent-name>/MEMORY.md 2>/dev/null
```

### Step 2: Search for updates
Search the web for the latest information on the topic. Focus on:
- SEBI circulars and press releases
- RBI monetary policy statements
- Budget/Finance Act changes
- AMFI mutual fund data
- Insurance (IRDAI) regulatory updates
- Economic Survey data

### Step 3: Compare and identify new knowledge
Compare search results against existing memory:
- Is this information already saved? → Skip
- Is this an update to existing knowledge? → Update the file
- Is this entirely new? → Create new file

### Step 4: Save findings
Write new knowledge to the relevant agent's memory:

```
mkdir -p .claude/agent-memory/<agent-name>
```

File format:
```markdown
# [Topic Title]
**Date discovered**: YYYY-MM-DD
**Source**: [URL or reference]
**Affects**: [which agent/skill this impacts]

## Finding
[The actual knowledge — specific, factual, actionable]

## Impact on advice
[How this changes what WealthStack should tell users]
```

### Step 5: Update MEMORY.md index
Add a one-line pointer to the new file in the agent's `MEMORY.md`.

### Step 6: Report
Output a summary:
```
RESEARCH REPORT — {DATE}
══════════════════════════════════════════
Topics researched:    X
New findings:         X
Updated findings:     X
No change:            X

NEW KNOWLEDGE:
  • [agent]: [one-line summary]
  • [agent]: [one-line summary]

UPDATED:
  • [agent]: [what changed]
══════════════════════════════════════════
```

## Priority Research Areas

Read `research/program.md` for current priority topics.

## Topic-to-Agent Mapping

| Topic Area | Agent |
|-----------|-------|
| Tax rates, rules, deductions | tax-strategist |
| SEBI regulations, PMS/AIF rules | compliance-checker, pms-analyst |
| RBI policy, rates, FEMA | market-researcher, nri-advisor |
| Insurance products, IRDAI | insurance-estate |
| NRI taxation, DTAA | nri-advisor |
| MF expense ratios, NAVs | goal-planner |
| Stock fundamentals, IPOs | market-researcher, fund-manager |
| Lending rates, LAS/LAP | nbfc-lending, credit-debt-advisor |
| ESG regulations, BRSR | esg-planner |
| PE/VC market, AIF launches | private-equity, early-stage-investor |
| Estate law, succession | family-office, insurance-estate |
