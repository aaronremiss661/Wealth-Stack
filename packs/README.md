# WealthStack Community Knowledge Packs

Shareable, curated knowledge bundles that extend WealthStack's advisory capabilities.

## What are Packs?

Packs are directories containing markdown knowledge files focused on a specific domain. When installed, their content is loaded into the relevant agent's memory, making WealthStack smarter about that topic.

## Available Packs

| Pack | Description | Agents Enhanced |
|------|-------------|----------------|
| `india-tax-2025` | FY 2025-26 Indian tax rules | tax-strategist, compliance-checker |
| `nri-us-corridor` | US NRI specific rules, DTAA, FBAR/FATCA | nri-advisor, tax-strategist |
| `retirement-fire` | FIRE planning knowledge for India | retirement-specialist, goal-planner |
| `pms-landscape-2025` | Current PMS manager analysis | pms-analyst, hni-advisor |

## Pack Structure

Each pack is a directory containing:
```
packs/<pack-name>/
  index.md          # Manifest: description, version, target agents, file list
  file1.md          # Knowledge file
  file2.md          # Knowledge file
  ...
```

## Installing a Pack

To install a pack, copy its knowledge files into the relevant agent memory directories:

```bash
# Example: Install the india-tax-2025 pack
for file in packs/india-tax-2025/*.md; do
  if [ "$file" != "packs/india-tax-2025/index.md" ]; then
    # Read the target agent from the file's front matter or index.md
    cp "$file" .claude/agent-memory/tax-strategist/
  fi
done
```

Or use the research skill to ingest pack content:
```
/research "ingest pack: india-tax-2025"
```

## Creating a Pack

1. Create a directory under `packs/`
2. Add an `index.md` manifest with:
   - Pack name and description
   - Version
   - Target agents (which agent memories should be updated)
   - File list with descriptions
3. Add knowledge files in the standard format:
   ```markdown
   # Topic Title
   **Last updated**: YYYY-MM-DD
   **Source**: [reference]
   **Target agent**: agent-name

   ## Content
   [Specific, factual, actionable knowledge]
   ```
4. Test by running `/research` after installation

## Contributing Packs

Community members can contribute packs by:
1. Fork the WealthStack repository
2. Create your pack under `packs/`
3. Ensure all facts are sourced and current
4. Submit a pull request

## Versioning

Each pack has a version in its `index.md`. When updating, increment the version and note what changed.
