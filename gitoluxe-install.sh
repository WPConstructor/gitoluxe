#!/bin/bash

#
# Gitoluxe - AI-powered Conventional Commit Message Generator
#
# Copyright (c) 2026 WPConstructor
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see:
#
# https://www.gnu.org/licenses/
#

set -e

# --------------------------------------------------
# Paths
# --------------------------------------------------

GITOLUXE_DIR="$HOME/gitoluxe"
HOOKS_DIR="$GITOLUXE_DIR/hooks"
CONFIG_FILE="$GITOLUXE_DIR/gitoluxe.config.env"
CONFIG_SCRIPT="$GITOLUXE_DIR/gitoluxe.config.sh"
HOOK_FILE="$HOOKS_DIR/prepare-commit-msg"

# --------------------------------------------------
# Helpers
# --------------------------------------------------

config_get()
{
    key="$1"
    default="$2"

    value=""

    if [ -f "$CONFIG_FILE" ]; then
        value=$(grep "^${key}=" "$CONFIG_FILE" | cut -d '=' -f2-)
    fi

    if [ -n "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}

ensure_jq()
{
    if command -v jq >/dev/null 2>&1; then
        return 0
    fi

    echo "jq is not installed."
    echo "Installing jq..."

    if ! sudo apt update || ! sudo apt install -y jq; then
        echo "Failed to install jq."
        return 1
    fi

    if ! command -v jq >/dev/null 2>&1; then
        echo "jq installation verification failed."
        return 1
    fi

    echo "✓ jq installed successfully."
}

# --------------------------------------------------
# Resolve latest tag from GitHub
# --------------------------------------------------

echo "🔍 Fetching latest Gitoluxe release tag..."

LATEST_TAG=$(curl -s https://api.github.com/repos/WPConstructor/gitoluxe/tags \
  | grep '"name"' \
  | head -n 1 \
  | cut -d '"' -f4)

if [ -z "$LATEST_TAG" ]; then
    echo "❌ Could not determine the latest tag from GitHub."
    exit 1
fi

echo "   Latest tag: $LATEST_TAG"

# ==================================================
# 1. Create $HOME/gitoluxe directory
# ==================================================

echo ""
echo "📁 Ensuring $GITOLUXE_DIR exists..."
mkdir -p "$GITOLUXE_DIR"
echo "   ✔ $GITOLUXE_DIR"

# ==================================================
# 2. Download gitoluxe.config.sh (if not present)
# ==================================================

REPO_CONFIG_URL="https://raw.githubusercontent.com/WPConstructor/gitoluxe/$LATEST_TAG/gitoluxe.config.sh"

if [ ! -f "$CONFIG_SCRIPT" ]; then
    echo ""
    echo "⬇️  Downloading gitoluxe.config.sh..."
    curl -fsSL "$REPO_CONFIG_URL" -o "$CONFIG_SCRIPT"
    chmod +x "$CONFIG_SCRIPT"
    echo "   ✔ Saved to $CONFIG_SCRIPT"
else
    echo ""
    echo "✅ gitoluxe.config.sh already exists"
fi

# ==================================================
# 3. Install Ollama (if not installed)
# ==================================================

echo ""
if ! command -v ollama &>/dev/null; then
    echo "📦 Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
else
    echo "✅ Ollama already installed"
fi

ensure_jq

# ==================================================
# 4. Run configuration wizard (if env not present)
# ==================================================

if [ ! -f "$CONFIG_FILE" ]; then
    echo ""
    echo "⚙️  Running Gitoluxe configuration wizard..."
    bash "$CONFIG_SCRIPT"
else
    echo ""
    echo "✅ Configuration already set ($CONFIG_FILE)"
fi

# ==================================================
# 5. Pull configured model (if not installed)
# ==================================================

MODEL=$(config_get "MODEL" "qwen3:4b")

echo ""
if ! ollama list | grep -q "^${MODEL}"; then
    echo "🤖 Pulling model ${MODEL}..."
    ollama pull "$MODEL"
else
    echo "✅ Model ${MODEL} already installed"
fi

# ==================================================
# 6. Create hooks directory
# ==================================================

echo ""
echo "📁 Ensuring $HOOKS_DIR exists..."
mkdir -p "$HOOKS_DIR"
echo "   ✔ $HOOKS_DIR"

# ==================================================
# 7. Download prepare-commit-msg hook
# ==================================================

REPO_HOOK_URL="https://raw.githubusercontent.com/WPConstructor/gitoluxe/$LATEST_TAG/hooks/prepare-commit-msg"

echo ""
if [ -f "$HOOK_FILE" ]; then
    echo "⚠️  Hook already exists: $HOOK_FILE"

    printf "Overwrite with latest version from GitHub? (y/N): " > /dev/tty
    read answer < /dev/tty

    case "$answer" in
        y|Y)
            echo "⬇️  Overwriting hook..."
            curl -fsSL "$REPO_HOOK_URL" -o "$HOOK_FILE"
            ;;
        *)
            echo "⏭️  Keeping existing hook"
            ;;
    esac
else
    echo "⬇️  Downloading prepare-commit-msg hook..."
    curl -fsSL "$REPO_HOOK_URL" -o "$HOOK_FILE"
    echo "   ✔ Saved to $HOOK_FILE"
fi

# ==================================================
# 8. Make hook executable
# ==================================================

echo ""
echo "🔧 Making hook executable..."
chmod +x "$HOOK_FILE"
echo "   ✔ $HOOK_FILE"

# ==================================================
# 9. Set global git hooks path
# ==================================================

echo ""
echo "⚙️  Setting global git hooks path..."
git config --global core.hooksPath "$HOOKS_DIR"
echo "   ✔ core.hooksPath = $HOOKS_DIR"

# ==================================================
# Done
# ==================================================

echo ""
echo "═══════════════════════════════════════════════"
echo "  ✅  Gitoluxe installation complete!"
echo "═══════════════════════════════════════════════"
echo ""
echo "📌 What was installed:"
echo "   ✔ Ollama"
echo "   ✔ Model ($MODEL)"
echo "   ✔ Git hook (prepare-commit-msg)"
echo "   ✔ Global hooks path set to $HOOKS_DIR"
echo ""
echo "📂 Install location: $GITOLUXE_DIR"
echo ""
echo "👉 Usage:"
echo "   Gitoluxe works automatically with every git commit."
echo "   Simply stage your changes and commit with an empty message:"
echo ""
echo "     git add -A"
echo "     git commit -m \"\""
echo ""
echo "   The AI hook will analyse your staged diff and generate"
echo "   a meaningful commit message for you."
echo ""
echo "   To reconfigure Gitoluxe:"
echo "     bash $CONFIG_SCRIPT"
echo ""
echo "🤖 AI will now assist your commits!"