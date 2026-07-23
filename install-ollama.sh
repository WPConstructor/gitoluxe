#!/bin/bash

set -e

CUSTOM_DIR="$HOME/ollama/models"

echo "================================="
echo " Ollama Installer"
echo "================================="
echo

# Check if already installed
if command -v ollama >/dev/null 2>&1; then
    echo "Ollama is already installed:"
    ollama --version
    echo
else
    echo "Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

echo
echo "Where should Ollama store models?"
echo
echo "1) Use custom directory:"
echo "   $CUSTOM_DIR"
echo
echo "2) Use Ollama default directory"
echo
read -p "Choose [1/2]: " choice

case "$choice" in

    1)
        echo
        echo "Using custom model directory:"
        echo "$CUSTOM_DIR"

        mkdir -p "$CUSTOM_DIR"

        # Ensure Ollama service user can access it
        if id ollama >/dev/null 2>&1; then
            sudo chown -R ollama:ollama "$HOME/ollama"
        fi

        echo "Creating systemd override..."

        sudo mkdir -p /etc/systemd/system/ollama.service.d

        sudo tee /etc/systemd/system/ollama.service.d/override.conf > /dev/null <<EOF
[Service]
Environment="OLLAMA_MODELS=$CUSTOM_DIR"
EOF

        ;;

    2)
        echo
        echo "Using Ollama default model directory."

        sudo rm -f /etc/systemd/system/ollama.service.d/override.conf

        ;;

    *)
        echo "Invalid choice"
        exit 1
        ;;
esac


echo
echo "Reloading systemd..."

sudo systemctl daemon-reload


echo "Restarting Ollama..."

sudo systemctl enable ollama
sudo systemctl restart ollama


echo
echo "Checking Ollama service..."

if systemctl is-active --quiet ollama; then
    echo "✓ Ollama service is running"
else
    echo "✗ Ollama failed to start"
    echo
    journalctl -u ollama -n 50 --no-pager
    exit 1
fi


echo
echo "Environment:"
systemctl show ollama -p Environment


echo
echo "Testing Ollama API..."

if curl -s http://localhost:11434/api/tags >/dev/null; then
    echo "✓ Ollama API is available"
else
    echo "✗ Ollama API not reachable"
fi


echo
echo "Installation complete."
echo
echo "Try:"
echo "  ollama list"
echo "  ollama pull qwen3:4b"