#!/usr/bin/env bash
# wealth-config.sh — Manage wealth management plugin configuration
# Usage:
#   wealth-config.sh get <key>
#   wealth-config.sh set <key> <value>
#   wealth-config.sh list
#   wealth-config.sh init

set -euo pipefail

CONFIG_DIR="$HOME/.wealth-mgmt"
CONFIG_FILE="$CONFIG_DIR/config.json"

ensure_config() {
  mkdir -p "$CONFIG_DIR"
  mkdir -p "$CONFIG_DIR/portfolios"
  mkdir -p "$CONFIG_DIR/reports"
  mkdir -p "$CONFIG_DIR/cache"
  mkdir -p "$CONFIG_DIR/plans"
  if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" << 'EOF'
{
  "benchmark": "^NSEI",
  "currency": "INR",
  "risk_free_rate": 0.065,
  "rebalance_threshold": 5,
  "concentration_limit_single": 10,
  "concentration_limit_sector": 25,
  "tax_bracket": "new_regime",
  "ltcg_rate": 0.125,
  "stcg_rate": 0.20,
  "ltcg_exemption": 125000,
  "default_exchange": "NSE",
  "report_format": "html",
  "created": ""
}
EOF
    # Set created timestamp
    python3 -c "
import json
from datetime import datetime, timezone
with open('$CONFIG_FILE', 'r') as f:
    cfg = json.load(f)
cfg['created'] = datetime.now(timezone.utc).isoformat()
with open('$CONFIG_FILE', 'w') as f:
    json.dump(cfg, f, indent=2)
"
    echo "Initialized wealth-mgmt config at $CONFIG_FILE"
  fi
}

cmd_get() {
  ensure_config
  local key="$1"
  python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    cfg = json.load(f)
val = cfg.get('$key')
if val is not None:
    print(val)
else:
    print('KEY_NOT_FOUND')
"
}

cmd_set() {
  ensure_config
  local key="$1"
  local value="$2"
  python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    cfg = json.load(f)
# Try to parse as number or boolean
val = '$value'
if val.lower() == 'true':
    val = True
elif val.lower() == 'false':
    val = False
else:
    try:
        val = float(val)
        if val == int(val):
            val = int(val)
    except ValueError:
        pass
cfg['$key'] = val
with open('$CONFIG_FILE', 'w') as f:
    json.dump(cfg, f, indent=2)
print(f'Set $key = {val}')
"
}

cmd_list() {
  ensure_config
  python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    cfg = json.load(f)
max_key = max(len(k) for k in cfg.keys())
for k, v in sorted(cfg.items()):
    print(f'  {k:<{max_key+2}} {v}')
"
}

cmd_init() {
  ensure_config
  echo "Wealth management plugin initialized."
  echo "Config: $CONFIG_FILE"
  echo "Data:   $CONFIG_DIR/"
  echo ""
  echo "Directories created:"
  echo "  $CONFIG_DIR/portfolios/  — imported portfolio data"
  echo "  $CONFIG_DIR/reports/     — generated reports"
  echo "  $CONFIG_DIR/cache/       — cached market data"
  echo "  $CONFIG_DIR/plans/       — financial plans"
  echo ""
  echo "Default settings (India):"
  cmd_list
  echo ""
  echo "Configure with: wealth-config.sh set <key> <value>"
}

# Main
case "${1:-help}" in
  get)
    [ $# -lt 2 ] && { echo "Usage: wealth-config.sh get <key>" >&2; exit 1; }
    cmd_get "$2"
    ;;
  set)
    [ $# -lt 3 ] && { echo "Usage: wealth-config.sh set <key> <value>" >&2; exit 1; }
    cmd_set "$2" "$3"
    ;;
  list)
    cmd_list
    ;;
  init)
    cmd_init
    ;;
  *)
    echo "wealth-config.sh — Wealth Management Plugin Configuration"
    echo ""
    echo "Usage:"
    echo "  wealth-config.sh init              Initialize plugin (creates dirs + default config)"
    echo "  wealth-config.sh get <key>         Get a config value"
    echo "  wealth-config.sh set <key> <value> Set a config value"
    echo "  wealth-config.sh list              List all config values"
    echo ""
    echo "Default config keys:"
    echo "  benchmark           Default benchmark index (default: ^NSEI / Nifty 50)"
    echo "  currency            Default currency (default: INR)"
    echo "  risk_free_rate      Risk-free rate for Sharpe ratio (default: 6.5%)"
    echo "  rebalance_threshold Drift % to trigger rebalancing (default: 5)"
    echo "  tax_bracket         Tax regime: old_regime / new_regime (default: new_regime)"
    echo "  ltcg_rate           Long-term capital gains tax rate (default: 12.5%)"
    echo "  stcg_rate           Short-term capital gains tax rate (default: 20%)"
    echo "  ltcg_exemption      LTCG annual exemption in INR (default: 125000)"
    echo "  default_exchange    Default stock exchange (default: NSE)"
    ;;
esac
