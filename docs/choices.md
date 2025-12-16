# Component Choices

This document captures the rationale behind each major decision in the rice. Update it whenever packages, configs, or defaults change.

## Base System
- **Installer:** `archinstall` — fast, repeatable baseline prior to bootstrap.
- **Filesystem:** Ext4 root (optionally atop LUKS) for a simple, well-supported workstation base.
- **Bootloader:** Limine — aligns with Omarchy conventions and supports themed boot UI.

## Desktop Stack
- **Compositor:** Hyprland for dynamic tiling and animation support.
- **Idle/Lock:** hypridle + hyprlock to integrate tightly with Hyprland.
- **Wallpaper:** hyprpaper (fallback swaybg) to keep theme simple.
- **Panel:** Waybar with persistent workspaces, clock, audio, battery, and tray modules.
- **Launcher:** Walker (AUR) for fuzzy search across apps/web.
- **Session Manager:** SDDM autologin to Hyprland for quick startup.
- **Networking:** NetworkManager CLI/GUI tools (applet optional; not included by default).
- **Input Method:** None by default to keep the bootstrap lean; install an IME later if multilingual input is needed.
- **Color Picker:** Hyprpicker for quick sampling bound to `SUPER+Print`.

## Applications
- **Browser:** Firefox (Wayland native, themeable).
- **Terminal:** Alacritty (single default for faster installs).
- **Editor:** Neovim with LazyVim distro + Catppuccin plugin.
- **File Manager:** Nautilus with GVFS extras (MTP + NFS backends by default; install `gvfs-smb` later if Windows shares are needed).
- **Notifications:** Mako with Catppuccin colors.
- **Screenshots:** grim + slurp + satty for capture + annotate.
- **Audio Controls:** PipeWire + WirePlumber + pamixer + playerctl + pavucontrol for media keys and mixer GUI.
- **Bluetooth:** Optional; install Blueman manually if needed (Waybar no longer surfaces a status module).
- **Calendar:** GNOME Calendar for quick clock integration (`clock` click action).

## Fonts & Theme
- JetBrainsMono Nerd & Cascadia Mono Nerd as monospace defaults.
- Noto font families cover UI text; emoji fonts are omitted for a slimmer image.
- Catppuccin Mocha across Hyprland, Waybar, terminals, GTK, and Neovim (GTK/Kvantum theme + cursors sourced from AUR packages). Theme assets live in `~/.config/myrice/themes/` with `current/theme` symlinked for easy switching.

## Development Tooling
- Neovim + LazyVim plus supporting CLIs (`git`, `gh`, `nodejs`, `npm`, `python-pip`, `luarocks`, `tree-sitter-cli`, `ripgrep`, `fd`).
- `mise` installed for runtime management (optional but ready).

## AUR Packages
- `yay` (installed via pacman, falling back to an AUR build when necessary) is the helper used for all AUR operations.
- `walker-git` for the launcher.
- `catppuccin-gtk-theme-mocha`, `catppuccin-kvantum-theme`, `catppuccin-cursors-mocha` to keep visuals consistent beyond Waybar/Hyprland.

## Future Decisions
- Decide on greetd vs SDDM once automation scripts mature.
- Evaluate adding Docker/Podman support and document if included.
