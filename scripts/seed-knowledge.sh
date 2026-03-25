#!/bin/bash
# Seed Knowledge Generator — Creates agent memory directory structure
# Usage: seed-knowledge.sh [--check | --list | --create]
# Verifies all 26 agents have memory directories and seed knowledge files

AGENT_MEMORY_DIR=".claude/agent-memory"
AGENTS_DIR="agents"

ACTION=${1:-check}

# All expected agents (derived from agents/ directory)
get_agents() {
  ls "$AGENTS_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md | sort
}

case "$ACTION" in
  --check|check)
    echo "=== WealthStack Agent Knowledge Status ==="
    echo ""
    total=0
    seeded=0
    empty=0
    missing=0

    for agent in $(get_agents); do
      total=$((total + 1))
      dir="$AGENT_MEMORY_DIR/$agent"
      if [ -d "$dir" ]; then
        count=$(ls -1 "$dir" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$count" -gt 1 ]; then
          echo "  ✓ $agent ($count files)"
          seeded=$((seeded + 1))
        else
          echo "  ⚠ $agent ($count files — needs seed knowledge)"
          empty=$((empty + 1))
        fi
      else
        echo "  ✗ $agent (no memory directory)"
        missing=$((missing + 1))
      fi
    done

    echo ""
    echo "Summary: $total agents | $seeded seeded | $empty empty | $missing missing"
    echo ""
    if [ $missing -gt 0 ] || [ $empty -gt 0 ]; then
      echo "Run: seed-knowledge.sh --create to fix"
    else
      echo "All agents have seed knowledge ✓"
    fi
    ;;

  --list|list)
    echo "=== Expected Seed Knowledge Per Agent ==="
    echo ""
    echo "tax-strategist: ltcg-stcg-rates-2025.md, deductions-80c-80d-2025.md, new-vs-old-regime-2025.md"
    echo "compliance-checker: sebi-ria-regulations.md, pms-aif-rules.md, concentration-limits.md"
    echo "nri-advisor: dtaa-treaty-rates.md, fema-lrs-rules.md, nre-nro-account-rules.md"
    echo "fund-manager: mf-categories-2025.md, expense-ratio-benchmarks.md"
    echo "portfolio-analyzer: allocation-frameworks.md, sector-classification.md, concentration-thresholds.md"
    echo "risk-profiler: risk-metrics-guide.md, historical-drawdowns.md"
    echo "goal-planner: goal-frameworks.md, return-assumptions.md"
    echo "insurance-estate: insurance-benchmarks.md, hlv-calculation-guide.md, estate-planning-basics.md"
    echo "hni-advisor: hni-thresholds.md, pms-selection-criteria.md, concentrated-stock-strategies.md"
    echo "market-researcher: key-indices.md, market-calendar.md"
    echo "pms-analyst: top-pms-managers.md, fee-structures.md, aif-categories.md"
    echo "family-office: family-office-structures.md, trust-types.md, succession-planning.md"
    echo "retirement-specialist: nps-rules.md, retirement-withdrawal-strategies.md"
    echo "asset-allocator: allocation-strategies.md, rebalancing-rules.md"
    echo "credit-debt-advisor: loan-rate-benchmarks.md, debt-management-strategies.md"
    echo "esg-planner: brsr-framework.md, esg-fund-landscape.md"
    echo "private-equity: pe-vc-landscape.md, aif-regulations.md"
    echo "early-stage-investor: angel-tax-rules.md, esop-taxation.md"
    echo "corporate-treasury: treasury-instruments.md, liquid-fund-selection.md"
    echo "nbfc-lending: nbfc-categories.md, las-lap-rules.md"
    echo "investment-counsellor: behavioral-biases.md, client-communication.md"
    echo "deck-creator: report-templates.md, compliance-disclaimers.md"
    echo "liquidity-event-planner: liquidity-event-tax.md, lock-in-strategies.md"
    echo "startup-equity-advisor: esop-structures.md, startup-valuation.md"
    echo "capital-markets-research: derivatives-basics.md, index-methodology.md"
    echo "alternative-investments: reit-invit-guide.md, gold-investment-options.md, international-investing.md"
    ;;

  --create|create)
    echo "Creating agent memory directories..."
    for agent in $(get_agents); do
      dir="$AGENT_MEMORY_DIR/$agent"
      if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "  Created: $dir"
      fi
      if [ ! -f "$dir/MEMORY.md" ]; then
        echo "# ${agent} Agent — Memory Index" > "$dir/MEMORY.md"
        echo "" >> "$dir/MEMORY.md"
        echo "## Seed Knowledge" >> "$dir/MEMORY.md"
        echo "Run /research to populate with latest knowledge." >> "$dir/MEMORY.md"
        echo "  Created: $dir/MEMORY.md"
      fi
    done
    echo ""
    echo "Directories created. Run /research to populate seed knowledge."
    ;;

  *)
    echo "Usage: seed-knowledge.sh [--check | --list | --create]"
    echo "  --check  : Verify all agents have memory (default)"
    echo "  --list   : Show expected seed files per agent"
    echo "  --create : Create missing directories and MEMORY.md files"
    ;;
esac
