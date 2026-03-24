# Portfolio Import Connector

## Purpose
Ingest portfolio data from various formats and normalize into the standard JSON schema.

## Standard Portfolio Schema

```json
{
  "name": "My Portfolio",
  "created": "2026-03-24T00:00:00Z",
  "updated": "2026-03-24T00:00:00Z",
  "currency": "INR",
  "holdings": [
    {
      "ticker": "RELIANCE.NS",
      "name": "Reliance Industries Ltd",
      "shares": 50,
      "cost_basis": 125000,
      "purchase_date": "2024-06-15",
      "account": "Demat",
      "asset_class": "equity",
      "exchange": "NSE"
    }
  ],
  "cash": {
    "amount": 200000,
    "currency": "INR"
  },
  "accounts": [
    { "name": "Demat", "type": "taxable", "broker": "Zerodha" },
    { "name": "PPF", "type": "tax_exempt" },
    { "name": "NPS", "type": "retirement" }
  ]
}
```

## Supported Import Formats

### 1. CSV Import

Expected columns (flexible — maps common variations):

| Standard Column | Aliases Accepted |
|----------------|------------------|
| ticker | symbol, scrip, stock, isin |
| shares | quantity, qty, units |
| cost_basis | cost, avg_price, purchase_price, total_cost |
| purchase_date | date, buy_date, trade_date |
| account | portfolio, folio, demat |

```bash
bash commands/import-portfolio.sh --format csv "<file-path>"
```

### 2. JSON Import
Direct import if already in standard schema:
```bash
bash commands/import-portfolio.sh --format json "<file-path>"
```

### 3. Zerodha (Kite) Holdings Export
Zerodha Console export CSV format:
- Columns: Instrument, Qty., Avg. cost, LTP, Cur. val, P&L, Net chg., Day chg.

```bash
bash commands/import-portfolio.sh --format zerodha "<file-path>"
```

### 4. Groww Holdings Export
Groww app export format:
- Columns: Stock Name, Symbol, Quantity, Avg Buy Price, Current Price, Returns

```bash
bash commands/import-portfolio.sh --format groww "<file-path>"
```

### 5. CAMS/KFintech Mutual Fund Statement
Consolidated Account Statement for mutual funds:
- Parse folio-wise holdings
- Map scheme names to tickers

```bash
bash commands/import-portfolio.sh --format cams "<file-path>"
```

### 6. Manual Entry
Interactive mode — user provides holdings one at a time:

```
Enter holding (TICKER SHARES COST_BASIS) or 'done' to finish:
> RELIANCE.NS 50 125000
> TCS.NS 30 105000
> HDFCBANK.NS 100 160000
> done
```

## Validation Rules

After import, validate:
1. All tickers resolve to valid securities (via market-data connector)
2. Share counts are positive numbers
3. Cost basis is positive
4. No duplicate tickers within the same account
5. Total weights sum correctly

## Storage

Save normalized portfolio to:
```
~/.wealth-mgmt/portfolios/<portfolio-name>-<date>.json
```

Keep a symlink to the latest:
```
~/.wealth-mgmt/portfolios/current.json → <latest-file>
```
