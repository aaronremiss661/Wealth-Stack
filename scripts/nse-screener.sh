#!/bin/bash
# Stock screener for NSE/BSE
# Usage: nse-screener.sh [value|quality|growth|dividend]

SCREEN=${1:-quality}

python3 -c "
import json

screens = {
    'value': {
        'name': 'Value Stocks',
        'criteria': {'PE': '< 15', 'PB': '< 2', 'Dividend Yield': '> 2%', 'Market Cap': '> Rs 5,000 Cr'},
        'data_source': 'Use web search to fetch from screener.in or trendlyne.com'
    },
    'quality': {
        'name': 'Quality Stocks',
        'criteria': {'ROE': '> 15%', 'Debt/Equity': '< 0.5', '5yr Profit CAGR': '> 10%', 'Market Cap': '> Rs 10,000 Cr'},
        'data_source': 'Use web search to fetch from screener.in'
    },
    'growth': {
        'name': 'Growth Stocks',
        'criteria': {'Revenue CAGR 5yr': '> 15%', 'EPS CAGR 5yr': '> 15%', 'Market Cap': '> Rs 2,000 Cr'},
        'data_source': 'Use web search to fetch from screener.in or trendlyne.com'
    },
    'dividend': {
        'name': 'Dividend Stocks',
        'criteria': {'Dividend Yield': '> 3%', 'Payout': 'Consistent 5yr+', 'No dividend cut': '5yr'},
        'data_source': 'Use web search to fetch from screener.in or trendlyne.com'
    }
}

screen = screens.get('$SCREEN', screens['quality'])
screen['instruction'] = 'This defines filters. Use web search or yfinance to fetch actual stock data matching these criteria.'
print(json.dumps(screen, indent=2))
"
