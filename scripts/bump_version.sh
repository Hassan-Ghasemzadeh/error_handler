#!/bin/bash

# Smart Argument Parsing
# If the first argument is a directory, use it as TARGET_DIR
if [ -d "$1" ]; then
    TARGET_DIR="$1"
    NEW_VERSION="$2"
# If the first argument looks like a version, assume current directory
elif [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    TARGET_DIR="."
    NEW_VERSION="$1"
else
    TARGET_DIR="$1"
    NEW_VERSION="$2"
fi

# Prompt for Directory if not provided or invalid
if [ -z "$TARGET_DIR" ]; then
    read -p "📂 Enter the package directory path (Press Enter for current directory): " INPUT_DIR
    TARGET_DIR="${INPUT_DIR:-.}"
fi

# Verify if the target directory actually exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Directory '$TARGET_DIR' does not exist!"
    exit 1
fi

# Move to the target package directory safely
cd "$TARGET_DIR" || exit 1
echo "📍 Target Package: $(pwd)"

# Check if pubspec.yaml exists in the target directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found in $(pwd)!"
    exit 1
fi

# Prompt for Version if not provided
if [ -z "$NEW_VERSION" ]; then
    read -p "🔹 Enter the new version (e.g., 2.6.1): " NEW_VERSION
fi

# Validate SemVer format (X.Y.Z)
if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    echo "❌ Error: Invalid version format ($NEW_VERSION). Please use SemVer (e.g., 2.6.1)."
    exit 1
fi

# Extract the current version for replacement
OLD_VERSION=$(grep "^version:" pubspec.yaml | awk '{print $2}')

echo "🔄 Bumping version from $OLD_VERSION to $NEW_VERSION..."

# 1. Update pubspec.yaml
sed -i "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml
echo "✅ Updated pubspec.yaml"

# 2. Update CHANGELOG.md if it exists
if [ -f "CHANGELOG.md" ]; then
    sed -i "s/$OLD_VERSION/$NEW_VERSION/g" CHANGELOG.md
    echo "📝 Updated CHANGELOG.md headings"
else
    echo "⚠️ CHANGELOG.md not found, skipping..."
fi

# 3. Refresh dependencies inside the target directory
echo "⚡ Running 'flutter pub get'..."
flutter pub get

echo "🎉 Successfully upgraded package to version $NEW_VERSION!"