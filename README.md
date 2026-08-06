# UST Processing Scripts

This repository contains Python scripts and SQL templates used to process UST and Releases datasets into the EPA target structure.

## Quick Start

From the workspace root:

```bash
python -m venv .venv
python -m pip install -e .
ust validate
```

If `ust` is not available yet in your current shell session, activate the environment first or run `python main.py validate` as a fallback.

## Setup

From the workspace root, create or activate a Python environment and install the project in editable mode.

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

- `scaffold-template`: create a state SQL template and replace XX/ZZ placeholders
- `import-files`: import source files into a state schema
- `init-dataset`: create a control row and initialize unregulated tables/views
- `create-unreg`: create or recreate unregulated helper tables/views
- `generate-views`: generate table population view SQL
- `generate-deagg`: generate deaggregation guidance SQL
- `generate-value-mapping`: generate value mapping SQL scaffold
- `export-substance-mapping`: export substance mapping workbook
- `mapping-xwalks`: create mapping crosswalk views
- `create-missing-ids`: create missing required ID tables
- `populate-unreg`: populate unregulated helper tables
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
ust validate
ust validate --skip-tests
ust scaffold-template --type ust --organization-id MA
ust scaffold-template --type ust --organization-id MA --control-id 123 --overwrite
ust profile use ma-ust && ust scaffold-template --yes
ust import-files --type ust --organization-id TX --path "C:/data/TX"
ust init-dataset --type release --organization-id MA --data-source "State API export"
ust generate-views --type ust --control-id 123
ust generate-deagg --type ust --control-id 123
ust generate-value-mapping --type ust --control-id 123 --append
ust export-substance-mapping --type ust --control-id 123 --no-email
ust mapping-xwalks --type ust --control-id 123
ust create-missing-ids --type ust --control-id 123
ust populate-unreg --type ust --control-id 123
ust exclude-unregulated --type ust --control-id 123 --print-sql
ust qa --type ust --control-id 123 --organization-id TX
ust qa --type ust --control-id 123 --organization-id TX --fast
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

Optional flags:

- `--skip-tests`: skip the unittest step
- `--include-archive`: include archive modules in compile/import validation

## CI

GitHub Actions runs two checks on pushes and pull requests through [.github/workflows/validate.yml](.github/workflows/validate.yml).

- `compile-import`: fast compile/import gate without tests
- `validate`: full validation including tests
