#!/bin/bash
set -euo pipefail

# === Input Args ===
REPO_USER="${1:-}"
REPO_NAME="${2:-}"
BRANCH="${3:-master}"
TARGET_DIR="${4:-}"

# === Validation ===
if [[ -z "$REPO_USER" || -z "$REPO_NAME" || -z "$TARGET_DIR" ]]; then
    echo -e "\033[0;31m❌ Usage: $0 <repo_user> <repo_name> [branch] <target_dir>\033[0m"
    echo "   Example: $0 kodekloudhub certified-kubernetes-administrator-course master ./my-folder"
    exit 1
fi

# === Derived Values ===
TMP_DIR=$(mktemp -d)
ZIP_FILE="$TMP_DIR/repo.zip"
REPO_URL="https://github.com/${REPO_USER}/${REPO_NAME}"
ZIP_URL="${REPO_URL}/archive/refs/heads/${BRANCH}.zip"
EXTRACTED_FOLDER="$TMP_DIR/${REPO_NAME}-${BRANCH}"

# === Script ===
echo -e "\033[1;34m📥 Downloading latest commit from $REPO_URL (branch: $BRANCH)...\033[0m"
curl -L "$ZIP_URL" -o "$ZIP_FILE"

if [ ! -s "$ZIP_FILE" ]; then
    echo -e "\033[0;31m❌ Failed to download the repository ZIP.\033[0m"
    exit 1
fi

echo -e "\033[1;34m📦 Unzipping repo...\033[0m"
unzip -q "$ZIP_FILE" -d "$TMP_DIR"

if [ ! -d "$EXTRACTED_FOLDER" ]; then
    echo -e "\033[0;31m❌ Could not find extracted folder at $EXTRACTED_FOLDER.\033[0m"
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "\033[1;33m📁 Target directory '$TARGET_DIR' does not exist. Creating it...\033[0m"
    mkdir -p "$TARGET_DIR"
fi

echo -e "\033[1;34m🧹 Cleaning $TARGET_DIR...\033[0m"
rm -rf "$TARGET_DIR"/*
rm -rf "$TARGET_DIR"/.??* 2>/dev/null || true

echo -e "\033[1;34m📁 Copying fresh content into $TARGET_DIR...\033[0m"
cp -r "$EXTRACTED_FOLDER"/* "$EXTRACTED_FOLDER"/.??* "$TARGET_DIR" 2>/dev/null || true

echo -e "\033[1;34m🧼 Cleaning up temporary files...\033[0m"
rm -rf "$TMP_DIR"

echo -e "\033[1;32m✅ '$TARGET_DIR' has been updated with the latest commit from GitHub!\033[0m"
