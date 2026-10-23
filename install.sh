#!/usr/bin/env bash
# =============================================================================
# Installation script for rvim
# =============================================================================
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rvim"
BIN_DIR="$HOME/.local/bin"
TARGET_BIN="$BIN_DIR/rvim"

echo "=== Installing rvim ==="

# 1. Ensure target directories exist
mkdir -p "$(dirname "$CONFIG_DIR")"
mkdir -p "$BIN_DIR"

# 2. Symlink configuration to ~/.config/rvim
if [ -e "$CONFIG_DIR" ] || [ -L "$CONFIG_DIR" ]; then
    if [ "$(readlink -f "$CONFIG_DIR")" = "$REPO_DIR" ]; then
        echo "[OK] Symlink $CONFIG_DIR already points to $REPO_DIR"
    else
        echo "[INFO] Backing up existing $CONFIG_DIR to ${CONFIG_DIR}.bak..."
        mv "$CONFIG_DIR" "${CONFIG_DIR}.bak"
        ln -s "$REPO_DIR" "$CONFIG_DIR"
        echo "[OK] Symlink created: $CONFIG_DIR -> $REPO_DIR"
    fi
else
    ln -s "$REPO_DIR" "$CONFIG_DIR"
    echo "[OK] Symlink created: $CONFIG_DIR -> $REPO_DIR"
fi

# 3. Symlink plugin pack directory if available from standard nvim
NVIM_PACK_DIR="$HOME/.local/share/nvim/site/pack"
RVIM_SITE_DIR="$HOME/.local/share/rvim/site"
if [ -d "$NVIM_PACK_DIR" ]; then
    mkdir -p "$RVIM_SITE_DIR"
    if [ ! -e "$RVIM_SITE_DIR/pack" ]; then
        ln -s "$NVIM_PACK_DIR" "$RVIM_SITE_DIR/pack"
        echo "[OK] Plugin pack symlink created: $RVIM_SITE_DIR/pack -> $NVIM_PACK_DIR"
    fi
fi

# 4. Install executable to ~/.local/bin/rvim
install -m 755 "$REPO_DIR/bin/rvim" "$TARGET_BIN"
echo "[OK] Binary installed to: $TARGET_BIN"

# 5. Verify PATH and startup
if command -v rvim >/dev/null 2>&1; then
    echo "[OK] 'rvim' detected in current PATH."
    rvim --headless -c "echo '[OK] rvim loaded successfully!'" -c "qa"
    echo ""
    echo "Done! You can now run 'rvim' from any terminal."
else
    echo "[WARN] $BIN_DIR is not in your current PATH. Add the following to your ~/.bashrc or ~/.zshrc:"
    echo '  export PATH="$HOME/.local/bin:$PATH"'
fi
