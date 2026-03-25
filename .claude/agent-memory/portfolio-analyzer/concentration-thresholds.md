# Concentration Risk Thresholds & Benchmark Indices

## Diversification Scoring Framework

### Stock-Level Concentration

| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| Top 1 holding | < 8% | 8-15% | > 15% |
| Top 5 holdings | < 30% | 30-50% | > 50% |
| Top 10 holdings | < 50% | 50-70% | > 70% |
| Total number of stocks | > 15 | 8-15 | < 8 |

### Sector Concentration

| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| Top 1 sector | < 25% | 25-35% | > 35% |
| Top 3 sectors | < 60% | 60-75% | > 75% |
| BFSI overweight vs Nifty | < +5% | +5% to +10% | > +10% |

### Asset Class Concentration

| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| Equity in conservative profile | < 30% | 30-50% | > 50% |
| Equity in aggressive profile | < 85% | 85-95% | > 95% |
| Single AMC exposure | < 30% | 30-50% | > 50% |
| International allocation | < 20% | 20-30% | > 30% |

### Market Cap Concentration

| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| Small cap allocation (moderate) | < 15% | 15-25% | > 25% |
| Small cap allocation (aggressive) | < 25% | 25-40% | > 40% |
| Large cap minimum | > 40% | 25-40% | < 25% |

## Herfindahl-Hirschman Index (HHI) for Portfolios

- HHI = Sum of squared weight of each holding
- **< 0.06**: Well diversified (equivalent to ~17+ equal holdings)
- **0.06 - 0.15**: Moderately concentrated (equivalent to ~7-17 equal holdings)
- **> 0.15**: Highly concentrated (equivalent to < 7 equal holdings)

Formula: HHI = sum(w_i^2) where w_i is weight of each holding

## Benchmark Indices Reference

### Broad Market
| Index | Stocks | Use Case |
|-------|--------|----------|
| Nifty 50 | 50 | Large cap benchmark |
| Nifty 100 | 100 | Top 100 stocks |
| Nifty 200 | 200 | Large + mid cap |
| Nifty 500 | 500 | Broad market |
| Nifty Midcap 150 | 150 | Mid cap benchmark |
| Nifty Smallcap 250 | 250 | Small cap benchmark |
| BSE Sensex | 30 | Legacy large cap benchmark |

### Market Cap Definitions (SEBI, updated semi-annually)
- **Large Cap**: Rank 1-100 by full market capitalization
- **Mid Cap**: Rank 101-250 by full market capitalization
- **Small Cap**: Rank 251 and below
- Updated by AMFI every six months (Jan and Jul)

### Strategy Indices
| Index | Strategy | Benchmark For |
|-------|----------|---------------|
| Nifty 50 Value 20 | Value stocks from Nifty 50 | Value funds |
| Nifty Growth Sectors 15 | High-growth sector stocks | Growth funds |
| Nifty Alpha 50 | High-alpha stocks | Momentum/alpha strategies |
| Nifty Quality 30 | High ROE, low debt | Quality funds |
| Nifty Low Volatility 30 | Low-beta stocks | Low-vol strategies |
| Nifty High Dividend 50 | High dividend yield | Income strategies |
| Nifty 50 Equal Weight | Equal weight Nifty 50 | Equal-weight strategies |

## Portfolio Health Score (Composite)

| Component | Weight | Scoring |
|-----------|--------|---------|
| Stock concentration (HHI) | 25% | 0-100 based on HHI |
| Sector diversification | 20% | 0-100 based on sector spread |
| Market cap balance | 15% | 0-100 based on cap distribution |
| Risk-profile alignment | 20% | 0-100 based on equity/debt fit |
| Cost efficiency | 10% | 0-100 based on expense ratios |
| Liquidity score | 10% | 0-100 based on exit ease |

Overall score: Weighted sum mapped to: Excellent (80+), Good (60-80), Fair (40-60), Poor (<40)
