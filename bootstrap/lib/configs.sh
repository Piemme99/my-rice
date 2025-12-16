#!/usr/bin/env bash
set -euo pipefail

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

  if [ -f "$current_dir/theme/waybar.css" ]; then
    mkdir -p "$HOME/.config/waybar"
    ln -sfn "$current_dir/theme/waybar.css" "$HOME/.config/waybar/theme.css"
  fi
}

ensure_bash_alias_hook() {
  local bashrc="$HOME/.bashrc"
  local hook='source "$HOME/.config/bash/aliases"'

  [ -f "$bashrc" ] || touch "$bashrc"

  if ! grep -Fq "$hook" "$bashrc" 2>/dev/null; then
    {
      echo ""
      echo "# my-rice aliases"
      echo "if [ -f \"$HOME/.config/bash/aliases\" ]; then"
      echo "  source \"$HOME/.config/bash/aliases\""
      echo "fi"
    } >>"$bashrc"
  fi
}

install_xcompose() {
  local compose_src="$REPO_ROOT/configs/XCompose"
  if [ -f "$compose_src" ]; then
    cp "$compose_src" "$HOME/.XCompose"
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
  ensure_bash_alias_hook
  install_xcompose

  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f >/dev/null 2>&1 || true
  fi
}
