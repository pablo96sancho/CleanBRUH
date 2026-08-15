#!/bin/bash
# Compila CleanBRUH en modo debug, lo empaqueta como .app y lo ejecuta.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "🔨 Compilando CleanBRUH (debug)..."
swift build

APP_BUNDLE=$("$ROOT_DIR/scripts/bundle_app.sh" debug | tail -n 1)

echo "🚀 Lanzando $APP_BUNDLE..."
open "$APP_BUNDLE"
