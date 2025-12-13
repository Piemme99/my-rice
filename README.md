# Catppuccin Hyprland Rice

Personal Arch Linux workstation configuration for **piemme**. The goal is a reproducible Hyprland desktop with Catppuccin visuals, Neovim + LazyVim, and essential tooling for everyday software engineering. The workflow is intentionally simple:

1. Install vanilla Arch with `archinstall` using the documented profile below.
2. Reboot, log in as `piemme`, clone this repo, and run `bootstrap/install.sh`.
3. Enjoy a ready-to-use Catppuccin-themed Hyprland environment in under an hour.

## Quickstart

```bash
# After archinstall reboot and login as piemme
git clone https://github.com/USERNAME/my-rice.git ~/.local/src/my-rice
cd ~/.local/src/my-rice
./bootstrap/install.sh
```

> **Note:** Installer assumes passwordless `sudo` for the current session (as provided by Archinstall defaults). The script escalates where required.

## System Assumptions

- Vanilla Arch Linux via `archinstall`
- x86_64 laptop/desktop (tested on ThinkPad & Framework AMD variants)
- Secure Boot disabled
- Networking handled by NetworkManager
- Internet connection throughout the bootstrap

### Archinstall Profile

| Choice            | Selection                                            | Rationale                                                 |
|-------------------|------------------------------------------------------|-----------------------------------------------------------|
| Disk Layout       | Btrfs on LUKS, subvolumes `@`, `@home`, `@log`       | Snapshot-friendly and resilient for workstation use       |
| Swap              | 8 GiB swapfile (via archinstall option)              | Hibernate-ready, covers memory spikes                     |
| Bootloader        | Limine                                              | Matches Omarchy defaults and theme expectations           |
| Kernel            | Latest (linux)                                       | Upstream Arch kernel; works well with AMD hardware        |
| User              | `piemme`, added to wheel                             | Required by bootstrap scripts                             |
| Locale            | `en_US.UTF-8`                                        | Default environment locale                                |
| Timezone          | Prompted during archinstall                          | Set to local region                                       |
| Packages          | Only archinstall essentials                          | All desktop packages managed by this repo                 |

## What the Bootstrap Script Does

- Validates environment (Arch, Btrfs, Limine, user `piemme`).
- Installs package groups listed in `packages/pacman.txt` and `packages/aur.txt`.
- Builds and installs the AUR helper `paru-bin` if missing, then syncs AUR packages.
- Deploys configs under `~/.config` and helper scripts under `~/.local/bin`.
- Links Catppuccin theme assets under `~/.config/myrice/` and refreshes font cache.
- Preconfigures Neovim with LazyVim + Catppuccin.
- Configures SDDM autologin into Hyprland and enables necessary systemd services.
- Logs progress to `/var/log/myrice-install.log` with a Gum-based TUI.

## Component Overview

| Area         | Choice(s)                                 | Notes |
|--------------|-------------------------------------------|-------|
| WM & Compositor | Hyprland + hypridle + hyprlock + hyprpaper | Mirrors Omarchy experience with gaps, keybinds, power saving |
| Launcher     | Walker (Wayland app launcher from AUR)    | Configured with Catppuccin palette and symbol set |
| Panel        | Waybar                                    | Workspaces, clock (opens GNOME Calendar), network, bluetooth, audio, battery, tray |
| Notifications| Mako                                      | Colors aligned to Catppuccin Mocha |
| Audio        | PipeWire + WirePlumber + pamixer + pavucontrol + swayosd | Media keys with on-screen display + GUI mixer |
| Terminal     | Alacritty (primary), Kitty & Ghostty (optional) | Catppuccin colorways, JetBrainsMono Nerd Font |
| Editor       | Neovim + LazyVim distro + Catppuccin theme | Bootstrap script performs plugin sync |
| Browser      | Firefox                                   | Tweaked for Wayland and Catppuccin compatibility |
| File Manager | Nautilus + GVFS suite                     | Provides network shares, archives, previews |
| Networking   | NetworkManager + `network-manager-applet` | GUI applet for Wi-Fi and VPN switching |
| Bluetooth    | Blueman                                   | Launched from Waybar module for device management |
| Input Method | Fcitx5                                    | Preconfigured env vars + autostart agent |
| Clipboard    | `wl-clipboard` + Walker clipboard mode    | Supports copy/paste across Wayland apps |
| Screenshots  | `grim` + `slurp` + `satty` + Hyprpicker   | Annotate, copy, and sample colors via keybinds |
| File Sharing | LocalSend                                 | Quick LAN transfers |
| System Info  | `fastfetch`, `btop`, `eza`, `zoxide`, `fzf`| Terminal suite for daily tasks |
| Fonts        | JetBrainsMono Nerd, Cascadia Mono Nerd, Noto family | Fontconfig sets sane defaults |
| GTK/Kvantum Theme | Catppuccin Mocha GTK + cursors from AUR | Ensures GTK apps match the palette |

Full rationale is documented in [`docs/choices.md`](docs/choices.md).

## Keybindings (Hyprland)

| Action                       | Shortcut               |
|------------------------------|------------------------|
| Launch Walker                | `SUPER + SPACE`        |
| Open Terminal                | `SUPER + ENTER`        |
| Open File Manager            | `SUPER + SHIFT + F`    |
| Open Browser                 | `SUPER + SHIFT + B`    |
| Launch LazyVim Session       | `SUPER + SHIFT + N`    |
| Close Focused Window         | `SUPER + Q`            |
| Toggle Floating              | `SUPER + T`            |
| Move Focus (left/down/up/right) | `SUPER + H/J/K/L`  |
| Move Window to Workspace     | `SUPER + SHIFT + [1-9]`|
| Toggle Waybar Visibility     | `SUPER + SHIFT + SPACE`|
| Screenshot & Annotate        | `Print`                |
| Screenshot to Clipboard      | `SHIFT + Print`        |
| Color Picker                 | `SUPER + Print`        |
| Volume Up/Down/Mute          | `XF86AudioRaise/Lower/Mute`|
| Play/Pause                   | `XF86AudioPlay`        |

> See `configs/hypr/keybinds.conf` (upcoming) for the full list, adapted from Omarchy defaults.

## Customization Guide

1. **Packages:** edit `packages/pacman.txt` or `packages/aur.txt` then rerun `bootstrap/install.sh --packages-only` (flag TBD) to sync.
2. **Hyprland Behavior:** tweak files in `configs/hypr/` and re-run `scripts/apply-configs.sh`.
3. **Waybar Modules:** modify `configs/waybar/config.jsonc` & `style.css`. Log decisions in `docs/choices.md`.
4. **Theme:** drop a wallpaper named `default.jpg` (or `default.png`) into `themes/catppuccin/backgrounds/`; bootstrap links it to `~/.config/myrice/current/background`.
5. **Neovim Plugins:** adjust LazyVim config in `configs/nvim/lua/plugins/`. Use `:Lazy sync` after changes.
6. **Browser Defaults:** update `configs/firefox/policies/` (planned) and note change in documentation.

## Logging & Troubleshooting

- Installer logs: `/var/log/myrice-install.log`
- Bootstrap progress uses Gum; press `Ctrl+C` to abort safely.
- Common issues and fixes will be tracked in [`docs/troubleshooting.md`](docs/troubleshooting.md).

## Roadmap

- Flesh out helper scripts replacing Omarchy’s `omarchy-*` commands with native alternatives.
- Add optional greetd login path.
- Document VM testing workflow.
- Provide smoke-test scripts in `tests/` once configs stabilize.

## License

Content is personal but defaults to MIT unless a different license is added. For now see project notes.
