# Archinstall Profile

Follow this walkthrough to create a repeatable base system before running the bootstrap script.

> These steps assume a UEFI system with Secure Boot disabled and a single disk dedicated to this installation.

## 1. Launch Archinstall

1. Boot the official Arch ISO.
2. At the shell prompt run `archinstall`.

## 2. Main Menu Selections

Choose the options below when prompted:

| Menu Item                    | Selection / Input                                                                                              |
|-----------------------------|------------------------------------------------------------------------------------------------------------------|
| **Language**                | `English` (or your preferred language)                                                                           |
| **Mirrors**                 | `Worldwide` auto selection (press Enter)                                                                         |
| **Locales**                 | `en_US.UTF-8` locale and `us` keyboard layout                                                                    |
| **Disk Configuration**      | Select target disk → `Use entire disk` → `ext4` filesystem → optional LUKS encryption (recommended)             |
|                             | Create 512 MiB EFI partition (FAT32) + remaining root partition (ext4).                                          |
|                             | Enable `Swap` → choose swap **file** and set size to `8 GiB`.                                                    |
| **Bootloader**              | `Limine`                                                                                                         |
| **Hostname**                | `piemme-arch` (or preferred hostname)                                                                            |
| **Root password**           | Leave blank to disable root login (press Enter twice)                                                            |
| **User Accounts**           | Add user `piemme` → set password → mark as `Administrator` (wheel group)                                         |
| **Profile**                 | `Minimal`                                                                                                        |
| **Kernel**                  | `linux` (default)                                                                                                |
| **Additional Packages**     | leave empty (bootstrap script installs everything else)                                                          |
| **Network configuration**   | `Use NetworkManager`                                                                                             |
| **Time zone**               | Select your region/city                                                                                           |
| **Services**                | Enable `NetworkManager` (others can stay disabled)                                                               |
| **Additional repositories** | Leave at defaults                                                                                                 |
| **Install**                 | Confirm to start installation                                                                                    |

When the installation completes, choose **`No`** for chroot shell and **`Yes`** to reboot.

## 3. Post-install Checklist

1. Boot into the new system and log in as `piemme`.
2. Ensure the network is active (`nmcli device status`).
3. Clone this repository and run the bootstrap script:
   ```bash
   git clone https://github.com/USERNAME/my-rice.git ~/.local/src/my-rice
   cd ~/.local/src/my-rice
   ./bootstrap/install.sh
   ```
4. Reboot; SDDM should log you into Hyprland automatically.

Document any deviations from these selections so future installs remain reproducible.
