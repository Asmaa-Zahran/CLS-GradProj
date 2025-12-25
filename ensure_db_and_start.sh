#!/usr/bin/env bash
set -euo pipefail

# Path to the helper script inside container
ENSURE_PY="/app/docker/ensure_db.py"

echo "[entrypoint] DATABASE_URL=${DATABASE_URL:-<not-set>}"

if [ -f "$ENSURE_PY" ]; then
  echo "[entrypoint] Ensuring target DB exists..."
  python3 "$ENSURE_PY" "$DATABASE_URL"
else
  echo "[entrypoint] ensure_db.py not found at $ENSURE_PY - skipping DB create step"
fi

echo "[entrypoint] Running migrations..."
if [ -f /app/run_migrations.py ]; then
  python3 /app/run_migrations.py
else
  echo "[entrypoint] run_migrations.py not found - skipping"
fi

echo "[entrypoint] Seeding database..."
if [ -f /app/seed_data.py ]; then
  python3 /app/seed_data.py
else
  echo "[entrypoint] seed_data.py not found - skipping"
fi

echo "[entrypoint] Starting Gunicorn..."
exec gunicorn --bind 0.0.0.0:5000 --workers 4 --timeout 120 --access-logfile - --error-logfile - app:app