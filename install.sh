#!/usr/bin/env bash
# =============================================================================
# Script de instalación para rvim
# =============================================================================
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rvim"
BIN_DIR="$HOME/.local/bin"
TARGET_BIN="$BIN_DIR/rvim"

echo "=== Instalando rvim ==="

# 1. Asegurar directorios destino
mkdir -p "$(dirname "$CONFIG_DIR")"
mkdir -p "$BIN_DIR"

# 2. Enlazar configuración a ~/.config/rvim
if [ -e "$CONFIG_DIR" ] || [ -L "$CONFIG_DIR" ]; then
    if [ "$(readlink -f "$CONFIG_DIR")" = "$REPO_DIR" ]; then
        echo "[OK] El enlace $CONFIG_DIR ya apunta a $REPO_DIR"
    else
        echo "[INFO] Respaldando $CONFIG_DIR existente en ${CONFIG_DIR}.bak..."
        mv "$CONFIG_DIR" "${CONFIG_DIR}.bak"
        ln -s "$REPO_DIR" "$CONFIG_DIR"
        echo "[OK] Enlace creado: $CONFIG_DIR -> $REPO_DIR"
    fi
else
    ln -s "$REPO_DIR" "$CONFIG_DIR"
    echo "[OK] Enlace creado: $CONFIG_DIR -> $REPO_DIR"
fi

# 3. Instalar ejecutable en ~/.local/bin/rvim
install -m 755 "$REPO_DIR/bin/rvim" "$TARGET_BIN"
echo "[OK] Ejecutable instalado en: $TARGET_BIN"

# 4. Verificar PATH y funcionamiento
if command -v rvim >/dev/null 2>&1; then
    echo "[OK] 'rvim' detectado correctamente en PATH."
    rvim --headless -c "echo '[OK] rvim cargado exitosamente!'" -c "qa"
    echo ""
    echo "¡Listo! Ahora puedes escribir 'rvim' en cualquier terminal."
else
    echo "[AVISO] $BIN_DIR no está en tu PATH actual. Agrega lo siguiente a tu ~/.bashrc o ~/.zshrc:"
    echo '  export PATH="$HOME/.local/bin:$PATH"'
fi
