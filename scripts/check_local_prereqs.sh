#!/usr/bin/env bash
set -euo pipefail

check_cmd() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    echo "[OK] $name: $("$name" --version 2>/dev/null | head -n 1)"
  else
    echo "[MISSING] $name"
    return 1
  fi
}

status=0
check_cmd docker || status=1

if docker compose version >/dev/null 2>&1; then
  echo "[OK] docker compose: $(docker compose version | head -n 1)"
else
  echo "[MISSING] docker compose"
  status=1
fi

if command -v astro >/dev/null 2>&1; then
  echo "[OK] astro: $(astro version | head -n 1)"
else
  echo "[MISSING] astro"
  status=1
fi

exit $status