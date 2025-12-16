#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="/var/log/myrice-install.log"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/myrice"
BUILD_DIR="$STATE_DIR/build"
PACMAN_LIST="$REPO_ROOT/packages/pacman.txt"
AUR_LIST="$REPO_ROOT/packages/aur.txt"

source "$REPO_ROOT/bootstrap/lib/logging.sh"
source "$REPO_ROOT/bootstrap/lib/guards.sh"
source "$REPO_ROOT/bootstrap/lib/packages.sh"
source "$REPO_ROOT/bootstrap/lib/configs.sh"
source "$REPO_ROOT/bootstrap/lib/services.sh"

main() {
  ensure_log_file
  guard_environment
  install_pacman_packages
  install_yay
  install_aur_packages
  deploy_configs
  enable_services
  log_info "Bootstrap completed. Logout or reboot to start Hyprland."
  _log_append INFO "===== MyRice bootstrap finished ====="
}

main "$@"
