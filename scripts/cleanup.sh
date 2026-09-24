#!/usr/bin/env bash

set -euo pipefail

# ANSI Color Codes for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Determine target directory (Use $1 if provided, otherwise the folder where this script lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$SCRIPT_DIR}"

# Navigate to the target directory
cd "$TARGET_DIR"

# Verify that pubspec.yaml exists in the target directory
if [[ ! -f "pubspec.yaml" ]]; then
  echo -e "${RED}❌ Error: 'pubspec.yaml' was not found in: $TARGET_DIR${NC}" >&2
  exit 1
fi

echo -e "${BLUE}🧹 Cleaning up Flutter project environment in: ${TARGET_DIR}${NC}\n"

# Delete dynamic build artifacts and project-specific generated files
echo -e "-> Running flutter clean..."
flutter clean > /dev/null

echo -e "-> Deleting redundant caches..."
rm -rf .dart_tool
rm -rf coverage

# Fetch fresh dependencies and re-index the package ecosystem
echo -e "-> Fetching fresh dependencies..."
flutter pub get > /dev/null

echo -e "\n${GREEN}✨ Project environment successfully re-indexed and cleaned!${NC}"