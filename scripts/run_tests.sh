#!/usr/bin/env bash

set -euo pipefail

# ANSI Color Codes for clean terminal feedback
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🧪 Running Resultex Test Suite with Coverage...${NC}\n"

# Run all unit tests and generate the localized lcov.info coverage report
if flutter test --coverage; then
    echo -e "\n${GREEN}✅ All tests passed successfully!${NC}"

    # Check if 'lcov' (specifically genhtml) is installed on the host system to generate HTML graphics
    if command -v genhtml &> /dev/null; then
        echo -e "${BLUE}📊 Generating HTML coverage report...${NC}"
        genhtml coverage/lcov.info -o coverage/html
        echo -e "${GREEN}✨ Report generated at: coverage/html/index.html${NC}"
    else
        echo -e "\n[INFO] Install 'lcov' to generate dynamic HTML coverage reports."
    fi
else
    echo -e "\n${RED}❌ Some tests failed. Please fix them before committing.${NC}"
    exit 1
fi