---
name: audit
description: Self-audit WealthStack's knowledge for staleness. Checks all agent memories, verifies facts are current, updates or removes stale knowledge.
allowed-tools: Bash, Read, Write, WebSearch, Grep, Glob
---

# /audit — Knowledge Self-Audit

Review all agent memories for accuracy and freshness.

## Process

### Step 1: Inventory all knowledge

```bash
find .claude/agent-memory -name "*.md" -not -name "MEMORY.md" 2>/dev/null | sort
```

For each file, extract:
- Topic
- Date discovered
- Source
- Age (days since discovered)

### Step 2: Flag stale knowledge

| Age | Status | Action |
|-----|--------|--------|
| < 30 days | Fresh | No action |
| 30-90 days | Check | Verify still current |
| 90-180 days | Stale | Must re-verify or remove |
| 180+ days | Expired | Remove unless it's a permanent fact |

**Permanent facts** (never expire):
- Tax rate changes from Finance Acts (until next budget)
- SEBI structural regulations
- Legal precedents (Supreme Court rulings)
- Mathematical formulas

**Fast-expiring facts** (check monthly):
- Interest rates (RBI repo, FD rates, lending rates)
- Market levels and flows (FII/DII)
- Fund NAVs and AUM
- Insurance premium rates

### Step 3: Verify flagged items

For each stale/expired item:
1. Search the web for the latest information
2. Compare with saved knowledge
3. Decide: UPDATE / KEEP / REMOVE

### Step 4: Clean up

- Update files with new information (keep the same filename, update content and date)
- Remove files that are no longer accurate
- Update MEMORY.md index in each agent's directory

### Step 5: Report

```
AUDIT REPORT — {DATE}
══════════════════════════════════════════
Total knowledge files:   XX
Fresh (< 30 days):       XX
Checked (30-90 days):    XX
Stale (90-180 days):     XX
Expired (180+ days):     XX

ACTIONS TAKEN:
  Updated:  XX files
  Removed:  XX files
  Verified: XX files (still current)

DETAILS:
  • [agent]/[file]: [action] — [reason]
  • [agent]/[file]: [action] — [reason]

KNOWLEDGE GAPS:
  • [area where no knowledge exists but should]
══════════════════════════════════════════
```

## Scheduling

Recommend running `/wealthstack:audit` at least:
- Monthly for market-sensitive knowledge (rates, flows, NAVs)
- Quarterly for regulatory knowledge (SEBI, RBI, IRDAI)
- After every Union Budget for tax knowledge
- After every RBI MPC meeting for rate knowledge
