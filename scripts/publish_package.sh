#!/usr/bin/env bash

# Exit immediately if any command fails
set -euo pipefail

# ANSI Color Codes
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# ۱. بررسی ورود آدرس پوشه
if [ $# -eq 0 ]; then
    log_error "Please provide the package directory path."
    echo -e "Usage: $0 <package-directory>"
    echo -e "Example: $0 ./resultex"
    exit 1
fi

TARGET_DIR="$1"

# ۲. بررسی وجود پوشه
if [ ! -d "$TARGET_DIR" ]; then
    log_error "Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# ۳. ورود به پوشه هدف
cd "$TARGET_DIR"

# ۴. بررسی وجود pubspec.yaml
if [ ! -f "pubspec.yaml" ]; then
    log_error "No 'pubspec.yaml' found in '$TARGET_DIR'. Cannot publish."
    exit 1
fi

PACKAGE_NAME=$(basename "$(pwd)")

echo -e "${YELLOW}============================================="
echo -e "   CRITICAL: PREPARED TO PUBLISH TO PUB.DEV  "
echo -e "   Target Package: $PACKAGE_NAME             "
echo -e "=============================================${NC}\n"

# مرحله دوم: گرفتن تاییدیه چشمی و فیزیکی از توسعه‌دهنده
log_warning "🔥 WARNING: You are about to publish '$PACKAGE_NAME' LIVE to pub.dev."
read -p "Are you absolutely sure you want to proceed? (yes/no): " CONFIRMATION

if [ "$CONFIRMATION" != "yes" ]; then
    log_info "Publishing aborted by user. Safe and sound!"
    exit 0
fi

echo ""
log_info "🚀 Launching final deployment chain..."

# مرحله سوم: انتشار نهایی بدون پرسش مجدد فلاتر (چون قبلاً خودمان تاییدیه گرفتیم)
if flutter pub publish --force; then
    echo ""
    log_success "🎉 SUCCESS! '$PACKAGE_NAME' has been successfully published to pub.dev!"
else
    echo ""
    log_error "❌ Deployment failed. Check the network status or credentials."
    exit 1
fi