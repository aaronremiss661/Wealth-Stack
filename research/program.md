# WealthStack Research Program

Inspired by [Karpathy's autoresearch](https://github.com/karpathy/autoresearch) — but for wealth management knowledge instead of model weights.

## The Loop

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   User asks question                                │
│        ↓                                            │
│   Agent checks memory (past learnings)              │
│        ↓                                            │
│   Agent researches (web, docs, calculations)        │
│        ↓                                            │
│   Agent responds to user                            │
│        ↓                                            │
│   Agent evaluates: "Did I learn something new?"     │
│        ↓                                            │
│   YES → Save to memory/knowledge base               │
│   NO  → Continue                                    │
│        ↓                                            │
│   Next query is smarter                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## What Gets Saved (and what doesn't)

**SAVE** — new knowledge that improves future responses:
- Tax rule changes (new LTCG rate, new exemption limits)
- Product updates (new PMS launched, AIF regulation changed)
- Market regime shifts (RBI policy change, new SEBI circular)
- Calculation corrections (wrong formula fixed, better methodology found)
- Edge cases discovered (NRI + HUF interaction, PFIC + DTAA conflict)
- User patterns (common questions, frequent misconceptions)

**DON'T SAVE** — ephemeral or personal data:
- User portfolio details
- Specific stock prices (stale within hours)
- Personal financial information
- One-off calculations

## How It Works (Technical)

Every WealthStack agent has `memory: project` in its frontmatter. This gives each agent a persistent knowledge directory at `.claude/agent-memory/<agent-name>/`.

After each significant interaction, agents:

1. **Check**: Read `MEMORY.md` index in their memory directory
2. **Evaluate**: Did this conversation reveal new knowledge?
3. **Save**: Write a dated markdown file with the learning
4. **Index**: Update `MEMORY.md` with a pointer to the new file

Over time, each agent builds a knowledge base specific to its domain.

## Research Modes

### Mode 1: Passive Learning (default)
Agents learn from user conversations. Every real question is a research signal.

### Mode 2: Active Research (triggered by /wealthstack:research)
Run autonomous research loops on specific topics:

```
/wealthstack:research "Latest SEBI circulars affecting PMS investors"
/wealthstack:research "RBI monetary policy impact on debt funds"
/wealthstack:research "Changes in NRI taxation for FY 2026-27"
```

The research agent:
1. Searches the web for latest information
2. Cross-references with existing knowledge base
3. Identifies what's new vs what's already known
4. Saves new findings to the relevant agent's memory
5. Generates a research report

### Mode 3: Self-Audit (triggered by /wealthstack:audit)
Agents review their own knowledge for staleness:

```
/wealthstack:audit
```

This:
1. Reads all saved knowledge files
2. Checks dates — flags anything older than 90 days
3. Web-searches to verify if saved facts are still current
4. Updates or removes stale knowledge
5. Reports what changed

## Knowledge Architecture

```
.claude/agent-memory/
├── tax-strategist/
│   ├── MEMORY.md                    # Index
│   ├── ltcg-rate-change-2025.md     # LTCG went from 10% to 12.5%
│   ├── stcg-rate-change-2025.md     # STCG went from 15% to 20%
│   ├── debt-fund-indexation-removed.md
│   └── huf-ltcg-stacking-confirmed.md
├── nri-advisor/
│   ├── MEMORY.md
│   ├── us-pfic-reporting-update.md
│   ├── uae-dtaa-renegotiation.md
│   └── fbar-threshold-unchanged.md
├── pms-analyst/
│   ├── MEMORY.md
│   ├── sebi-pms-minimum-unchanged.md
│   └── new-pms-disclosure-rules.md
├── market-researcher/
│   ├── MEMORY.md
│   ├── rbi-repo-rate-current.md
│   └── fii-flow-trend-2026.md
└── ...
```

## The Karpathy Parallel

| Autoresearch | WealthStack |
|-------------|------------|
| `train.py` (code being improved) | Agent knowledge base (facts being refined) |
| `program.md` (human guidance) | `research/program.md` (research priorities) |
| val_bpb (metric) | Response accuracy + completeness |
| 5-min training runs | Per-conversation learning cycles |
| GPU experiments | Web research + user interactions |
| One file, one metric | One agent, one domain |

## Research Priorities (update this list)

Current priority topics for active research:

1. **Tax**: FY 2026-27 budget changes, new LTCG/STCG rules, any 80C changes
2. **SEBI**: New PMS/AIF regulations, RIA fee changes, MF expense ratio caps
3. **RBI**: Repo rate trajectory, LRS limit changes, FEMA updates
4. **NRI**: DTAA treaty revisions (India-US, India-UAE), PFIC rule changes
5. **Products**: New AIF launches, PMS track record updates, new SGB issuances
6. **Insurance**: IRDAI regulatory changes, new product types
7. **Estate**: Any changes to succession laws, trust taxation updates
