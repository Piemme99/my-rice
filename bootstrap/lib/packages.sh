#!/usr/bin/env bash
set -euo pipefail

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

install_yay() {
  if command -v yay >/dev/null 2>&1; then
    log_info "yay already installed"
    return
  fi

  log_info "Installing yay via pacman"
  if sudo pacman -S --needed --noconfirm yay >/dev/null 2>&1; then
    return
  fi

  log_warn "Pacman could not install yay. Falling back to AUR build."
  require_command git
  mkdir -p "$BUILD_DIR"
  local workdir
  workdir="$(mktemp -d "$BUILD_DIR/yay.XXXXXX")"
  git clone --depth 1 https://aur.archlinux.org/yay.git "$workdir" >/dev/null 2>&1
  pushd "$workdir" >/dev/null
  if ! makepkg -si --noconfirm; then
    log_error "Failed to build yay from source"
    popd >/dev/null
    rm -rf "$workdir"
    exit 1
  fi
  popd >/dev/null
  rm -rf "$workdir"
  log_info "yay installed from source"
}

install_aur_packages() {
  mapfile -t aur_packages < <(read_package_file "$AUR_LIST")
  if ((${#aur_packages[@]} == 0)); then
    log_info "No AUR packages declared. Skipping AUR install step."
    return
  fi

  log_info "Installing AUR packages with yay (${#aur_packages[@]})"
  yay -S --needed --noconfirm "${aur_packages[@]}"
}
