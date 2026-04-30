#!/usr/bin/env bash
# export-mrpack.sh
# ─────────────────────────────────────────────────────────────────────────────
# Runs `packwiz modrinth export` inside the packwiz/ directory and
# normalises the output filename to `velvet-horizon.mrpack`.
#
# Called by:
#   - .github/workflows/publish-pack.yml  (publish-mrpack job)
#   - .github/workflows/publish-pack.yml  (publish-pages job)
#
# Requirements:
#   - packwiz binary must already be on $PATH
#   - cwd must be the repo root
#
# Output:
#   packwiz/velvet-horizon.mrpack
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PACK_DIR="$REPO_ROOT/packwiz"

echo "==> Entering packwiz directory: $PACK_DIR"
cd "$PACK_DIR"

# ── Validate pack.toml exists ─────────────────────────────────────────────
if [[ ! -f "pack.toml" ]]; then
  echo "ERROR: pack.toml not found in $PACK_DIR" >&2
  exit 1
fi

# ── Read pack metadata ────────────────────────────────────────────────────
PACK_NAME=$(grep -m1 '^name\s*=' pack.toml \
  | sed 's/.*=\s*"\(.*\)"/\1/' | tr -d '[:space:]')
PACK_VERSION=$(grep -m1 '^version\s*=' pack.toml \
  | sed 's/.*=\s*"\(.*\)"/\1/' | tr -d '[:space:]')

echo "==> Pack: $PACK_NAME  version: $PACK_VERSION"

# ── Run packwiz export ────────────────────────────────────────────────────
echo "==> Running: packwiz modrinth export"
packwiz modrinth export

# ── Locate the generated .mrpack ─────────────────────────────────────────
# packwiz names the file after the pack name (spaces → underscores) + version
# e.g. "Velvet_Horizon-1.0.0.mrpack" or "Velvet Horizon-1.0.0.mrpack"
# We find any .mrpack and normalise it.
GENERATED=$(find . -maxdepth 1 -name "*.mrpack" | head -1)

if [[ -z "$GENERATED" ]]; then
  echo "ERROR: No .mrpack file found after export in $PACK_DIR" >&2
  exit 1
fi

CANONICAL="velvet-horizon.mrpack"

if [[ "$GENERATED" != "./$CANONICAL" ]]; then
  echo "==> Renaming '$GENERATED' -> '$CANONICAL'"
  mv "$GENERATED" "$CANONICAL"
fi

echo "==> Export complete: $PACK_DIR/$CANONICAL"
ls -lh "$CANONICAL"
