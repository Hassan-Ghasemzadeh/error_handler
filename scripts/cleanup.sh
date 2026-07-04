#!/usr/bin/env bash

set -euo pipefail

# ANSI Color Codes for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🧹 Cleaning up Flutter project environment...${NC}\n"

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