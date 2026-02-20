# Confirmation Matching Testing

Financial trade confirmation extraction pipeline with:
- SQLite for source and normalized data storage
- text-file source documents (`External_Data/TX######.txt`)
- field-level LLM extraction via Ollama

The project is designed for deterministic, incremental parsing. Each confirmation field is processed independently, and only missing `*_LLM` values are generated.

![Application-Architecture-Diagram](utility/confiramtion-matching.png)

## Project Goal

This repository normalizes key fields from trade confirmation content into a database-friendly format so downstream matching and analytics can run on structured values.

Target fields:
- `currency`
- `settlement_amount`
- `buy_sell`
- `isin`
- `settlement_date`
- `SSI`

For each source field, there is a paired normalized output column (for example, `currency_LLM`).

## High-Level Flow

1. Create `confirmation_data` table in `DB/confirmation.db`.
2. Load structured raw values from `utility/WSS_Data.xlsx` into `confirmation_data`.
3. For each DB row `id`, read document text from `External_Data/TX{id:06d}.txt`.
4. For each target field, call the LLM only if `*_LLM` is currently empty.
5. Write parsed values back into matching `*_LLM` columns.

## Repository Components

- `create_confirmation_table.py`
  - Creates `confirmation_data` if it does not exist.
- `wss_loader.py`
  - Loads raw Excel data into `confirmation_data`.
  - Uses only expected columns and ignores extra columns.
  - Normalizes date columns to `YYYY-MM-DD`.
  - Starts import from Excel row 7 (header counted as row 1).
- `confirmation_parser.py`
  - Reads rows from `confirmation_data`.
  - Loads confirmation text from `External_Data/TX######.txt`.
  - Applies field-level extraction and writes results to `*_LLM`.
  - Skips fields that already have `*_LLM` values.
- `llm_metadata.py`
  - Central metadata for each field:
    - source column and destination `*_LLM` column
    - few-shot examples
    - field-specific prompt rules
    - JSON schema for structured output

## Data Contract

### Database

Database file: `DB/confirmation.db`  
Table: `confirmation_data`

Core columns:
- `id INTEGER PRIMARY KEY AUTOINCREMENT`
- source fields: `currency`, `settlement_amount`, `buy_sell`, `isin`, `settlement_date`, `SSI`, `creation_date`
- normalized fields: `currency_LLM`, `settlement_amount_LLM`, `buy_sell_LLM`, `isin_LLM`, `settlement_date_LLM`, `SSI_LLM`, `creation_date_LLM`

### External Text Files

Parser expects:
- Directory: `External_Data`
- Filename pattern: `TX######.txt` (zero-padded to 6 digits)
- Mapping rule: DB `id = N` maps to `External_Data/TX{N:06d}.txt`

If a mapped text file is missing or empty, that DB row is skipped.

## Setup

Requirements:
- Python 3.12+
- Ollama
- Model `llama3.2:latest`

Install dependencies:

```bash
pip install -r requirements.txt
```

Start Ollama and pull model:

```bash
ollama serve
ollama pull llama3.2
```

## Run Sequence

1. Initialize DB table:

```bash
python create_confirmation_table.py
```

2. Load WSS Excel data:

```bash
python wss_loader.py
```

3. Run parser:

```bash
python confirmation_parser.py
```

4. Validate results in `DB/confirmation.db` (`confirmation_data` table).

## Incremental Processing Behavior

- Parser is idempotent for already processed fields.
- Existing `*_LLM` values are not overwritten.
- Re-running parser only fills remaining null/empty `*_LLM` values.

## Operational Notes

- Keep DB IDs aligned with `External_Data/TX######.txt` filenames.
- If IDs or filenames are shifted, update one side so `id -> file` mapping stays 1:1.
- `wss_loader.py` appends rows; use care when re-loading to avoid unintended duplicates.

## Legacy/Utility Scripts

- `pdf_to_text.py`: extracts PDF content into text files.
- `json_to_sqlite.py`: legacy JSON ingestion path.
