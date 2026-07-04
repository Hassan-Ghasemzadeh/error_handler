#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🧹 Cleaning up Flutter project environment...${NC}\n"

# حذف فایل‌ها و پوشه‌های بیلد و کش
echo -e "-> Running flutter clean..."
flutter clean > /dev/null

echo -e "-> Deleting redundant caches..."
rm -rf .dart_tool
rm -rf coverage

# گرفتن تمیز و مجدد پکیج‌ها
echo -e "-> Fetching fresh dependencies..."
flutter pub get > /dev/null

echo -e "\n${GREEN}✨ Project environment successfully re-indexed and cleaned!${NC}"