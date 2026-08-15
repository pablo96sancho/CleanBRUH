#!/bin/bash
# Compila CleanBRUH en modo release y genera CleanBRUH-Installer.dmg
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

APP_NAME="CleanBRUH"
DMG_NAME="CleanBRUH-Installer.dmg"
STAGING_DIR="$ROOT_DIR/.build/dmg-staging"

echo "🔨 Compilando CleanBRUH (release)..."
swift build -c release

APP_BUNDLE=$("$ROOT_DIR/scripts/bundle_app.sh" release | tail -n 1)

echo "🗂  Preparando contenido del DMG..."
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"
cp -R "$APP_BUNDLE" "$STAGING_DIR/$APP_NAME.app"
ln -s /Applications "$STAGING_DIR/Applications"

rm -f "$ROOT_DIR/$DMG_NAME"

echo "💿 Creando $DMG_NAME..."
hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "$STAGING_DIR" \
    -ov -format UDZO \
    "$ROOT_DIR/$DMG_NAME"

rm -rf "$STAGING_DIR"
echo "✅ Instalador creado: $ROOT_DIR/$DMG_NAME"
