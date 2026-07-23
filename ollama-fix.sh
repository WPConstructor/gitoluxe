#!/bin/bash

set -e

SOURCE="$HOME/ollama/models"
TARGET="$HOME/.ollama/models"
BACKUP="$HOME/.ollama/models.backup"

echo "================================="
echo " Ollama model symlink setup"
echo "================================="
echo

# Check source exists
if [ ! -d "$SOURCE" ]; then
    echo "ERROR: Source directory does not exist:"
    echo "$SOURCE"
    exit 1
fi

echo "Stopping Ollama service..."
sudo systemctl stop ollama 2>/dev/null || true

echo

# Create .ollama directory
mkdir -p "$HOME/.ollama"

# Backup existing target if it is not a symlink
if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "Backing up existing Ollama models:"
    echo "$TARGET -> $BACKUP"

    mv "$TARGET" "$BACKUP"
fi

# Remove old symlink if exists
if [ -L "$TARGET" ]; then
    echo "Removing old symlink..."
    rm "$TARGET"
fi

echo
echo "Copying models..."

# Copy only if target is not already the source
if [ ! -e "$TARGET" ]; then
    mkdir -p "$TARGET"
fi

# Actually use rsync if available
if command -v rsync >/dev/null 2>&1; then
    rsync -avh --progress "$SOURCE/" "$TARGET/"
else
    cp -av "$SOURCE/"* "$TARGET/"
fi

echo

# Remove copied directory and create symlink
rm -rf "$TARGET"

ln -s "$SOURCE" "$TARGET"

echo "Created symlink:"
ls -la "$TARGET"

echo

# Fix ownership
sudo chown -R "$(whoami)":"$(whoami)" "$SOURCE"

echo "Starting Ollama..."
sudo systemctl start ollama 2>/dev/null || true

echo
echo "Done."
echo
echo "Check:"
echo "  ls -la ~/.ollama"
echo "  ollama list"