#!/bin/bash

set -e

echo "🚀 Installing AI Git System (Ollama + Qwen3.5 + Hooks)..."

HOOK_DIR=".githooks"
HOOK_FILE="$HOOK_DIR/prepare-commit-msg"

LATEST_TAG=$(curl -s https://api.github.com/repos/WPConstructor/ai-git/tags \
  | grep '"name"' \
  | head -n 1 \
  | cut -d '"' -f4)

REPO_URL="https://raw.githubusercontent.com/WPConstructor/ai-git/$LATEST_TAG/.githooks/prepare-commit-msg"

# -------------------------
# 0. Check Git repository
# -------------------------
if [ ! -d ".git" ]; then
  echo "❌ Git is not initialized in this directory."
  echo "Please run git init and rerun the installer."
  exit 1
fi

# -------------------------
# 1. Install Ollama
# -------------------------
if ! ollama --version >/dev/null 2>&1; then
  echo "📦 Installing Ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
else
  echo "✅ Ollama already installed"
fi

# -------------------------
# 2. Pull Qwen2.5-coder:7b
# -------------------------
if ! ollama list | grep -q '^qwen2.5-coder:7b'; then
    echo "🤖 Pulling qwen2.5-coder:7b..."
    ollama pull qwen2.5-coder:7b
else
    echo "✅ qwen2.5-coder:7b already installed"
fi

# -------------------------
# 3. Create git hooks directory
# -------------------------
echo "📁 Creating .githooks directory..."
mkdir -p "$HOOK_DIR"

# -------------------------
# 4. Hook install logic
# -------------------------
if [ -f "$HOOK_FILE" ]; then
    echo "⚠️ Hook already exists: $HOOK_FILE"

    printf "Overwrite with latest version from GitHub? (y/N): " > /dev/tty
    read answer < /dev/tty

    case "$answer" in
        y|Y)
            echo "⬇️ Overwriting hook..."
            curl -fsSL "$REPO_URL" -o "$HOOK_FILE"
            ;;
        *)
            echo "⏭️ Keeping existing hook"
            ;;
    esac
else
    echo "⬇️ Installing hook (not found locally)..."
    curl -fsSL "$REPO_URL" -o "$HOOK_FILE"
fi

# -------------------------
# 5. Make hook executable
# -------------------------
echo "🔧 Making hook executable..."
chmod +x "$HOOK_FILE"

# -------------------------
# 6. Enable git hooks path
# -------------------------
echo "⚙️ Configuring git hooks path..."
git config core.hooksPath .githooks

# -------------------------
# DONE
# -------------------------
echo ""
echo "✅ Installation complete!"
echo ""
echo "📌 What was installed:"
echo "   ✔ Ollama"
echo "   ✔ Qwen2.5-Coder 7B"
echo "   ✔ Git AI Hook"
echo ""
echo "👉 Usage:"
echo "   git add -A"
echo "   git commit -m \"\""
echo "" 
echo "🤖 AI will now assist your commits!"