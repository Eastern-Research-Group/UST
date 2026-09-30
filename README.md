# UST Processing Scripts

This repository contains Python scripts and SQL templates used to process UST and Releases datasets into the EPA target structure.

## Quick Start

From the workspace root:

```bash
python -m venv .venv
python -m pip install --upgrade pip
python -m pip install -e .
ust validate
```

If `ust` is not available yet in your current shell session, activate the environment first or run `python main.py validate` as a fallback.

## Setup

From the workspace root, create or activate a Python environment and install the project in editable mode.

Copy `.env_example` to `.env` and fill in the local database credentials and other settings. Process environment variables with the same `UST_*` names take precedence over values in `.env`; set `UST_ENV_FILE` to use a different dotenv file.

Windows PowerShell:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -e .
```

Windows Git Bash:

```bash
python -m venv .venv
source .venv/Scripts/activate
python -m pip install --upgrade pip
python -m pip install -e .
```

Notes:

- Run `python -m pip install -e .`, not `python import -e .`
- The editable install exposes the `ust` command-line entrypoint
- Some state-specific scripts rely on optional third-party packages or local credentials; those are only required when you run those specific scripts

To recreate indexes after a PostgreSQL migration, preview the catalog-derived statements first:

```bash
python -m ust.python.backups.create_indexes
```

Apply the statements only after reviewing the preview:

```bash
python -m ust.python.backups.create_indexes --apply
```

The script uses the current database connection and recreates indexes for foreign-key columns plus the existing public lookup and UST/Release ID-column conventions. Dropped custom indexes cannot be recovered from PostgreSQL catalog metadata alone.

## Database refresh count comparison

With the old database configured, save exact row counts tonight:

```powershell
ust db-counts --save-baseline --output old-db-counts.csv
```

Keep this CSV for tomorrow (commit/share it if another checkout will run the check).
After configuring `.env` for AWS, compare the refreshed database:

```powershell
ust db-counts
```

The default baseline is `old-db-counts.csv` at the repository root; the comparison
report is `aws-db-counts.csv` in the current directory. Override either path with
`--compare PATH` and `--output PATH`. Existing output files are never overwritten.
Run the baseline command from the repository root, or supply an absolute output path.
These commands also work as `python main.py db-counts ...`.

Counts cover all ordinary and partitioned tables in `public`, excluding name tokens
`temp`, `temporary`, `tmp`, `backup`, `backups`, `bkup`, `bkp`, and `bak`
(case insensitive, including markers followed by dates). Template tables remain
included. Views and individual partition children are excluded; partition parents
include their partitions' rows. The command uses a consistent read-only snapshot,
with a 10-minute timeout per query and a 10-second lock timeout. Large tables may
take time to count. Run during a quiet period to avoid expected differences from
ongoing writes.

The report flags matching counts, changed counts (with deltas), missing tables,
and new tables. Exit codes are 0 for a saved baseline or matching comparison,
1 for differences, and 2 for configuration/query/file errors. Empty baselines and
incomplete counts are rejected. Matching counts do not verify row contents.

## Export database DDL

```powershell
ust save-ddl
ust save-ddl --schema or_ust --output ddl-snapshot
ust save-ddl --object-name ust_facility
```

Uses the configured database and defaults to `public`, writing UTF-8 SQL files
under the repository's `ust/sql/ddl/<schema>/{table,view,materialized_view,function}`.
`--output` changes the base directory. Existing matching files are overwritten;
files for objects no longer present are not deleted. Use a new output directory
for a separate snapshot. The same temp/backup name exclusions as `db-counts`
apply to all objects; `--include-temp-backup` includes them. `--object-name` matches
an exact name and includes every overload of a selected routine in one file.

The exporter reads one consistent, read-only snapshot and completes database
queries before writing files. Table definitions require the existing database
function `public.generate_create_table_statement(varchar, varchar)`; it does not
install or change that helper. Constraints and standalone indexes are appended
to table files. Function/procedure definitions come directly from PostgreSQL.

These are per-object review scripts, not a complete restorable database backup:
table definitions inherit the helper's limitations, and dependencies such as
sequences, types, triggers, ownership, and grants are not exported separately.
Use a PostgreSQL schema dump when a complete schema backup is required.
`python main.py save-ddl` supports the same options. Exit codes: 0 for success,
1 for an export error.

## CLI

The repository exposes a small command-line wrapper through the `ust` package entrypoint (preferred) and [main.py](main.py) (fallback).

Preferred form (after editable install):

```bash
ust <command> [options]
```

Fallback form (when running from source without install):

```bash
python main.py <command> [options]
```

Available commands:

- `test-connections`: test the configured PostgreSQL database with a read-only query
- `scaffold-template`: create a state SQL template and replace XX/ZZ placeholders
- `import-files`: import one `.csv`, `.xls`, `.xlsx`, or `.txt` file, or scan a directory for supported source files; use `--table-name` to override the file-derived table name when the import resolves to a single file (one name per worksheet, in worksheet order, for a multi-tab workbook)
- `init-dataset`: create a control row and initialize unregulated tables/views
- `create-unreg`: create or recreate unregulated helper tables/views
- `generate-views`: generate table population view SQL
- `generate-deagg`: generate deaggregation guidance SQL
- `generate-value-mapping`: generate value mapping SQL scaffold
- `export-substance-mapping`: export substance mapping workbook
- `mapping-xwalks`: create mapping crosswalk views
- `audit-dataset` (or `dataset-audit`): audit existing element/value mappings and source-schema readiness before generating views
- `create-missing-ids`: create missing required ID tables
- `populate-unreg`: populate unregulated helper tables; it reuses existing tables, `--delete-auto-inserts` clears only rows inserted by this script, and `--delete-all` recreates the helper tables from scratch
  Explicit `exclude_from_query = 'Y'` mappings on `ust_tank` and `ust_tank_substance` also populate tank exclusions from raw source rows, with a `Mapping exclusion:` reason. These require direct facility/tank key mappings on the source relation; joined sources need a keyed intermediary view. Compartment/piping exclusions are not promoted to whole-tank exclusions. Use `--delete-auto-inserts` to rebuild automatic exclusions after changing mappings.
- `exclude-unregulated`: generate/execute unregulated exclusion SQL for views
- `qa`: run QA checks and export a QA workbook
- `populate`: load data from state views into public EPA tables
- `export-template`: export a populated template workbook
- `export-control-summary`: export control table summary workbook
- `export-source-data`: export source schema tables to CSV
- `export-review-materials`: export control summary, QA, template, and peer review materials
- `review`: run peer review row-count checks
- `validate`: run repo validation checks
- `profile`: create/use/list profile defaults for repeated CLI runs

Examples:

```bash
ust test-connections
ust test-connections --timeout 20
ust validate
ust validate --skip-tests
ust scaffold-template --type ust --organization-id MA
ust scaffold-template --type ust --organization-id MA --control-id 123 --overwrite
ust profile use ma-ust && ust scaffold-template --yes
ust import-files --type ust --organization-id TX --path "C:/data/TX"
ust import-files --type ust --organization-id TX --path "C:/data/TX/source.xlsx"
ust import-files --type ust --organization-id TX --path "C:/data/TX/really long name.csv" --table-name tanks
ust import-files --type ust --organization-id TX --path "C:/data/TX/two tabs.xlsx" --table-name tanks releases
ust init-dataset --type release --organization-id MA --data-source "State API export"
ust generate-views --type ust --control-id 123
ust generate-deagg --type ust --control-id 123
ust generate-value-mapping --type ust --control-id 123 --append
ust export-substance-mapping --type ust --control-id 123
ust export-substance-mapping --type ust --control-id 123 --email
ust mapping-xwalks --type ust --control-id 123
ust audit-dataset --type ust --control-id 123
ust audit-dataset --type ust --control-id 123 --fix-source-identifiers --fix-query-logic
ust create-missing-ids --type ust --control-id 123
ust populate-unreg --type ust --control-id 123
ust populate-unreg --type ust --control-id 123 --delete-auto-inserts
ust exclude-unregulated --type ust --control-id 123 --print-sql
ust qa --type ust --control-id 123 --organization-id TX
ust qa --type ust --control-id 123 --organization-id TX --fast
ust qa --type ust --control-id 123 --organization-id TX --materialize-views
ust qa --type ust --control-id 123 --organization-id TX --no-materialize-views
ust generate-views --type ust --control-id 123 --preflight-only
ust generate-views --type ust --control-id 123 --table-name ust_facility --preflight-only --strict-mapping
ust qa --type ust --control-id 123 --organization-id TX --dry-run
ust populate --type release --control-id 456 --organization-id MA --delete-existing
ust populate --delete-existing --dry-run
ust export-template --type ust --control-id 123
ust export-control-summary --type ust --control-id 123
ust export-source-data --type ust --control-id 123 --used-tables-only
ust export-review-materials --type ust --control-id 123 --organization-id TX
ust export-review-materials --type ust --control-id 123 --organization-id TX --fast-qa
ust export-review-materials --dry-run
ust review --type release --control-id 456 --organization-id MA
```

To see built-in help:

```bash
ust --help
ust validate --help
ust generate-views --help
```

Fallback help form:

```bash
python main.py --help
python main.py validate --help
python main.py generate-views --help
```

## Profiles

Use profiles to avoid repeating `--type`, `--organization-id`, and `--control-id` while keeping runs safe.

Create and activate a profile:

```bash
ust profile set sd-ust --type ust --organization-id SD --control-id 9 --use
```

Use profile defaults automatically:

```bash
ust generate-views --yes
ust qa --yes
```

Without `--yes`, the CLI prompts for confirmation whenever it fills values from the active profile.

Useful profile commands:

```bash
ust profile show
ust profile list
ust profile use sd-ust
ust profile clear
ust profile sync-db
ust profile sync-db --use sd-ust
```

`ust profile sync-db` reads `ust_control` and `release_control` and creates/updates profiles using the most recent control ID per organization.

`init-dataset` automatically creates and activates a profile named `<organization>-<type>` using the new control ID it inserts.

## Dataset Audits

Run `audit-dataset` after completing element/value mapping and `mapping-xwalks`, before creating IDs or generating EPA views. It checks source relation and column references, unmapped source values, non-MAP mapping decisions, and supported legacy `query_logic` repairs.

```bash
ust audit-dataset --type ust --control-id 123
ust audit-dataset --type release --control-id 456
```

The command prints a concise summary and writes suggested repair SQL in the matching state SQL folder. Use `--print-sql` for terminal copy/paste, `--fix-source-identifiers` for unambiguous identifier normalization, and `--fix-query-logic` for supported legacy query-logic cleanup.

When resuming an older dataset, first apply the review-comment changes already known for that ticket, then run the audit to identify remaining mapping or source-schema drift.

QA prerequisite for new or rebuilt schemas:

Run this first to ensure unregulated helper tables exist before QA checks query them.

```bash
ust create-unreg --type ust --control-id <control_id>
ust qa --type ust --organization-id <state_code>
```

Fallback form:

```bash
python main.py create-unreg --type ust --control-id <control_id>
python main.py qa --type ust --organization-id <state_code>
```

## Validation

The repo now includes a repeatable validation command that checks active code outside the archive paths.

Preferred from the workspace root:

```bash
ust validate
```

Fallback when not installed as a package entrypoint:

```bash
python main.py validate
```

What it does:

- Compiles non-archive Python modules
- Imports non-archive Python modules to catch import-time failures
- Runs the regression test in [tests/test_import_service.py](tests/test_import_service.py)
- Runs CLI regression coverage in [tests/test_main_cli.py](tests/test_main_cli.py)

The GitHub Actions workflow in [.github/workflows/validate.yml](.github/workflows/validate.yml) runs the same `validate` command, plus a fast `validate --skip-tests` gate.

Optional flags:

- `--skip-tests`: skip the unittest step
- `--include-archive`: include archive modules in compile/import validation

## CI

GitHub Actions runs two checks on pushes and pull requests through [.github/workflows/validate.yml](.github/workflows/validate.yml).

- `compile-import`: fast compile/import gate without tests
- `validate`: full validation including tests
