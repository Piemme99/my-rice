#!/usr/bin/env bash
set -euo pipefail

enable_services() {
  log_info "Enabling system services"
  sudo systemctl enable --now NetworkManager.service
  sudo systemctl enable --now sddm.service
  sudo systemctl enable --now ufw.service || true
}
