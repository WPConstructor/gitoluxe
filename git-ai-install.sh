#!/bin/bash

set -e

echo "🚀 Installing AI Git System (Ollama + Qwen3.5 + Hooks)..."

HOOK_DIR=".githooks"
HOOK_FILE="$HOOK_DIR/prepare-commit-msg"

REPO_URL="https://raw.githubusercontent.com/WPConstructor/ai-git/main/.githooks/prepare-commit-msg"

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
# 4. Download Git hook
# -------------------------
echo "⬇️ Downloading Git hook..."
#curl -fsSL "$REPO_URL" -o "$HOOK_FILE"

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
echo "   git commit"
echo ""
echo "🤖 AI will now assist your commits!"