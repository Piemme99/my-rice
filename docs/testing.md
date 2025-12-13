# VM Test Checklist

Use this guide after following the archinstall profile in `docs/archinstall.md` to validate the rice before rolling it out to real hardware.

## 1. Base Install
1. Boot Arch ISO, run through archinstall using the documented selections (ext4 root, swap file, Limine, user `piemme`).
2. Reboot into the new system and log in as `piemme`.
3. Verify networking works (`nmcli device status`).

## 2. Bootstrap Script
1. Install Git if necessary (`sudo pacman -S --needed git`).
2. Clone the repo and run the installer:
   ```bash
   git clone https://github.com/USERNAME/my-rice.git ~/.local/src/my-rice
   cd ~/.local/src/my-rice
   ./bootstrap/install.sh
   ```
3. Watch `/var/log/myrice-install.log` for progress. Resolve any pacman/AUR issues before proceeding.
4. After the script completes, reboot.

## 3. Desktop Smoke Tests
1. On the SDDM screen, confirm Hyprland session is selected and log in automatically.
2. Verify background image and Waybar load.
3. Exercise keybindings:
   - `SUPER+SPACE`: Walker launcher appears.
   - `SUPER+ENTER`: Alacritty launches.
   - `Print`: grim→satty workflow runs; close satty afterwards.
   - Media keys adjust volume/brightness with swayosd overlay.
4. Click Waybar modules:
   - Clock opens GNOME Calendar.
   - Network launches `nm-connection-editor`.
   - Bluetooth opens Blueman.
   - Speaker icon opens pavucontrol.
5. Launch Firefox and Neovim (run `:Lazy sync` once to prefetch plugins).

## 4. Post-Test Cleanup
1. Confirm `~/.config/myrice/current/theme` points at `themes/catppuccin` and the wallpaper symlink resolves.
2. Check `systemctl --user status` for hypridle, swayosd, and mako.
3. Note any issues or deviations and update docs/choices/troubleshooting accordingly.
