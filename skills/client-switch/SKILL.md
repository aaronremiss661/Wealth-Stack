---
name: client-switch
description: Switch active client context — manage multiple client portfolios with suitability tracking. Use when switching between clients or managing multi-client RIA practice.
context: fork
agent: compliance-checker
allowed-tools: Bash, Read, Write, Grep, Glob
---

# Client Context Manager

Manage multiple client portfolios for RIA practices.

## Step 1: Understand Request

Determine what the user wants:
- **List clients**: Show all clients and active context
- **Switch client**: Change active client for subsequent commands
- **Add client**: Create a new client profile
- **View profile**: Show current client's details

## Step 2: Execute Action

### List Clients
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/client-manager.sh list
```

Present as a formatted table:
| Client | Risk Profile | Status | Created |
|--------|-------------|--------|---------|

### Switch Client
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/client-manager.sh switch <client-id>
```

After switching, confirm:
- Client name and risk profile
- Portfolio summary (if exists)
- Last review date
- Any pending alerts

### Add New Client
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/client-manager.sh add <client-id>
```

Then guide through onboarding:
1. Collect basic details (name, age, income)
2. Update profile JSON
3. Suggest next steps: `/onboarding` for full workflow

### View Profile
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/client-manager.sh profile
```

## Step 3: Suitability Reminder

After switching client context, always:
1. Note the client's risk profile
2. Remind that all recommendations must pass suitability check
3. Offer to run suitability check:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/suitability-check.sh
```

## Step 4: Context Confirmation

Confirm the active client context clearly:
```
ACTIVE CLIENT: {name}
Risk Profile: {profile}
Portfolio: {exists/not imported}
Last Review: {date}
```

All subsequent commands will operate in this client's context.

## Step 5: Next Actions

Based on context, suggest:
- No portfolio → `/portfolio` to import
- No risk profile → `/risk-assess` to assess
- Has portfolio → `/alerts` for health check
- Due for review → `/annual-review`
