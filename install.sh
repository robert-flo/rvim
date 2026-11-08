#!/usr/bin/env bash
# Interactive menu and command-line installer/verifier for rvim (Neovim 0.12+ setup).
# Supports Arch Linux (pacman) and Ubuntu/Debian (apt).

set -Eeuo pipefail

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ Configuration                                                                │
# └──────────────────────────────────────────────────────────────────────────────┘

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_DIR
readonly CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rvim"
readonly BIN_DIR="$HOME/.local/bin"
readonly TARGET_BIN="$BIN_DIR/rvim"
readonly NVIM_PACK_DIR="$HOME/.local/share/nvim/site/pack"
readonly RVIM_SITE_DIR="$HOME/.local/share/rvim/site"
readonly FONT_DIR="$HOME/.local/share/fonts/PlemolJP-NF"
readonly PLEMOLJP_VERSION="v3.0.0"

readonly -a RVIM_DASHBOARD_BINS=(
  rvim
  rvim-dashboard-issues
  rvim-dashboard-notify
  rvim-dashboard-prs
  rvim-dashboard-status
)

# Core tools from devas.life section 0.2
readonly -a CORE_COMMANDS=(
  nvim
  git
  tree-sitter
  gcc
  curl
  tar
  node
  npm
  rg
  fd
  lazygit
  delta
)

# Extra tools used by rvim plugins & workflow
readonly -a EXTRA_COMMANDS=(
  gh
  stylua
  python3
)

# Arch Linux (pacman) packages
readonly -a ARCH_PACKAGES=(
  neovim
  git
  tree-sitter-cli
  base-devel
  curl
  tar
  nodejs
  npm
  ripgrep
  fd
  lazygit
  git-delta
  github-cli
  stylua
  python
  wl-clipboard
  xclip
  unzip
  fontconfig
)

# Ubuntu / Debian (apt) packages
readonly -a UBUNTU_PACKAGES=(
  neovim
  git
  build-essential
  curl
  tar
  nodejs
  npm
  ripgrep
  fd-find
  git-delta
  gh
  python3
  wl-clipboard
  xclip
  unzip
  fontconfig
)

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ Presentation & Styling                                                       │
# └──────────────────────────────────────────────────────────────────────────────┘

if [[ -t 1 && ${TERM:-dumb} != "dumb" && -z ${NO_COLOR:-} ]]; then
  readonly RED=$'\033[0;31m'
  readonly GREEN=$'\033[0;32m'
  readonly YELLOW=$'\033[0;33m'
  readonly BLUE=$'\033[0;34m'
  readonly MAGENTA=$'\033[0;35m'
  readonly CYAN=$'\033[0;36m'
  readonly WHITE=$'\033[1;37m'
  readonly GRAY=$'\033[0;90m'
  readonly LIGHT_GRAY=$'\033[0;37m'
  readonly NC=$'\033[0m'
  readonly ICON_CHECK="✓"
  readonly ICON_CROSS="✗"
  readonly ICON_ARROW="→"
  readonly ICON_WARN="⚠"
  readonly ICON_INFO=""
else
  readonly RED=""
  readonly GREEN=""
  readonly YELLOW=""
  readonly BLUE=""
  readonly MAGENTA=""
  readonly CYAN=""
  readonly WHITE=""
  readonly GRAY=""
  readonly LIGHT_GRAY=""
  readonly NC=""
  readonly ICON_CHECK="[OK]"
  readonly ICON_CROSS="[ERROR]"
  readonly ICON_ARROW=">"
  readonly ICON_WARN="[WARN]"
  readonly ICON_INFO="[INFO]"
fi

readonly \
  ICON_PACKAGE="" \
  ICON_GEAR="" \
  ICON_ROCKET="" \
  ICON_FONT="" \
  ICON_NVIM=""

declare -Ar RAVN_ICON=(
  [ui_check]=" "
  [ui_close]=" "
  [ui_command]=" "
  [ui_gear]=" "
  [ui_package]=" "
  [ui_trash]=" "
  [ui_help]="󰋖 "
)

print_header() {
  echo ""
  echo -e "${CYAN}╭────────────────────────────────────────────────────────────╮${NC}"
  echo -e "${CYAN}│${NC}  ${WHITE}$1${NC}"
  echo -e "${CYAN}╰────────────────────────────────────────────────────────────╯${NC}"
}

print_section() {
  echo ""
  echo -e "${MAGENTA}  $1${NC}"
  echo -e "${GRAY}  ──────────────────────────────────────────────────────────${NC}"
}

print_step() {
  echo -e "  ${GRAY}${ICON_ARROW}${NC} $1"
}

print_success() {
  echo -e "  ${GREEN}${ICON_CHECK}${NC} $1"
}

print_error() {
  echo -e "  ${RED}${ICON_CROSS}${NC} $1"
}

print_warn() {
  echo -e "  ${YELLOW}${ICON_WARN}${NC} $1"
}

print_info() {
  echo -e "  ${BLUE}${ICON_INFO}${NC} $1"
}

is_running_in_docker() {
  [[ -f /.dockerenv ]] && return 0
  [[ -r /proc/1/cgroup ]] && grep -qaE '/(docker|containerd)(/|$)' /proc/1/cgroup
}

clear_screen() {
  [[ -t 1 && ${TERM:-dumb} != dumb ]] || return 0
  printf '\033[H\033[2J'
}

show_rvim_banner() {
  local gh_user=""
  gh_user=$(gh api user -q .login 2> /dev/null || echo "rollo")
  echo -e "${CYAN}"
  cat << 'BANNER_EOF'
  ╭────────────────────────────────────────────────────╮
  │                                                    │
  │  ██████╗ ██╗   ██╗██╗███╗   ███╗                   │
  │  ██╔══██╗██║   ██║██║████╗ ████║                   │
  │  ██████╔╝██║   ██║██║██╔████╔██║                   │
  │  ██╔══██╗╚██╗ ██╔╝██║██║╚██╔╝██║                   │
  │  ██║  ██║ ╚████╔╝ ██║██║ ╚═╝ ██║                   │
  │  ╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝                   │
  │                                                    │
  │   Agentic Neovim 0.12+ Setup (Arch & Ubuntu)       │
  │                                                    │
BANNER_EOF
  echo -e "  │     ${GRAY}by Roberto Flores ${WHITE}@${gh_user}${CYAN}                  │"
  if is_running_in_docker; then
    echo -e "  │     ${YELLOW}󰡨 Running inside Docker${CYAN}                         │"
  fi
  cat << 'BANNER_EOF'
  │                                                    │
  ╰────────────────────────────────────────────────────╯
BANNER_EOF
  echo -e "${NC}"
}

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ Dependency & Environment Detection                                           │
# └──────────────────────────────────────────────────────────────────────────────┘

command_exists() {
  command -v "$1" > /dev/null 2>&1
}

detect_package_manager() {
  if command_exists pacman; then
    echo "pacman"
  elif command_exists apt; then
    echo "apt"
  else
    echo ""
  fi
}

check_fd_installed() {
  command_exists fd || command_exists fdfind
}

check_clipboard_installed() {
  command_exists wl-copy || command_exists xclip || command_exists xsel
}

detect_nerd_font_name() {
  if command_exists fc-list; then
    local fonts=""
    fonts="$(fc-list : family 2> /dev/null || true)"
    if grep -qi "PlemolJP" <<< "$fonts"; then
      echo "PlemolJP Console NF"
      return 0
    fi
    local nf_match=""
    nf_match="$(grep -iE "Nerd Font|NerdFont" <<< "$fonts" | head -n 1 | cut -d',' -f1 || true)"
    if [[ -n "$nf_match" ]]; then
      echo "$nf_match"
      return 0
    fi
  fi
  if [[ -d "$FONT_DIR" ]]; then
    echo "PlemolJP Console NF ($FONT_DIR)"
    return 0
  fi
  return 1
}

check_nvim_version() {
  if ! command_exists nvim; then
    print_error "nvim not found (Neovim 0.12+ required)"
    return 1
  fi
  local version_line=""
  version_line="$(nvim --version | head -n 1)"
  local major=0 minor=0
  if [[ $version_line =~ v([0-9]+)\.([0-9]+) ]]; then
    major="${BASH_REMATCH[1]}"
    minor="${BASH_REMATCH[2]}"
  fi
  if ((major > 0 || (major == 0 && minor >= 12))); then
    print_success "Neovim version: ${WHITE}${version_line}${NC} (>= 0.12)"
    return 0
  else
    print_error "Neovim version: ${WHITE}${version_line}${NC} (0.12 or newer required)"
    return 1
  fi
}

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ Commands: verify, deps, setup, clean, help                                   │
# └──────────────────────────────────────────────────────────────────────────────┘

do_verify() {
  print_header "${ICON_NVIM} Verify rvim Environment & Dependencies"

  local missing=0
  local cmd=""

  print_section "0.1 Neovim Version"
  check_nvim_version || ((missing += 1))

  print_section "${ICON_PACKAGE} 0.2 Core CLI Tools (devas.life spec)"
  for cmd in "${CORE_COMMANDS[@]}"; do
    if [[ $cmd == "fd" ]]; then
      if check_fd_installed; then
        print_success "fd ($(command -v fd || command -v fdfind))"
      else
        print_error "fd / fdfind not found"
        ((missing += 1))
      fi
    elif command_exists "$cmd"; then
      print_success "$cmd ($(command -v "$cmd"))"
    else
      print_error "$cmd not found"
      ((missing += 1))
    fi
  done

  print_section "${ICON_GEAR} Extra rvim Tools"
  for cmd in "${EXTRA_COMMANDS[@]}"; do
    if command_exists "$cmd"; then
      print_success "$cmd ($(command -v "$cmd"))"
    elif [[ $cmd == "stylua" && -x "$HOME/.local/share/nvim/mason/bin/stylua" ]]; then
      print_success "stylua (installed via Mason: ~/.local/share/nvim/mason/bin/stylua)"
    else
      print_warn "$cmd not found in global PATH"
      ((missing += 1))
    fi
  done

  if check_clipboard_installed; then
    print_success "System clipboard provider detected (wl-clipboard / xclip)"
  else
    print_warn "No clipboard provider found (install wl-clipboard or xclip)"
    ((missing += 1))
  fi

  print_section "${ICON_FONT} 0.3 Nerd Font"
  local nf_name=""
  if nf_name="$(detect_nerd_font_name)"; then
    print_success "Nerd Font detected: ${WHITE}${nf_name}${NC}"
  else
    print_warn "No Nerd Font (e.g. PlemolJP Console NF) detected"
    ((missing += 1))
  fi

  print_section "${ICON_ROCKET} rvim Symlinks & Binaries"
  if [[ -L "$CONFIG_DIR" && "$(readlink -f "$CONFIG_DIR")" == "$REPO_DIR" ]]; then
    print_success "Config symlink: ${WHITE}$CONFIG_DIR -> $REPO_DIR${NC}"
  else
    print_warn "Config symlink not configured at $CONFIG_DIR"
  fi

  if [[ -x "$TARGET_BIN" ]]; then
    print_success "Launcher installed: ${WHITE}$TARGET_BIN${NC}"
  else
    print_warn "Launcher not installed at $TARGET_BIN"
  fi

  echo ""
  if ((missing == 0)); then
    print_success "All required dependencies and fonts are installed!"
    return 0
  else
    print_info "$missing item(s) missing or incomplete. Run './install.sh deps' to install them."
    return 1
  fi
}

install_plemoljp_font() {
  print_section "${ICON_FONT} Installing PlemolJP Console NF (Nerd Font)"
  local nf_name=""
  if nf_name="$(detect_nerd_font_name)" && [[ "$nf_name" == *"PlemolJP"* ]]; then
    print_success "PlemolJP Nerd Font is already installed"
    return 0
  fi

  if command_exists pacman && pacman -Si ttf-jetbrains-mono-nerd > /dev/null 2>&1; then
    print_step "Ensuring Nerd Font fallback via pacman (ttf-jetbrains-mono-nerd)..."
    sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd
  fi

  local tmp_zip="/tmp/PlemolJP_NF_${PLEMOLJP_VERSION}.zip"
  local tmp_extract="/tmp/PlemolJP_NF_extract"
  local url="https://github.com/yuru7/PlemolJP/releases/download/${PLEMOLJP_VERSION}/PlemolJP_NF_${PLEMOLJP_VERSION}.zip"

  print_step "Downloading PlemolJP Console NF (${PLEMOLJP_VERSION})..."
  if curl -fsSL "$url" -o "$tmp_zip"; then
    rm -rf "$tmp_extract"
    mkdir -p "$tmp_extract" "$FONT_DIR"
    unzip -q "$tmp_zip" -d "$tmp_extract"
    find "$tmp_extract" -type f -name "*.ttf" -exec cp -f {} "$FONT_DIR/" \;
    rm -rf "$tmp_zip" "$tmp_extract"
    if command_exists fc-cache; then
      print_step "Refreshing font cache..."
      fc-cache -f "$FONT_DIR"
    fi
    print_success "Installed PlemolJP Console NF to $FONT_DIR"
  else
    print_warn "Could not download PlemolJP release; system Nerd Font fallback remains active."
  fi
}

do_deps() {
  print_header "${ICON_PACKAGE} Install CLI Tools & Fonts (Arch / Ubuntu)"

  local mgr=""
  mgr="$(detect_package_manager)"

  case "$mgr" in
    pacman)
      print_section "Arch Linux detected (pacman)"
      print_step "Installing packages: ${ARCH_PACKAGES[*]}"
      sudo pacman -S --needed "${ARCH_PACKAGES[@]}"
      print_success "Arch Linux packages installed"
      ;;
    apt)
      print_section "Ubuntu / Debian detected (apt)"
      print_step "Updating apt package index..."
      sudo apt update
      print_step "Installing packages: ${UBUNTU_PACKAGES[*]}"
      sudo apt install -y "${UBUNTU_PACKAGES[@]}"

      mkdir -p "$BIN_DIR"
      if command_exists fdfind && ! command_exists fd; then
        ln -sf "$(command -v fdfind)" "$BIN_DIR/fd"
        print_success "Linked fdfind -> $BIN_DIR/fd"
      fi

      if ! command_exists tree-sitter && command_exists npm; then
        print_step "Installing tree-sitter-cli via npm..."
        npm install -g tree-sitter-cli
      fi

      if ! command_exists stylua && command_exists npm; then
        print_step "Installing @johnnymorganz/stylua-bin via npm..."
        npm install -g @johnnymorganz/stylua-bin
      fi

      if ! command_exists lazygit; then
        print_step "Installing lazygit from official GitHub release..."
        local lg_ver=""
        lg_ver=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
        curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${lg_ver}/lazygit_${lg_ver}_Linux_x86_64.tar.gz" \
          | tar -xz -C "$BIN_DIR" lazygit
        chmod +x "$BIN_DIR/lazygit"
        print_success "Installed lazygit v${lg_ver} to $BIN_DIR/lazygit"
      fi
      print_success "Ubuntu / Debian packages installed"
      ;;
    *)
      print_error "Unsupported distribution (neither pacman nor apt found)."
      return 1
      ;;
  esac

  install_plemoljp_font
}

do_setup() {
  print_header "${ICON_ROCKET} Setup rvim Configuration & Executables"

  print_section "1. Directories & Configuration Symlink"
  mkdir -p "$(dirname "$CONFIG_DIR")"
  mkdir -p "$BIN_DIR"

  if [[ -e "$CONFIG_DIR" || -L "$CONFIG_DIR" ]]; then
    if [[ "$(readlink -f "$CONFIG_DIR")" == "$REPO_DIR" ]]; then
      print_success "Symlink $CONFIG_DIR already points to $REPO_DIR"
    else
      print_warn "Backing up existing $CONFIG_DIR to ${CONFIG_DIR}.bak..."
      mv "$CONFIG_DIR" "${CONFIG_DIR}.bak"
      ln -s "$REPO_DIR" "$CONFIG_DIR"
      print_success "Symlink created: $CONFIG_DIR -> $REPO_DIR"
    fi
  else
    ln -s "$REPO_DIR" "$CONFIG_DIR"
    print_success "Symlink created: $CONFIG_DIR -> $REPO_DIR"
  fi

  print_section "2. Shared Plugin Pack Symlink"
  if [[ -d "$NVIM_PACK_DIR" ]]; then
    mkdir -p "$RVIM_SITE_DIR"
    if [[ ! -e "$RVIM_SITE_DIR/pack" ]]; then
      ln -s "$NVIM_PACK_DIR" "$RVIM_SITE_DIR/pack"
      print_success "Plugin pack symlink created: $RVIM_SITE_DIR/pack -> $NVIM_PACK_DIR"
    else
      print_success "Plugin pack directory already linked at $RVIM_SITE_DIR/pack"
    fi
  else
    print_info "No pre-existing $NVIM_PACK_DIR found (vim.pack will manage plugins directly)"
  fi

  print_section "3. Install Executables to $BIN_DIR"
  local bin_name=""
  for bin_name in "${RVIM_DASHBOARD_BINS[@]}"; do
    if [[ -f "$REPO_DIR/bin/$bin_name" ]]; then
      install -m 755 "$REPO_DIR/bin/$bin_name" "$BIN_DIR/$bin_name"
      print_success "Installed $BIN_DIR/$bin_name"
    fi
  done

  print_section "4. Verify Headless Startup"
  if command_exists nvim; then
    nvim --headless +qa
    print_success "nvim --headless +qa completed without errors!"
  else
    print_warn "nvim not found in PATH yet; run './install.sh deps' first."
  fi
}

do_clean() {
  print_header "${RAVN_ICON[ui_trash]} Clean rvim Symlinks & Wrapper Binaries"

  echo ""
  print_warn "This will remove only the symlinks and wrapper binaries in ~/.local/bin:"
  echo -e "    • $CONFIG_DIR (symlink only)"
  echo -e "    • $RVIM_SITE_DIR/pack (symlink only)"
  echo -e "    • $BIN_DIR/rvim*"
  echo -e "    ${GRAY}(Your repository at $REPO_DIR will NOT be touched)${NC}"
  echo ""
  echo -ne "  ${YELLOW}Are you sure? Type 'yes' to confirm:${NC} "
  local confirm=""
  read -r confirm
  if [[ $confirm != "yes" ]]; then
    print_info "Clean cancelled."
    return 0
  fi

  if [[ -L "$CONFIG_DIR" ]]; then
    rm -f "$CONFIG_DIR"
    print_success "Removed symlink $CONFIG_DIR"
  fi

  if [[ -L "$RVIM_SITE_DIR/pack" ]]; then
    rm -f "$RVIM_SITE_DIR/pack"
    print_success "Removed symlink $RVIM_SITE_DIR/pack"
  fi

  local bin_name=""
  for bin_name in "${RVIM_DASHBOARD_BINS[@]}"; do
    if [[ -f "$BIN_DIR/$bin_name" ]]; then
      rm -f "$BIN_DIR/$bin_name"
      print_success "Removed $BIN_DIR/$bin_name"
    fi
  done
}

show_help() {
  print_section "${RAVN_ICON[ui_help]} Help and Usage"
  cat << 'HELP_EOF'
  install.sh manages CLI prerequisites, Nerd Fonts, and rvim symlinks on Arch Linux and Ubuntu.

  USAGE
    ./install.sh [command]

  COMMANDS
    verify    Check Neovim >= 0.12, CLI tools (0.2), extra rvim tools, and Nerd Fonts
    deps      Install missing packages and PlemolJP Nerd Font via pacman (Arch) or apt (Ubuntu)
    setup     Configure ~/.config/rvim symlink, ~/.local/bin/rvim binaries, and test startup
    clean     Remove ~/.config/rvim symlink and ~/.local/bin/rvim wrapper binaries
    help      Show this help message
HELP_EOF
}

dispatch_command() {
  case "${1:-}" in
    verify) do_verify ;;
    deps | install-deps) do_deps ;;
    setup | install) do_setup ;;
    clean) do_clean ;;
    help | h | --help | -h) show_help ;;
    *)
      print_error "Unknown command: ${1:-}"
      show_help
      return 1
      ;;
  esac
}

show_menu() {
  echo ""
  print_section "${RAVN_ICON[ui_command]} Choose an action"
  echo -e "  ${GREEN}1${NC}  ${RAVN_ICON[ui_check]}  Verify prerequisites & environment (0.1 - 0.3)"
  echo -e "  ${GREEN}2${NC}  ${RAVN_ICON[ui_package]}  Install CLI dependencies & Nerd Font (Arch / Ubuntu)"
  echo -e "  ${GREEN}3${NC}  ${RAVN_ICON[ui_gear]}  Setup rvim symlinks, binaries & test startup"
  echo -e "  ${GREEN}4${NC}  ${RAVN_ICON[ui_trash]}  Clean rvim symlinks & binaries"
  echo -e "  ${GREEN}h${NC}  ${RAVN_ICON[ui_help]}  Help & CLI usage"
  echo -e "  ${GREEN}q${NC}  ${RAVN_ICON[ui_close]}  Exit"
  echo ""
  echo -ne "  ${LIGHT_GRAY}Selection:${NC} "
}

run_interactive_menu() {
  local choice=""
  while true; do
    show_menu
    read -r choice
    case "$choice" in
      1) dispatch_command verify || true ;;
      2) dispatch_command deps || true ;;
      3) dispatch_command setup || true ;;
      4) dispatch_command clean || true ;;
      h | H) dispatch_command help || true ;;
      q | Q)
        echo ""
        print_info "Goodbye!"
        return 0
        ;;
      *) print_error "Invalid option" ;;
    esac
    echo ""
    echo -ne "  ${GRAY}Press Enter to continue...${NC}"
    read -r
    clear_screen
    show_rvim_banner
  done
}

main() {
  if (($# > 0)); then
    case "${1:-}" in
      help | h | --help | -h)
        show_rvim_banner
        dispatch_command "$@"
        return 0
        ;;
    esac
    show_rvim_banner
    dispatch_command "$@"
    return $?
  fi

  if ! is_running_in_docker; then
    clear_screen
  fi
  show_rvim_banner
  do_verify || true
  run_interactive_menu
}

main "$@"
