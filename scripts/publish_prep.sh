#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status,
# and treat unset variables as an error.
set -euo pipefail

# ANSI Color Codes for beautiful terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo -e "${BLUE}============================================"
echo -e "   Resultex Package Pre-Publish Validator   "
echo -e "============================================${NC}\n"

# Step 1: Format Dart Code
log_info "Step 1: Formatting code formatting using 'dart format'..."
if dart format . ; then
    log_success "Code formatting completed successfully."
else
    log_error "Code formatting failed. Please check your files."
    exit 1
fi

echo ""

# Step 2: Analyze Flutter Project
log_info "Step 2: Analyzing code semantics using 'flutter analyze'..."
if flutter analyze ; then
    log_success "No issues found! Code analysis passed cleanly."
else
    log_error "Flutter analysis found errors or warnings. Fix them before publishing."
    exit 1
fi

echo ""

# Step 3: Run pana analyzer
log_info "Step 3: Running package publishing dry-run..."
if flutter pana . ; then
    log_success "pana passed! flutter pub analyzer didn't saw any problem."
    echo -e "\n${GREEN}🚀 All checks passed successfully! You are safe to publish.${NC}"
else
    log_error "Pana saw afew problems. check and fix it before publish"
    exit 1
fi

# Step 4: Run Pub Publish Dry-Run
log_info "Step 3: Running package publishing dry-run..."
if flutter pub publish --dry-run ; then
    log_success "Dry-run passed! The package is structurally ready for Pub.dev."
    echo -e "\n${GREEN}🚀 All checks passed successfully! You are safe to publish.${NC}"
else
    log_error "Publish dry-run failed. Review the warnings above."
    exit 1
fi