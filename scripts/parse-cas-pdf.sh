#!/bin/bash
# Parse CAMS/KFintech CAS (Consolidated Account Statement) PDF
# Extracts mutual fund holdings into structured JSON
# Usage: parse-cas-pdf.sh CAS_PDF_PATH
# Supports: CAMS CAS, KFintech CAS, combined CAS statements

PDF_FILE=${1:?"Usage: parse-cas-pdf.sh CAS_PDF_PATH"}

if [ ! -f "$PDF_FILE" ]; then
  echo "{\"error\": \"File not found: $PDF_FILE\"}"
  exit 1
fi

mkdir -p ~/.wealthstack/portfolios

python3 -c "
import json, sys, os, re
from datetime import datetime

pdf_path = '''$PDF_FILE'''
out_dir = os.path.expanduser('~/.wealthstack/portfolios')

# ---------------------------------------------------------------------------
# PDF text extraction — try pdfplumber first, fall back to tabula, then PyPDF2
# ---------------------------------------------------------------------------
text_pages = []
extraction_method = None

try:
    import pdfplumber
    extraction_method = 'pdfplumber'
    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            page_text = page.extract_text()
            if page_text:
                text_pages.append(page_text)
except ImportError:
    pass
except Exception as e:
    if 'password' in str(e).lower() or 'encrypted' in str(e).lower():
        print(json.dumps({'error': 'PDF is password-protected. Please provide an unlocked CAS PDF.'}))
        sys.exit(1)

if not text_pages:
    try:
        import tabula
        extraction_method = 'tabula'
        tables = tabula.read_pdf(pdf_path, pages='all', multiple_tables=True, silent=True)
        for df in tables:
            text_pages.append(df.to_string())
    except ImportError:
        pass
    except Exception:
        pass

if not text_pages:
    try:
        from PyPDF2 import PdfReader
        extraction_method = 'PyPDF2'
        reader = PdfReader(pdf_path)
        if reader.is_encrypted:
            print(json.dumps({'error': 'PDF is password-protected. Please provide an unlocked CAS PDF.'}))
            sys.exit(1)
        for page in reader.pages:
            page_text = page.extract_text()
            if page_text:
                text_pages.append(page_text)
    except ImportError:
        pass
    except Exception:
        pass

if not text_pages:
    print(json.dumps({
        'error': 'No PDF parsing library available. Install one of: pip install pdfplumber  OR  pip install tabula-py  OR  pip install PyPDF2'
    }))
    sys.exit(1)

full_text = '\n'.join(text_pages)

# ---------------------------------------------------------------------------
# Detect CAS provider
# ---------------------------------------------------------------------------
cas_provider = 'unknown'
if 'CAMS' in full_text.upper() or 'COMPUTER AGE MANAGEMENT' in full_text.upper():
    cas_provider = 'CAMS'
elif 'KFINTECH' in full_text.upper() or 'KARVY' in full_text.upper() or 'KFIN' in full_text.upper():
    cas_provider = 'KFintech'

# ---------------------------------------------------------------------------
# Parse holdings from CAS text
# ---------------------------------------------------------------------------
holdings = []
lines = full_text.split('\n')

# State machine for parsing
current_fund = None
current_folio = None
current_registrar = None

# Common AMFI scheme code patterns and fund house names
fund_houses = [
    'HDFC', 'ICICI', 'SBI', 'AXIS', 'KOTAK', 'NIPPON', 'TATA', 'UTI',
    'ADITYA BIRLA', 'DSP', 'FRANKLIN', 'MIRAE', 'MOTILAL', 'PGIM',
    'CANARA', 'SUNDARAM', 'INVESCO', 'BANDHAN', 'EDELWEISS', 'HSBC',
    'IDFC', 'L&T', 'MAHINDRA', 'PPFAS', 'QUANT', 'QUANTUM', 'UNION',
    'BARODA', 'BOI', 'JM', 'LIC', 'NAVI', 'ITI', 'SAMCO', 'TRUST',
    'PARAG PARIKH', 'GROWW', 'ZERODHA', '360 ONE', 'WHITEOAK',
]

# Regex patterns for CAS parsing
folio_pattern = re.compile(r'Folio\s*(?:No\.?|Number)?\s*[:\-]?\s*(\S+)', re.IGNORECASE)
nav_pattern = re.compile(r'NAV.*?(?:Rs\.?|INR)?\s*([\d,]+\.?\d*)', re.IGNORECASE)
units_pattern = re.compile(r'(\d+[\d,]*\.\d{1,4})\s+(?:Units?)?', re.IGNORECASE)
value_pattern = re.compile(r'(?:Valuation|Value|Market\s*Value|Amount).*?(?:Rs\.?|INR)?\s*([\d,]+\.?\d*)', re.IGNORECASE)

# Pattern: Closing Unit Balance: 123.456
closing_balance_pattern = re.compile(
    r'Closing\s+Unit\s+Balance\s*[:\-]?\s*([\d,]+\.?\d*)',
    re.IGNORECASE
)

# Pattern: NAV on date: Rs. 45.6789
nav_date_pattern = re.compile(
    r'NAV\s+(?:on|as\s+on)?\s*[\d\-/]+\s*[:\-]?\s*(?:Rs\.?|INR)?\s*([\d,]+\.?\d*)',
    re.IGNORECASE
)

# Pattern: Valuation on date: Rs. 12345.67
valuation_pattern = re.compile(
    r'Valuation\s+(?:on|as\s+on)?\s*[\d\-/]+\s*[:\-]?\s*(?:Rs\.?|INR)?\s*([\d,]+\.?\d*)',
    re.IGNORECASE
)

# Scheme code hint (some CAS statements include it)
scheme_code_pattern = re.compile(r'(?:Scheme\s*Code|AMFI\s*Code)\s*[:\-]?\s*(\d{5,6})', re.IGNORECASE)

def parse_amount(s):
    \"\"\"Parse Indian-format numbers like 1,23,456.78\"\"\"
    if not s:
        return 0.0
    try:
        return float(s.replace(',', ''))
    except (ValueError, TypeError):
        return 0.0

def is_fund_line(line):
    \"\"\"Check if the line looks like a fund name\"\"\"
    upper = line.strip().upper()
    for house in fund_houses:
        if house in upper:
            # Additional validation: should contain common MF keywords
            mf_keywords = ['FUND', 'PLAN', 'GROWTH', 'DIVIDEND', 'DIRECT', 'REGULAR',
                           'IDCW', 'OPTION', 'SCHEME', 'FLEXI', 'CAP', 'EQUITY',
                           'DEBT', 'HYBRID', 'LIQUID', 'INDEX', 'ETF', 'GILT',
                           'OVERNIGHT', 'BANKING', 'TAX', 'ELSS', 'BALANCED',
                           'ADVANTAGE', 'NIFTY', 'SENSEX', 'MIDCAP', 'SMALLCAP',
                           'LARGE', 'MULTI', 'FOCUSED', 'VALUE', 'CONTRA',
                           'BLUECHIP', 'OPPORTUNITIES', 'SAVINGS']
            if any(kw in upper for kw in mf_keywords):
                return True
    return False

i = 0
while i < len(lines):
    line = lines[i].strip()

    # Detect folio number
    folio_match = folio_pattern.search(line)
    if folio_match:
        current_folio = folio_match.group(1).strip().rstrip(':')

    # Detect scheme code
    sc_match = scheme_code_pattern.search(line)
    scheme_code = sc_match.group(1) if sc_match else ''

    # Detect fund name
    if is_fund_line(line):
        current_fund = line.strip()
        # Fund name may span two lines
        if i + 1 < len(lines) and not folio_pattern.search(lines[i + 1]):
            next_line = lines[i + 1].strip()
            if any(kw in next_line.upper() for kw in ['GROWTH', 'DIRECT', 'REGULAR', 'PLAN', 'OPTION', 'IDCW']):
                current_fund = current_fund + ' ' + next_line

    # Detect closing unit balance and NAV/valuation (typically near each other)
    closing_match = closing_balance_pattern.search(line)
    if closing_match and current_fund:
        units = parse_amount(closing_match.group(1))
        nav_val = 0.0
        value = 0.0

        # Look ahead a few lines for NAV and valuation
        for j in range(i, min(i + 5, len(lines))):
            check_line = lines[j].strip()
            nm = nav_date_pattern.search(check_line)
            if nm:
                nav_val = parse_amount(nm.group(1))
            vm = valuation_pattern.search(check_line)
            if vm:
                value = parse_amount(vm.group(1))

        # Compute value from units * NAV if not found directly
        if value == 0 and units > 0 and nav_val > 0:
            value = round(units * nav_val, 2)

        if units > 0:
            holdings.append({
                'fund_name': current_fund,
                'folio': current_folio or '',
                'units': units,
                'nav': nav_val,
                'value': round(value, 2),
                'scheme_code': scheme_code,
                'asset_type': 'mf',
                'currency': 'INR'
            })
            # Reset for next fund
            current_fund = None
            scheme_code = ''

    i += 1

# ---------------------------------------------------------------------------
# Fallback: table-row parsing for structured CAS formats
# If no holdings were found above, try a tabular pattern
# ---------------------------------------------------------------------------
if not holdings:
    # Some CAS PDFs have tabular data: Fund Name | Folio | Units | NAV | Value
    table_row_pattern = re.compile(
        r'(.+?)\s+(\d[\d/]+)\s+([\d,]+\.\d+)\s+([\d,]+\.?\d*)\s+([\d,]+\.?\d*)'
    )
    for line in lines:
        m = table_row_pattern.search(line.strip())
        if m:
            fname = m.group(1).strip()
            if any(house in fname.upper() for house in fund_houses):
                folio = m.group(2).strip()
                units = parse_amount(m.group(3))
                nav_val = parse_amount(m.group(4))
                value = parse_amount(m.group(5))
                if units > 0:
                    holdings.append({
                        'fund_name': fname,
                        'folio': folio,
                        'units': units,
                        'nav': nav_val,
                        'value': round(value, 2) if value else round(units * nav_val, 2),
                        'scheme_code': '',
                        'asset_type': 'mf',
                        'currency': 'INR'
                    })

# ---------------------------------------------------------------------------
# De-duplicate holdings (same folio + fund name)
# ---------------------------------------------------------------------------
seen = set()
unique_holdings = []
for h in holdings:
    key = (h['fund_name'], h['folio'])
    if key not in seen:
        seen.add(key)
        unique_holdings.append(h)
holdings = unique_holdings

# ---------------------------------------------------------------------------
# Build summary and output
# ---------------------------------------------------------------------------
total_value = round(sum(h['value'] for h in holdings), 2)
result = {
    'holdings': holdings,
    'summary': {
        'total_value': total_value,
        'fund_count': len(holdings),
        'cas_provider': cas_provider,
        'extraction_method': extraction_method,
        'currency': 'INR'
    },
    'parsed_from': os.path.basename(pdf_path),
    'parsed_at': datetime.now().isoformat()
}

# Save to file
out_path = os.path.join(out_dir, 'cas-latest.json')
with open(out_path, 'w') as f:
    json.dump(result, f, indent=2)

# Output to stdout
result['saved_to'] = out_path
print(json.dumps(result, indent=2))
" 2>/dev/null
