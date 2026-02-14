#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is not installed or not available in PATH"
  exit 1
fi

# Finds local Astro postgres container and prints host->container mapping.
container_id="$(docker ps --filter 'name=postgres' --format '{{.ID}}' | head -n 1)"

if [[ -z "${container_id}" ]]; then
  echo "No running postgres container found. Start runtime first: astro dev start"
  exit 1
fi

echo "Postgres container: ${container_id}"
docker ps --filter "id=${container_id}" --format 'Ports: {{.Ports}}'

echo "Inspecting postgres readiness..."
docker exec "${container_id}" pg_isready -U "${POSTGRES_USER:-postgres}" -d "${POSTGRES_DB:-postgres}"