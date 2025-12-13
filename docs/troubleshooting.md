# Troubleshooting

Document any recurring issues and their fixes here. Update as the bootstrap script and configs evolve.

## Installation
- **Bootstrap aborts with guard failure:** Verify system matches the archinstall profile (ext4 root, Limine installed, running as user `piemme`).
- **Missing internet:** Ensure NetworkManager service is active before running the bootstrap script.
- **AUR helper errors:** Ensure `yay` is installed via pacman (`sudo pacman -S --needed yay`). Remove any leftover `~/.cache/yay` build artifacts and rerun the bootstrap.

## Hyprland Session
- **Blank background:** Ensure `themes/catppuccin/backgrounds/default.jpg` (or `.png`) exists before running the bootstrap, or rerun it after adding the file.
- **Black screen on login:** Check `~/.local/share/myrice/logs/hyprland.log` (planned) for missing theme assets; rerun `scripts/apply-configs.sh`.
- **Waybar modules failing:** Confirm helper scripts exist in `~/.local/bin` and are executable. Logs will surface in `$XDG_CACHE_HOME/waybar.log` (planned).

## Neovim
- **LazyVim plugins not installed:** Run `nvim --headless "+Lazy! sync" +qa` to force plugin sync after bootstrap.
- **LSP issues:** Install language servers via `:Mason` or `mise use` depending on tooling preferences.

Add more entries as the project matures.
