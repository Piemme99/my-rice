#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="/var/log/myrice-install.log"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/myrice"
BUILD_DIR="$STATE_DIR/build"
PACMAN_LIST="$REPO_ROOT/packages/pacman.txt"
AUR_LIST="$REPO_ROOT/packages/aur.txt"

_log_append() {
  local level="$1" message="$2"
  printf '[%(%Y-%m-%d %H:%M:%S)T] %-5s %s\n' -1 "$level" "$message" | sudo tee -a "$LOG_FILE" >/dev/null
}

_log_style() {
  local color="$1" text="$2"
  if command -v gum >/dev/null 2>&1; then
    gum style --foreground "$color" --padding "0 1" "$text"
  else
    printf '%s\n' "$text"
  fi
}

log_info() {
  local msg="$1"
  _log_append INFO "$msg"
  _log_style 10 "[INFO] $msg"
}

log_warn() {
  local msg="$1"
  _log_append WARN "$msg"
  _log_style 214 "[WARN] $msg"
}

log_error() {
  local msg="$1"
  _log_append ERROR "$msg"
  _log_style 203 "[ERROR] $msg"
}

ensure_log_file() {
  sudo mkdir -p "$(dirname "$LOG_FILE")"
  if [[ ! -f "$LOG_FILE" ]]; then
    sudo touch "$LOG_FILE"
    sudo chmod 640 "$LOG_FILE"
  fi
  _log_append INFO "===== MyRice bootstrap started ====="
}

require_command() {
  local cmd="$1" pkg_hint="${2:-$1}"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    log_error "Required command '$cmd' not found (install $pkg_hint)."
    exit 1
  fi
}

guard_environment() {
  log_info "Running environment guards"

  if [[ ! -f /etc/arch-release ]]; then
    log_error "This bootstrap only supports Arch Linux systems installed via archinstall."
    exit 1
  fi

  if [[ "${USER}" != "piemme" ]]; then
    log_warn "Logged in user is '$USER'. Expected 'piemme'. Continuing may produce incorrect configs."
  fi

  if ! command -v limine >/dev/null 2>&1; then
    log_warn "Limine not detected in PATH. Ensure archinstall was run with Limine bootloader."
  fi

  local root_fs
  root_fs="$(findmnt -n -o FSTYPE /)"
  if [[ "$root_fs" != "ext4" ]]; then
    log_warn "Root filesystem is '$root_fs'. Profile assumes ext4."
  fi

  require_command sudo
  require_command pacman
}

read_package_file() {
  local file="$1"
  grep -Ev '^(#|$)' "$file"
}

install_pacman_packages() {
  log_info "Refreshing pacman databases"
  sudo pacman -Syu --noconfirm

  mapfile -t packages < <(read_package_file "$PACMAN_LIST")
  if ((${#packages[@]} == 0)); then
    log_warn "No pacman packages declared. Skipping pacman install step."
    return
  fi

  log_info "Installing pacman packages (${#packages[@]})"
  sudo pacman -S --needed --noconfirm "${packages[@]}"
}

build_paru_bin() {
  log_info "Building paru-bin from AUR"
  require_command git

  mkdir -p "$BUILD_DIR"
  local workdir
  workdir="$(mktemp -d "$BUILD_DIR/paru-bin.XXXXXX")"
  git clone --depth 1 https://aur.archlinux.org/paru-bin.git "$workdir" >/dev/null 2>&1

  pushd "$workdir" >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null

  rm -rf "$workdir"
}

ensure_paru() {
  if command -v paru >/dev/null 2>&1; then
    log_info "paru already installed"
    return
  fi

  build_paru_bin
}

install_aur_packages() {
  mapfile -t aur_packages < <(read_package_file "$AUR_LIST")
  if ((${#aur_packages[@]} == 0)); then
    log_info "No AUR packages declared. Skipping AUR install step."
    return
  fi

  ensure_paru
  log_info "Installing AUR packages (${#aur_packages[@]})"
  paru -S --needed --noconfirm "${aur_packages[@]}"
}

copy_config_entry() {
  local src="$1" dest="$2"
  if [ -d "$src" ]; then
    mkdir -p "$dest"
    cp -rT "$src" "$dest"
  else
    mkdir -p "$(dirname "$dest")"
    cp -f "$src" "$dest"
  fi
}

setup_theme_links() {
  local theme_root="$HOME/.config/myrice"
  local themes_dir="$theme_root/themes"
  local current_dir="$theme_root/current"
  local catppuccin_src="$REPO_ROOT/themes/catppuccin"

  mkdir -p "$themes_dir" "$current_dir"
  ln -sfn "$catppuccin_src" "$themes_dir/catppuccin"
  ln -sfn "$themes_dir/catppuccin" "$current_dir/theme"

  if [ -f "$themes_dir/catppuccin/backgrounds/default.jpg" ]; then
    ln -sfn "$themes_dir/catppuccin/backgrounds/default.jpg" "$current_dir/background"
  elif [ -f "$themes_dir/catppuccin/backgrounds/default.png" ]; then
    ln -sfn "$themes_dir/catppuccin/backgrounds/default.png" "$current_dir/background"
  else
    rm -f "$current_dir/background" 2>/dev/null || true
  fi
}

deploy_configs() {
  log_info "Deploying configuration files"
  mkdir -p "$HOME/.config"

  for entry in "$REPO_ROOT/configs"/*; do
    local name
    name="$(basename "$entry")"
    if [ "$name" = "bin" ]; then
      continue
    fi
    copy_config_entry "$entry" "$HOME/.config/$name"
  done

  local bin_src="$REPO_ROOT/configs/bin"
  if [ -d "$bin_src" ] && [ "$(ls -A "$bin_src" 2>/dev/null)" ]; then
    mkdir -p "$HOME/.local/bin"
    cp -f "$bin_src"/* "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin"/*
  fi

  setup_theme_links

  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f >/dev/null 2>&1 || true
  fi
}

enable_services() {
  log_info "Enabling system services"
  sudo systemctl enable --now NetworkManager.service
  sudo systemctl enable --now sddm.service
  sudo systemctl enable --now pipewire-pulse.service wireplumber.service || true
  sudo systemctl enable --now ufw.service || true
}

main() {
  ensure_log_file
  guard_environment
  install_pacman_packages
  install_aur_packages
  deploy_configs
  enable_services
  log_info "Bootstrap completed. Logout or reboot to start Hyprland."
  _log_append INFO "===== MyRice bootstrap finished ====="
}

main "$@"
