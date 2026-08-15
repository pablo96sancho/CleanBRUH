#!/bin/bash
# Empaqueta el ejecutable compilado en un .app válido de macOS.
# Uso: scripts/bundle_app.sh <debug|release>
set -euo pipefail

CONFIGURATION="${1:-debug}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="CleanBRUH"
BUILD_DIR="$ROOT_DIR/.build/$CONFIGURATION"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
BIN_PATH="$BUILD_DIR/$APP_NAME"

if [ ! -f "$BIN_PATH" ]; then
    echo "❌ No se encontró el binario compilado en: $BIN_PATH" >&2
    exit 1
fi

echo "📦 Empaquetando $APP_NAME.app ($CONFIGURATION)..." >&2

rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

cp "$BIN_PATH" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"
cp "$ROOT_DIR/Sources/CleanBRUH/Resources/Info.plist" "$APP_BUNDLE/Contents/Info.plist"

if [ -f "$ROOT_DIR/Sources/CleanBRUH/Resources/AppIcon.icns" ]; then
    cp "$ROOT_DIR/Sources/CleanBRUH/Resources/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/AppIcon.icns"
fi

# Firma ad-hoc: hace que TCC (permisos de Accesibilidad) reconozca el
# bundle de forma consistente entre ejecuciones.
codesign --force --deep --sign - "$APP_BUNDLE"

echo "✅ Bundle creado en: $APP_BUNDLE" >&2
echo "$APP_BUNDLE"
