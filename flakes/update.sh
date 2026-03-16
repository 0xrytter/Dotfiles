#!/usr/bin/env bash
set -euo pipefail

read -p "Enter hostname (DIY-Desktop/T480) or Enter for $(hostname -s): " input
HOSTNAME="${input:-$(hostname -s)}"
FLAKE_PATH="."

echo "Updating flake for $HOSTNAME..."
nix flake update --flake "$FLAKE_PATH"

echo "Rebuilding system..."
sudo nixos-rebuild switch --flake "$FLAKE_PATH#$HOSTNAME"

echo "Cleaning old generations..."
sudo nix-collect-garbage --delete-older-than 7d

echo "Optimizing store..."
sudo nix-store --optimise

echo "Wiping old profiles..."
nix profile wipe-history 2>/dev/null || true
sudo nix profile wipe-history 2>/dev/null || true

echo "Cleaning caches..."
rm -rf ~/.cache/nix*

echo "Update & optimized complete! Kernel: $(uname -r)"
