#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DATE_TAG="$(date +%F)"
OUT_ZIP="${1:-UST_${DATE_TAG}.zip}"
OUT_MANIFEST="${OUT_ZIP%.zip}_contents.txt"
STAGE_DIR="${REPO_ROOT}/.client_stage"

REPO_ROOT_WIN="$(cygpath -w "${REPO_ROOT}")"
STAGE_DIR_WIN="$(cygpath -w "${STAGE_DIR}")"

cleanup() {
  rm -rf "${STAGE_DIR}"
}
trap cleanup EXIT

rm -rf "${STAGE_DIR}"
mkdir -p "${STAGE_DIR}"

# Copy repo into a staging folder while excluding internal/sensitive paths.
(
  cd "${REPO_ROOT}"
  tar -cf - \
    --exclude='./.git' \
    --exclude='./.venv' \
    --exclude='./.client_stage' \
    --exclude='./.client_stage/*' \
    --exclude='*/__pycache__' \
    --exclude='./UST_*' \
    --exclude='./UST_*/*' \
    --exclude='./*.zip' \
    --exclude='./*_contents.txt' \
    --exclude='./arcgis' \
    --exclude='./arcgis/*' \
    --exclude='./tools' \
    --exclude='./tools/*' \
    --exclude='*/backups' \
    --exclude='*/backups/*' \
    --exclude='*/archive' \
    --exclude='*/archive/*' \
    --exclude='*/ast_analysis' \
    --exclude='*/ast_analysis/*' \
    --exclude='*/exports' \
    --exclude='*/exports/*' \
    --exclude='*/example_schema' \
    --exclude='*/example_schema/*' \
    --exclude='*/imports' \
    --exclude='*/imports/*' \
    --exclude='*/log' \
    --exclude='*/log/*' \
    --exclude='*/state_processing/archive' \
    --exclude='*/state_processing/archive/*' \
    --exclude='*/state_processing/states' \
    --exclude='*/state_processing/states/*' \
    --exclude='*/CA/data_files' \
    --exclude='*/CA/data_files/*' \
    --exclude='*/OR_LUST_tables' \
    --exclude='*/OR_LUST_tables/*' \
    --exclude='*/TRUSTD_tables' \
    --exclude='*/TRUSTD_tables/*' \
    --exclude='./resources' \
    --exclude='./resources/*' \
    --exclude='*/resources' \
    --exclude='*/resources/*' \
    --exclude='*/sql' \
    --exclude='*/sql/*' \
    --exclude='*/config.py' \
    .
) | (
  cd "${STAGE_DIR}"
  tar -xf -
)

# Add a dummy config module with the same variable names expected by scripts.
mkdir -p "${STAGE_DIR}/ust/python/util"
cat > "${STAGE_DIR}/ust/python/util/config.py" <<'EOF'
db_user = 'CHANGE_ME'
db_password = 'CHANGE_ME'
db_ip = '127.0.0.1'
db_connection_string = f'postgresql://{db_user}:{db_password}@{db_ip}:5432/'
db_name = 'UGSTank'

local_ust_path = r'C:\path\to\ust\state\data\\'
EOF

# Remove hardcoded API credentials from scripts in the client package.
NM_FILE="${STAGE_DIR}/ust/python/state_processing/states/NM/get_data.py"
if [[ -f "${NM_FILE}" ]]; then
  sed -E -i "s/^api_key = .*/api_key = os.getenv('NM_API_KEY', '')/" "${NM_FILE}"
  sed -E -i "s/^api_secrte = .*/api_secrte = os.getenv('NM_API_SECRET', '')/" "${NM_FILE}"
fi

NY_FILE="${STAGE_DIR}/ust/python/state_processing/states/NY/NY_API.py"
if [[ -f "${NY_FILE}" ]]; then
  cat > "${NY_FILE}" <<'EOF'
import os

import pandas as pd
from sodapy import Socrata

# Provide credentials through environment variables when needed.
SOCRATA_APP_TOKEN = os.getenv('NY_SOCRATA_APP_TOKEN', '')
SOCRATA_USERNAME = os.getenv('NY_SOCRATA_USERNAME', '')
SOCRATA_PASSWORD = os.getenv('NY_SOCRATA_PASSWORD', '')

if SOCRATA_APP_TOKEN and SOCRATA_USERNAME and SOCRATA_PASSWORD:
    client = Socrata(
        'data.ny.gov',
        SOCRATA_APP_TOKEN,
        username=SOCRATA_USERNAME,
        password=SOCRATA_PASSWORD,
    )
else:
    # Public-mode access if credentials are not supplied.
    client = Socrata('data.ny.gov', None)

results = client.get('pteg-c78n', limit=2000)
results_df = pd.DataFrame.from_records(results)
print(results_df)
EOF
fi

# Build zip and create a manifest listing every file in the archive.
rm -f "${REPO_ROOT}/${OUT_ZIP}"
powershell.exe -NoProfile -Command "Compress-Archive -Path '${STAGE_DIR_WIN}\\*' -DestinationPath '${REPO_ROOT_WIN}\\${OUT_ZIP}' -CompressionLevel Optimal -Force"

powershell.exe -NoProfile -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; \$zip=[System.IO.Compression.ZipFile]::OpenRead('${REPO_ROOT_WIN}\\${OUT_ZIP}'); \$zip.Entries | ForEach-Object { './' + \$_.FullName }; \$zip.Dispose()" > "${REPO_ROOT}/${OUT_MANIFEST}"

ZIP_SIZE="$(ls -lh "${REPO_ROOT}/${OUT_ZIP}" | awk '{print $5}')"
FILE_COUNT="$(wc -l < "${REPO_ROOT}/${OUT_MANIFEST}")"

echo "Created: ${REPO_ROOT}/${OUT_ZIP}"
echo "Manifest: ${REPO_ROOT}/${OUT_MANIFEST}"
echo "Zip Size: ${ZIP_SIZE}"
echo "Entries: ${FILE_COUNT}"
