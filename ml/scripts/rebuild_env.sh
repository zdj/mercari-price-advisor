#!/usr/bin/env bash
set -euo pipefail

# Rebuild the ML virtualenv with uv and reinstall pinned requirements.
# Usage:
#   scripts/rebuild_env.sh                 # uses requirements.freeze.txt or requirements.txt
#   scripts/rebuild_env.sh --freeze        # freeze current env to requirements.freeze.txt (no reinstall)
#   scripts/rebuild_env.sh --from FILE     # reinstall from FILE
#   scripts/rebuild_env.sh --shap          # also install SHAP/Numba (newer pins)
#   scripts/rebuild_env.sh -h|--help       # help

REQ_FILE=""
DO_FREEZE=0
WITH_SHAP=0

die() { echo "❌ $*" >&2; exit 1; }
has_cmd() { command -v "$1" >/dev/null 2>&1; }

usage() {
  sed -n '2,14p' "$0"
}

# ---- parse args ----
while [[ $# -gt 0 ]]; do
  case "$1" in
    --freeze) DO_FREEZE=1; shift ;;
    --from)   REQ_FILE="${2:-}"; [[ -n "$REQ_FILE" ]] || die "--from needs a file"; shift 2 ;;
    --shap)   WITH_SHAP=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1" ;;
  esac
done

# ---- require we're in the ml/ dir ----
CWD="$(pwd)"
case "$CWD" in
  *us-accident-risk-advisor/ml) : ;;
  *) echo "⚠️  Run this from the ML directory: .../us-accident-risk-advisor/ml";;
esac

# ---- freeze-only mode ----
if [[ "$DO_FREEZE" -eq 1 ]]; then
  echo "📌 Freezing current environment to requirements.freeze.txt"
  uv pip freeze > requirements.freeze.txt
  echo "✅ Wrote requirements.freeze.txt"
  exit 0
fi

# ---- pick requirements file ----
if [[ -z "$REQ_FILE" ]]; then
  if [[ -f requirements.freeze.txt ]]; then
    REQ_FILE="requirements.freeze.txt"
  elif [[ -f requirements.txt ]]; then
    REQ_FILE="requirements.txt"
  else
    die "No requirements file found. Create requirements.txt or requirements.freeze.txt first."
  fi
fi

echo "🧹 Removing existing venv: .venv/"
rm -rf .venv

echo "🐍 Creating fresh Python 3.12 venv"
uv python install 3.12
uv venv --python 3.12

echo "📦 Installing from $REQ_FILE"
uv pip install -r "$REQ_FILE"

# ---- macOS OpenMP for LightGBM ----
if [[ "$(uname -s)" == "Darwin" ]]; then
  if has_cmd brew; then
    if [[ ! -f /opt/homebrew/opt/libomp/lib/libomp.dylib && ! -f /usr/local/opt/libomp/lib/libomp.dylib ]]; then
      echo "🍺 Installing libomp (OpenMP runtime) via Homebrew"
      brew install libomp || true
    fi
    # Prefer arm64 Homebrew prefix
    if [[ -f /opt/homebrew/opt/libomp/lib/libomp.dylib ]]; then
      export DYLD_LIBRARY_PATH="/opt/homebrew/opt/libomp/lib:${DYLD_LIBRARY_PATH:-}"
    elif [[ -f /usr/local/opt/libomp/lib/libomp.dylib ]]; then
      export DYLD_LIBRARY_PATH="/usr/local/opt/libomp/lib:${DYLD_LIBRARY_PATH:-}"
    fi
  fi
fi

echo "WITH_SHAP $WITH_SHAP"

# ---- optional SHAP stack (wheel-friendly pins) ----
if [[ "$WITH_SHAP" -eq 1 ]]; then
  echo "🧠 Installing SHAP/Numba (llvmlite/numba/shap) with arm64-friendly pins"
  uv pip uninstall shap numba llvmlite || true
  uv pip install llvmlite==0.43.0
  uv pip install numba==0.60.0
  uv pip install shap==0.44.1
fi

echo "🧪 Verifying core imports..."
uv run python - <<'PY'
import fastapi, numpy, pandas, sklearn, lightgbm
print("✅ core ok")
PY

if [[ "$WITH_SHAP" -eq 1 ]]; then
  echo "🧪 Verifying SHAP imports..."
  uv run python - <<'PY'
import shap, numba, llvmlite
print("✅ shap ok")
PY
fi

echo "🎉 Done. Examples:"
echo "  env PYTHONPATH=src uv run python -c \"from train import main; main('data/accidents_sample.csv')\""
echo "  env PYTHONPATH=src uv run uvicorn app:app --host 0.0.0.0 --port 8001"