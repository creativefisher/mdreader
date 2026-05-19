#!/usr/bin/env bash
set -euo pipefail

CONFIGURATION="${1:-release}"
BUILD_DIR=".build/${CONFIGURATION}"
APP_DIR="${BUILD_DIR}/MarkdownReader.app"
CONTENTS_DIR="${APP_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"

swift build -c "${CONFIGURATION}"

rm -rf "${APP_DIR}"
mkdir -p "${MACOS_DIR}"
cp "${BUILD_DIR}/MarkdownReader" "${MACOS_DIR}/MarkdownReader"
cp "Resources/Info.plist" "${CONTENTS_DIR}/Info.plist"

chmod +x "${MACOS_DIR}/MarkdownReader"

echo "Created ${APP_DIR}"
