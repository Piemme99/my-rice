#!/usr/bin/env bash
set -euo pipefail

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
