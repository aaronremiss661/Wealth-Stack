# Index Composition & Methodology

Source: NSE Indices Limited, Asia Index (S&P BSE)

## Nifty 50 — Methodology

| Parameter | Details |
|-----------|---------|
| Weighting | Free-float market capitalization weighted |
| Rebalancing | Semi-annual (March, September) |
| Review cutoff | Based on 6 months of data |
| Base date | November 3, 1995 = 1000 |
| Base value | 1000 |
| Calculation | Real-time, every second |
| Total Return Index | Nifty 50 TRI (includes dividends) |

### Eligibility Criteria
1. Listed on NSE (F&O segment)
2. Among top 50 by average free-float market capitalization (6-month period)
3. Average impact cost <= 0.50% for 90% of observations (for Rs 10 Cr order size)
4. Minimum listing history: 1 month at IPO date
5. No suspension from trading
6. Domiciled in India

### Free-Float Calculation
Free-float = Total shares outstanding - Locked-in shares (promoter, government, strategic)

| Holding Category | Excluded from Free-Float |
|-----------------|------------------------|
| Promoter holding | Excluded |
| Strategic holding (>5%) | Excluded |
| Government holding | Excluded |
| FDI (if locked) | Excluded |
| Employee trust shares | Excluded |

Free-float factor is capped at bands: 5%, 10%, 15%, 20%... up to 100%.

### Index Calculation Formula
```
Index Value = (Current Market Cap of all constituents / Base Market Cap) x 1000
```
Where Market Cap = Sum of (Price x Free-Float Shares) for each stock.

### Rebalancing Impact
- Inclusion effect: Stock being added typically rises 2-5% in run-up to inclusion
- Exclusion effect: Stock being removed typically falls 2-5%
- Index funds must buy/sell on effective date (creates trading opportunity)
- Effective date: Usually 4th Friday of March and September

## Nifty 50 Sector Weights (Approximate 2025)

| Sector | Weight | Key Stocks |
|--------|--------|------------|
| Financial Services | ~33-35% | HDFC Bank, ICICI, Kotak, SBI, Bajaj Finance |
| IT | ~12-14% | TCS, Infosys, HCL Tech |
| Oil & Gas | ~10-12% | Reliance, ONGC |
| FMCG | ~7-9% | HUL, ITC |
| Automobile | ~5-7% | Maruti, M&M, Tata Motors |
| Pharma | ~4-5% | Sun Pharma, Cipla |
| Metals | ~3-4% | Tata Steel, JSW Steel |
| Telecom | ~3-4% | Bharti Airtel |
| Construction | ~2-3% | L&T |
| Others | ~3-5% | Adani group, Titan, etc. |

## Market Cap Classification (SEBI)

| Category | Definition | Updated |
|----------|-----------|---------|
| Large Cap | Top 100 by full market cap | Semi-annually (Jan, Jul) by AMFI |
| Mid Cap | 101-250 by full market cap | Semi-annually |
| Small Cap | 251 and below | Semi-annually |

### AMFI Classification Process
1. AMFI publishes list of large, mid, small cap stocks
2. Based on average market cap over prior 6 months
3. MFs must comply within 1 month of publication
4. Buffer zone: Companies near boundary get 1-month grace period
5. Available on: AMFI website (amfiindia.com)

## Other Important Methodologies

### Sensex (S&P BSE 30)
| Parameter | Details |
|-----------|---------|
| Stocks | 30 |
| Weighting | Free-float market cap |
| Base year | 1978-79 = 100 |
| Rebalancing | Semi-annual (June, December) |
| Managed by | Asia Index (S&P Global + BSE) |

### Factor Index Construction
| Factor | Selection Criterion | Weighting |
|--------|-------------------|-----------|
| Value | Low P/E, P/B, high dividend yield | Factor-tilted market cap |
| Quality | High ROE, low debt, stable earnings | Factor-tilted market cap |
| Momentum | 6-month and 12-month price momentum | Factor-tilted market cap |
| Low Volatility | Low standard deviation (1 year) | Inverse volatility weighted |
| Alpha | Jensen's alpha (CAPM-based) | Factor-tilted |

### Equal-Weight Indices
- Each stock gets equal weight (e.g., Nifty 50 EW = 2% each)
- Rebalanced quarterly to restore equal weights
- Gives more weight to smaller companies vs market-cap-weighted
- Historically outperforms cap-weighted in some periods (small-cap effect)
