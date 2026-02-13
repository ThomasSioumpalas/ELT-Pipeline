#!/usr/bin/env bash
set -euo pipefail

missing=0

check_cmd() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    echo "✅ Found $name: $(command -v "$name")"
  else
    echo "❌ Missing $name"
    missing=1
  fi
}

echo "Checking local prerequisites for Astro project..."

check_cmd docker

if command -v docker >/dev/null 2>&1; then
  if docker compose version >/dev/null 2>&1; then
    echo "✅ Docker Compose plugin is available"
  else
    echo "❌ Docker Compose plugin is missing (docker compose ...)"
    missing=1
  fi
fi

check_cmd astro

if [[ "$missing" -eq 1 ]]; then
  cat <<'EOF'

One or more prerequisites are missing.

Install guides:
- Docker: https://docs.docker.com/get-docker/
- Astro CLI: https://www.astronomer.io/docs/astro/cli/install-cli

After install, run:
  astro dev start
EOF
  exit 1
fi

echo "All prerequisites are present. You can run: astro dev start"