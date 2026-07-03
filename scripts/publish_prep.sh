#!/usr/bin/env bash

set -euo pipefail

# ANSI Color Codes
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ۱. بررسی اینکه آیا کاربر مسیر پوشه را وارد کرده است یا خیر
if [ $# -eq 0 ]; then
    log_error "Please provide the package directory path."
    echo -e "Usage: $0 <package-directory>"
    echo -e "Example: $0 ./resultex  or  $0 ./resultex_network"
    exit 1
fi

TARGET_DIR="$1"

# ۲. بررسی وجود داشتن پوشه معرفی شده
if [ ! -d "$TARGET_DIR" ]; then
    log_error "Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# ۳. رفتن به پوشه هدف
cd "$TARGET_DIR"

# ۴. بررسی اینکه آیا این پوشه واقعاً یک پروژه دارت/فلاتر است (بررسی وجود pubspec.yaml)
if [ ! -f "pubspec.yaml" ]; then
    log_error "No 'pubspec.yaml' found in '$TARGET_DIR'. This is not a Dart/Flutter package."
    exit 1
fi

echo -e "${BLUE}============================================"
echo -e "   Target Package: $(basename "$(pwd)")"
echo -e "============================================${NC}\n"

# Step 1: Format
log_info "Step 1: Formatting code..."
dart format .

echo ""

# Step 2: Analyze
log_info "Step 2: Analyzing code..."
flutter analyze

echo ""

# Step 3: Pana
log_info "Step 3: Running pana analyzer..."
pana .

# Step 4: Dry-run
log_info "Step 4: Running publish dry-run..."
flutter pub publish --dry-run

echo ""
log_success "🚀 All checks passed successfully for $(basename "$(pwd)")!"