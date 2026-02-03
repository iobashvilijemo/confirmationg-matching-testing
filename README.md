# Confirmation Matching Testing

A financial trade confirmation parser and validator that extracts structured data from unstructured trade confirmation documents using LLM-based information extraction.

## Features

- **PDF Text Extraction**: Convert PDF confirmations to structured text files
- **LLM-Powered Parsing**: Uses `llama3.2` to intelligently extract trade details
- **Structured Output**: Generates JSON with standardized field mapping
- **Database Integration**: Stores parsed confirmations in SQLite for querying and analysis

## Project Structure

```
├── counterparty_dataparser.py      # Main LLM extraction engine
├── pdf_converter.py                 # PDF to text conversion
├── counterparty_json_to_sqlite.py   # JSON to SQLite import
├── wss_data_loader.py               # Data loader utility
├── External_Data/                   # Input confirmations
├── result/                          # Extracted JSON output
└── DB/                              # SQLite databases
```

## Setup

### Prerequisites
- Python 3.12+
- Ollama (with `llama3.2` model)
- Virtual environment

### Installation

```bash
# Create and activate virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Start Ollama server (in separate terminal)
ollama serve

# Pull model
ollama pull llama3.2
```

## Usage

```bash
# Extract confirmations using LLM
python counterparty_dataparser.py

# Convert PDFs to text
python pdf_converter.py

# Import extracted JSON to database
python counterparty_json_to_sqlite.py
```

## Technologies

- **Python 3.12**
- **Ollama** - LLM inference engine
- **llama3.2** - Language model for extraction
- **PyMuPDF** - PDF processing
- **Pandas** - Data manipulation
- **SQLite3** - Data persistence


