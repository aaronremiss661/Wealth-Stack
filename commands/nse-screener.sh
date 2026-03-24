#!/bin/bash
# nse-screener.sh — Basic stock screener for NSE-listed companies
# Usage: nse-screener.sh --screen <type> [--limit <n>]
#
# Screen types:
#   quality     — High ROE, low debt, consistent growth (Coffee Can style)
#   value       — Low PE, high dividend yield, below book
#   growth      — High revenue/profit growth, expanding margins
#   dividend    — Consistent payout, high yield
#   largecap    — Nifty 50 constituents with key metrics
#   midcap      — Nifty Midcap 150 highlights
#   smallcap    — Nifty Smallcap 250 highlights
#
# Examples:
#   nse-screener.sh --screen quality --limit 10
#   nse-screener.sh --screen dividend --limit 20
#   nse-screener.sh --screen value

set -euo pipefail

SCREEN="quality"
LIMIT=15

while [[ $# -gt 0 ]]; do
    case "$1" in
        --screen) SCREEN="$2"; shift 2 ;;
        --limit) LIMIT="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

python3 << PYEOF
import json

screen_type = "$SCREEN"
limit = int("$LIMIT")

# Screen definitions with filters
screens = {
    "quality": {
        "name": "Quality Compounders (Coffee Can)",
        "description": "High ROE, low debt, consistent growth — Marcellus-style",
        "filters": {
            "ROE_min": "15% (10yr avg)",
            "Revenue_CAGR_10yr_min": "10%",
            "Debt_to_Equity_max": "0.5",
            "Promoter_Pledging": "0%",
            "Market_Cap_min": "Rs 5,000 Cr",
            "FCF_positive": "8 of 10 years"
        },
        "sort_by": "ROE (descending)",
        "data_source": "Use web search to fetch from screener.in or trendlyne.com"
    },
    "value": {
        "name": "Value / Undervalued",
        "description": "Low PE, high dividend yield, price below intrinsic value",
        "filters": {
            "PE_max": "15 or below sector median",
            "PB_max": "2.0",
            "Dividend_Yield_min": "2%",
            "Debt_to_Equity_max": "1.0",
            "Profit_Growth_3yr_min": "0% (not value trap)",
            "Promoter_Holding_min": "50%"
        },
        "sort_by": "PE (ascending)",
        "data_source": "Use web search to fetch from screener.in"
    },
    "growth": {
        "name": "Growth Stocks",
        "description": "High revenue & profit growth with expanding margins",
        "filters": {
            "Revenue_CAGR_3yr_min": "20%",
            "Profit_CAGR_3yr_min": "25%",
            "ROE_min": "15%",
            "OPM_trend": "Expanding YoY",
            "Market_Cap_range": "Rs 1,000 - 50,000 Cr"
        },
        "sort_by": "Profit CAGR (descending)",
        "data_source": "Use web search to fetch from screener.in or trendlyne.com"
    },
    "dividend": {
        "name": "Dividend Stocks",
        "description": "Consistent, high-yield dividend payers",
        "filters": {
            "Dividend_Yield_min": "3%",
            "Consecutive_Dividends_min": "5 years",
            "Payout_Ratio": "20-60%",
            "Profit_Growth_min": "5% CAGR",
            "Debt_to_Equity_max": "1.0"
        },
        "sort_by": "Dividend Yield (descending)",
        "data_source": "Use web search to fetch from screener.in or trendlyne.com"
    },
    "largecap": {
        "name": "Nifty 50 — Key Metrics",
        "description": "Blue chip large cap stocks with fundamental snapshot",
        "filters": {
            "Index": "Nifty 50 constituents"
        },
        "sort_by": "Market Cap (descending)",
        "data_source": "NSE India website or yfinance (ticker.NS)"
    },
    "midcap": {
        "name": "Nifty Midcap 150 — Highlights",
        "description": "Mid cap stocks sorted by momentum + fundamentals",
        "filters": {
            "Index": "Nifty Midcap 150",
            "ROE_min": "12%"
        },
        "sort_by": "1yr return (descending)",
        "data_source": "NSE India website"
    },
    "smallcap": {
        "name": "Nifty Smallcap 250 — Highlights",
        "description": "Small cap stocks — higher risk, higher potential",
        "filters": {
            "Index": "Nifty Smallcap 250",
            "Market_Cap_min": "Rs 500 Cr",
            "Promoter_Holding_min": "40%"
        },
        "sort_by": "1yr return (descending)",
        "data_source": "NSE India website"
    }
}

if screen_type not in screens:
    print(json.dumps({"error": f"Unknown screen type: {screen_type}", "available": list(screens.keys())}))
else:
    screen = screens[screen_type]
    result = {
        "screen": screen,
        "limit": limit,
        "instruction": "This screen defines the filters. Use web search or yfinance to fetch actual stock data matching these criteria.",
        "recommended_sources": [
            "https://www.screener.in/screens/new/",
            "https://trendlyne.com/stock-screeners/",
            "https://www.tickertape.in/screener",
            "yfinance Python library (pip install yfinance)"
        ]
    }
    print(json.dumps(result, indent=2))
PYEOF
