# Agent Guidelines

Welcome! This repository defines a streamlined Arch Linux rice focused on a reproducible Hyprland workstation for the user **piemme**. Observe the rules below when modifying the project.

## Scope
- Target system: vanilla Arch installed via `archinstall`, followed by this repo's bootstrap script. Do **not** modify or replace the base installer from within this project.
- Desktop stack: Hyprland (tiling WM), Wayland utilities, Firefox as default browser, Neovim with LazyVim, Catppuccin-only theming.
- Hardware: standard x86_64 laptops (ThinkPad/Framework, AMD preferred). Avoid introducing vendor-specific tweaks unless explicitly requested.

## Directories & Ownership
- `bootstrap/` — post-install automation. Keep the primary entry point at `bootstrap/install.sh`. Additional scripts go in this folder only if they are part of the bootstrap pipeline.
- `configs/` — user-level configuration files mirroring the XDG layout. Hyprland config is split into `general.conf`, `input.conf`, etc., with `hyprland.conf` sourcing them. Place helper scripts that configs call inside `configs/bin/`.
- `packages/` — curated package manifests (`pacman.txt`, `aur.txt`). Any change to installed software must flow through these files and the bootstrap script.
- `themes/catppuccin/` — the only active theme. Do not add extra themes without prior agreement.
- `docs/` — documentation. Update the appropriate doc whenever adding, removing, or altering a component or workflow.

## Conventions
- Default shell is **bash**; keep scripts POSIX-friendly where possible.
- Reuse Omarchy keybindings and UX patterns unless a change is called out in issues or README.
- Maintain Catppuccin styling across configs; when adding new tools ensure their theme aligns. Theme assets live in `themes/catppuccin/` and are linked to `~/.config/myrice/current/theme`. Wallpapers default to `backgrounds/default.jpg`.
- Log installer progress using the same pattern as Omarchy (gum-based UI plus `/var/log/myrice-install.log`).
- `bootstrap/install.sh` copies configs into place and refreshes theme symlinks—keep that flow when adding new assets.
- Username/email defaults in scripts: `piemme` / `gaudichau.pierremalo@gmail.com` — avoid prompting for them unless requirements change.

## Documentation Requirements
- Every material change to packages, configs, or automation must be reflected in `README.md` (overview) and `docs/choices.md` (rationale).
- For new troubleshooting steps or known issues update `docs/troubleshooting.md`.
- When adding scripts or configs introduce inline comments only if necessary; prefer explaining intent in docs.

## Out of Scope
- Multi-theme support, Omarchy-specific binaries, or unrelated desktop environments are intentionally excluded.
- Secrets, API tokens, or machine-specific credentials must never be committed.

Thanks for keeping the project focused and reproducible!