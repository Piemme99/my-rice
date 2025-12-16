#!/usr/bin/env bash
set -euo pipefail

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
