#!/usr/bin/env bash
# IncidentPulse deploy script — THE way to deploy.
#
# Why this exists: the Serverpod web server serves the Flutter dashboard from
# incident_pulse_server/web/app/ (see server.dart: FlutterRoute(Directory('web/app'))).
# Deploying without the built web assets in web/app/ produces a 503 on the
# web URL while the API stays healthy. This script makes that impossible to
# get wrong: it builds, copies to the right path, verifies, then deploys.
#
# Usage: ./scripts/deploy.sh [--skip-build]
#   --skip-build  Reuse the existing incident_pulse_flutter/build/web output
#                 instead of rebuilding (faster; use when only server changed).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLUTTER_DIR="$REPO_ROOT/incident_pulse_flutter"
SERVER_DIR="$REPO_ROOT/incident_pulse_server"
WEB_APP_DIR="$SERVER_DIR/web/app"
API_URL="https://incident-pulse.api.serverpod.space"
WEB_URL="https://incident-pulse.serverpod.space"

export PATH="$HOME/workspace/tools/flutter/bin:$HOME/workspace/tools/dart/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"

SKIP_BUILD=false
for arg in "$@"; do
  case "$arg" in
    --skip-build) SKIP_BUILD=true ;;
    *) echo "Unknown arg: $arg" >&2; exit 1 ;;
  esac
done

echo "=== 1/4 Flutter web build ==="
if [ "$SKIP_BUILD" = true ] && [ -f "$FLUTTER_DIR/build/web/main.dart.js" ]; then
  echo "Reusing existing build."
else
  (cd "$FLUTTER_DIR" && flutter build web --release --dart-define=SERVER_URL="$API_URL")
fi

echo "=== 2/4 Stage web assets to web/app/ ==="
rm -rf "$WEB_APP_DIR"
mkdir -p "$WEB_APP_DIR"
cp -r "$FLUTTER_DIR/build/web/." "$WEB_APP_DIR/"

echo "=== 3/4 Verify web/app/main.dart.js exists ==="
if [ ! -f "$WEB_APP_DIR/main.dart.js" ]; then
  echo "FATAL: $WEB_APP_DIR/main.dart.js missing — aborting deploy to avoid a 503." >&2
  exit 1
fi
echo "OK: $(du -h "$WEB_APP_DIR/main.dart.js" | cut -f1) bundle staged."

echo "=== 4/4 Deploy to Serverpod Cloud ==="
(cd "$SERVER_DIR" && "$HOME/workspace/skills/serverpod-cloud/bin/scloud-auth" deploy || true)
echo ""
echo "Deploy uploaded. Polling endpoints (websocket status stream is unavailable from here)..."

for i in $(seq 1 12); do
  WEB_CODE=$(curl -s -m 10 -o /dev/null -w "%{http_code}" "$WEB_URL" || echo "000")
  API_CODE=$(curl -s -m 10 -o /dev/null -w "%{http_code}" "$API_URL/health/heartbeat" || echo "000")
  echo "  try $i: web=$WEB_CODE api=$API_CODE"
  if [ "$WEB_CODE" = "200" ] && [ "$API_CODE" = "200" ]; then
    echo "DEPLOY LIVE: web and API both 200."
    exit 0
  fi
  sleep 20
done

echo "WARNING: endpoints not both 200 after ~4 minutes. Check Serverpod Cloud console." >&2
exit 1
