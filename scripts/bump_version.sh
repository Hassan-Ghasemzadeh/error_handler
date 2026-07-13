#!/bin/bash

# Ensure pubspec.yaml exists in the current directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found in this directory!"
    exit 1
fi

# Get the new version from the argument, or prompt if empty
NEW_VERSION=$1
if [ -z "$NEW_VERSION" ]; then
    read -p "🔹 Enter the new version (e.g., 2.6.1): " NEW_VERSION
fi

# Validate SemVer format (X.Y.Z)
if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    echo "❌ Error: Invalid version format. Please use Semantic Versioning (e.g., 2.6.1)."
    exit 1
fi

# Extract the current version for logging and replacement
OLD_VERSION=$(grep "^version:" pubspec.yaml | awk '{print $2}')

echo "🔄 Bumping version from $OLD_VERSION to $NEW_VERSION..."

# 1. Update pubspec.yaml (Using GNU sed syntax for Fedora)
sed -i "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml
echo "✅ Updated pubspec.yaml"

# 2. Update CHANGELOG.md if it exists
if [ -f "CHANGELOG.md" ]; then
    # Replaces all occurrences of the old version with the new one (e.g., [2.6.0] -> [2.6.1])
    sed -i "s/$OLD_VERSION/$NEW_VERSION/g" CHANGELOG.md
    echo "📝 Updated CHANGELOG.md headings"
else
    echo "⚠️ CHANGELOG.md not found, skipping..."
fi

# 3. Refresh dependencies
echo "⚡ Running 'flutter pub get'..."
flutter pub get

echo "🎉 Successfully upgraded to version $NEW_VERSION!"