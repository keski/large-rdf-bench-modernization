#!/bin/bash
# -----------------------------------------------------------------------------
# LargeRDFBench download and extraction script
#
# Main Steps
#   1. Downloads all LargeRDFBench dataset archives using download_dataset.py
#   2. Extracts ZIP and 7z archives into raw_datasets/
#
# Requirements
#   - Bash
#   - Python 3
#   - gdown (Python package)
#   - unzip
#   - 7-Zip (7z command)
#
# Installation (Debian/Ubuntu)
#   sudo apt install python3 python3-pip unzip 7zip
#   pip install gdown
#
# Notes
#   - Run this script from the repository root.
#   - Original archives and extracted files are stored in raw_datasets/.
#   - Existing archives and extracted directories are skipped.
#   - download_dataset.py handles individual Google Drive downloads.
#
# Usage
#   ./download.sh
# -----------------------------------------------------------------------------

set -euo pipefail


# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper for pretty section headers
section() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }

# Helper for success and error messages
ok()    { echo -e "${GREEN}✔ $1${NC}"; }
info()  { echo -e "${YELLOW}$1${NC}"; }
error() { echo -e "${RED}✖ $1${NC}"; }

# RDF datasets
declare -A RDF_DATASETS=(
  [LinkedTCGA-M]="0B_MUFqryVpByQ0J2NFAtNVlzMUk"
  [LinkedTCGA-E]="0B_MUFqryVpByOGdJWU8xNXR0aUE"
  [LinkedTCGA-A]="0B_MUFqryVpByd2FVQ2gzOXhIemc"
  [ChEBI]="0B1tUDhWNTjO-Vk81dGVkNVNuY1E"
  [DBPedia-Subset]="0B1tUDhWNTjO-QWk5MVJud3cxUXM"
  [DrugBank]="0B1tUDhWNTjO-cVp5QV9VUWRuYkk"
  [GeoNames]="0B1tUDhWNTjO-WEZZb2VwOG5vZkU"
  [Jamendo]="0B1tUDhWNTjO-cWpmMWxxQ3Z2eVk"
  [KEGG]="0B1tUDhWNTjO-TUdUcllRMGVJaHM"
  [LMDB]="0B1tUDhWNTjO-bU5VN25NLXZXU0U"
  [NYT]="0B1tUDhWNTjO-dThoTm9DSmY4Wms"
  [SWDFood]="0B1tUDhWNTjO-RjBWZXYyX2FDT1E"
  [Affymetrix]="0B1tUDhWNTjO-eHVlZ1RyVVFJQU0"
)

# -------------------------------------------------------------
# STEP 1: Download RDF dataset archives (if missing)
# -------------------------------------------------------------
section "Downloading RDF dataset archives"
mkdir -p datasets

for dataset in "${!RDF_DATASETS[@]}"; do
  archive=""
  id="${RDF_DATASETS[$dataset]}"
  path="raw_datasets/${dataset}"

  if [[ -f "${path}.zip" ]]; then
    archive="${path}.zip"
  elif [[ -f "${path}.7z" ]]; then
    archive="${path}.7z"
  fi

  if [[ -n "${archive}" ]]; then
    ok "Found ${archive}, skipping"
  else
    info "Downloading ${dataset}..."
    if ./download_dataset.py --id "$id" --output "raw_datasets/"; then
      ok "Downloaded ${dataset}"
    else
      error "Failed to download ${id}"
    fi
  fi
done

# -------------------------------------------------------------
# STEP 2: Extract datasets (if not already extracted)
# -------------------------------------------------------------
section "Extracting RDF datasets"
for dataset in "${!RDF_DATASETS[@]}"; do
  dir="raw_datasets/${dataset}"

  if [[ -d "${dir}" ]]; then
    ok "Directory ${dir} already exists, skipping extraction."
    continue
  fi

  if [[ -f "${dir}.zip" ]]; then
    unzip "${dir}.zip" -d "raw_datasets"
  elif [[ -f "${dir}.7z" ]]; then
    7z x "${dir}.7z" "-oraw_datasets"
  fi
done

# -------------------------------------------------------------
# DONE
# -------------------------------------------------------------
section "All tasks complete"
