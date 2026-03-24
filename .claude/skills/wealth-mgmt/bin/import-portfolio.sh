#!/usr/bin/env bash
# import-portfolio.sh — Import portfolio data from CSV/JSON/broker exports
# Usage: import-portfolio.sh [--format csv|json|zerodha|groww|cams] <file-path>
# Normalizes to standard portfolio JSON schema and saves to ~/.wealth-mgmt/portfolios/

set -euo pipefail

FORMAT="csv"
FILE_PATH=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --format) FORMAT="$2"; shift 2 ;;
    *) FILE_PATH="$1"; shift ;;
  esac
done

if [ -z "$FILE_PATH" ]; then
  echo "Usage: import-portfolio.sh [--format csv|json|zerodha|groww|cams] <file-path>" >&2
  exit 1
fi

if [ ! -f "$FILE_PATH" ]; then
  echo "File not found: $FILE_PATH" >&2
  exit 1
fi

OUTPUT_DIR="$HOME/.wealth-mgmt/portfolios"
mkdir -p "$OUTPUT_DIR"

python3 << PYEOF
import csv
import json
import os
import sys
from datetime import datetime, timezone

file_path = "$FILE_PATH"
fmt = "$FORMAT"
output_dir = os.path.expanduser("~/.wealth-mgmt/portfolios")

def normalize_header(header):
    """Map common column name variations to standard names."""
    mapping = {
        "symbol": "ticker", "scrip": "ticker", "stock": "ticker",
        "isin": "isin", "instrument": "ticker",
        "quantity": "shares", "qty": "shares", "qty.": "shares", "units": "shares",
        "cost": "cost_basis", "avg_price": "avg_cost", "avg. cost": "avg_cost",
        "purchase_price": "avg_cost", "total_cost": "cost_basis",
        "avg buy price": "avg_cost", "average price": "avg_cost",
        "date": "purchase_date", "buy_date": "purchase_date", "trade_date": "purchase_date",
        "account": "account", "portfolio": "account", "folio": "account", "demat": "account",
        "ltp": "current_price", "current price": "current_price",
        "cur. val": "current_value", "current value": "current_value",
        "p&l": "pnl", "returns": "pnl", "net chg.": "net_change",
    }
    h = header.strip().lower().replace("_", " ")
    return mapping.get(h, h.replace(" ", "_"))

def parse_csv(file_path):
    holdings = []
    with open(file_path, "r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        headers = {normalize_header(h): h for h in reader.fieldnames}

        for row in reader:
            mapped = {}
            for std_name, orig_name in headers.items():
                mapped[std_name] = row[orig_name].strip()

            ticker = mapped.get("ticker", "")
            if not ticker:
                continue

            shares = float(mapped.get("shares", "0").replace(",", ""))
            avg_cost = mapped.get("avg_cost", "0").replace(",", "")
            cost_basis = mapped.get("cost_basis", "0").replace(",", "")

            if avg_cost and float(avg_cost) > 0:
                total_cost = shares * float(avg_cost)
            elif cost_basis and float(cost_basis) > 0:
                total_cost = float(cost_basis)
            else:
                total_cost = 0

            holdings.append({
                "ticker": ticker,
                "shares": shares,
                "cost_basis": round(total_cost, 2),
                "purchase_date": mapped.get("purchase_date", ""),
                "account": mapped.get("account", "Default"),
            })
    return holdings

def parse_zerodha(file_path):
    """Parse Zerodha Console holdings export."""
    holdings = []
    with open(file_path, "r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            instrument = row.get("Instrument", "").strip()
            if not instrument:
                continue
            # Zerodha uses BSE/NSE suffixes, normalize to .NS
            ticker = instrument.split("-")[0].strip()
            if not ticker.endswith((".NS", ".BO")):
                ticker += ".NS"

            qty = float(row.get("Qty.", "0").replace(",", ""))
            avg_cost = float(row.get("Avg. cost", "0").replace(",", ""))

            holdings.append({
                "ticker": ticker,
                "shares": qty,
                "cost_basis": round(qty * avg_cost, 2),
                "account": "Zerodha",
                "exchange": "NSE",
            })
    return holdings

def parse_groww(file_path):
    """Parse Groww holdings export."""
    holdings = []
    with open(file_path, "r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            symbol = row.get("Symbol", "").strip()
            if not symbol:
                continue
            if not symbol.endswith((".NS", ".BO")):
                symbol += ".NS"

            qty = float(row.get("Quantity", "0").replace(",", ""))
            avg_price = float(row.get("Avg Buy Price", "0").replace(",", ""))

            holdings.append({
                "ticker": symbol,
                "shares": qty,
                "cost_basis": round(qty * avg_price, 2),
                "account": "Groww",
                "exchange": "NSE",
            })
    return holdings

# Parse based on format
if fmt == "csv":
    holdings = parse_csv(file_path)
elif fmt == "json":
    with open(file_path, "r") as f:
        data = json.load(f)
    if isinstance(data, list):
        holdings = data
    else:
        holdings = data.get("holdings", [])
elif fmt == "zerodha":
    holdings = parse_zerodha(file_path)
elif fmt == "groww":
    holdings = parse_groww(file_path)
elif fmt == "cams":
    # CAMS statements are complex PDFs — flag for manual parsing
    print(json.dumps({"error": "CAMS PDF parsing requires manual extraction. Export holdings as CSV from your AMC website instead."}))
    sys.exit(1)
else:
    print(json.dumps({"error": f"Unknown format: {fmt}"}))
    sys.exit(1)

# Detect currency based on tickers
has_indian = any(h["ticker"].endswith((".NS", ".BO")) for h in holdings)
currency = "INR" if has_indian else "USD"

# Build portfolio object
portfolio = {
    "name": os.path.splitext(os.path.basename(file_path))[0],
    "created": datetime.now(timezone.utc).isoformat(),
    "updated": datetime.now(timezone.utc).isoformat(),
    "currency": currency,
    "holdings": holdings,
    "cash": {"amount": 0, "currency": currency},
    "source_file": os.path.basename(file_path),
    "source_format": fmt,
}

# Save
date_str = datetime.now().strftime("%Y-%m-%d")
output_file = os.path.join(output_dir, f"portfolio-{date_str}.json")
with open(output_file, "w") as f:
    json.dump(portfolio, f, indent=2)

# Update current symlink
current_link = os.path.join(output_dir, "current.json")
if os.path.islink(current_link):
    os.unlink(current_link)
elif os.path.exists(current_link):
    os.remove(current_link)
os.symlink(output_file, current_link)

print(json.dumps({
    "status": "success",
    "holdings_count": len(holdings),
    "currency": currency,
    "saved_to": output_file,
    "portfolio": portfolio
}, indent=2))
PYEOF
