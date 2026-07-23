#!/bin/bash

set -e

echo "================================="
echo " Ollama Removal Script"
echo "================================="
echo

read -p "Remove downloaded Ollama models too? (y/N): " REMOVE_MODELS

echo
echo "Stopping Ollama service..."

sudo systemctl stop ollama 2>/dev/null || true
sudo systemctl disable ollama 2>/dev/null || true


echo "Removing systemd configuration..."

sudo rm -f /etc/systemd/system/ollama.service
sudo rm -rf /etc/systemd/system/ollama.service.d

sudo systemctl daemon-reload
sudo systemctl reset-failed


echo "Removing Ollama binaries..."

sudo rm -f /usr/local/bin/ollama
sudo rm -f /usr/bin/ollama


echo "Removing Ollama user..."

if id ollama >/dev/null 2>&1; then
    sudo userdel ollama 2>/dev/null || true
fi


if [[ "$REMOVE_MODELS" =~ ^[Yy]$ ]]; then
    echo
    echo "Removing Ollama models..."

    rm -rf "$HOME/ollama"

    # Also remove default locations if they exist
    sudo rm -rf /usr/share/ollama
    sudo rm -rf /var/lib/ollama

    echo "Models removed."
else
    echo
    echo "Keeping models."
    echo "Your custom models should remain in:"
    echo "  $HOME/ollama/models"
fi


echo
echo "Checking removal..."

if command -v ollama >/dev/null 2>&1; then
    echo "WARNING: ollama command still exists:"
    which ollama
else
    echo "✓ Ollama binary removed"
fi


echo
echo "Done."