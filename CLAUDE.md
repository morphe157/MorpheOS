# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

MorpheOS is a declarative system configuration managed with Nix Flakes. It targets four platforms: macOS via nix-darwin (`darwin`), NixOS on Apple Silicon (`mac`), Linux desktop (`pc`), and WSL (`wsl`). Almost everything is written in Nix.

## Common Commands

```bash
# Apply configuration (auto-detects Darwin vs Linux)
make build USERNAME=morphe

# macOS (nix-darwin)
make mac USERNAME=morphe

# WSL
make wsl USERNAME=morphe

# Format all Nix files
make fmt

# Dry-run check (no build)
make check

# Garbage collect
make clean
```

CI runs `nix fmt -- --check .` and builds all three NixOS configurations on every push.

## Architecture

```
flake.nix                  ← entry point; defines all inputs and outputs
config.nix                 ← runtime values (username, git user/email)
hosts/                     ← OS-level config per platform (bootloader, hardware, services)
modules/                   ← reusable NixOS modules (hyprland, nvidia, sshfs, kotlin_lsp)
home-manager/              ← user environment (common.nix + per-platform home.nix)
configs/                   ← program configs passed to home-manager (neovim, terminal, WMs)
overlays/                  ← nixpkgs package overrides
lib/morphe.nix             ← shared helper functions for home-manager wiring
```

**Layer order:** `flake.nix` composes `hosts/` (system) + `home-manager/` (user) + `modules/` + `configs/`. App configs in `configs/` are not standalone — they are imported by the home-manager files.

## Neovim Configuration

`configs/neovim/` is a large Nixvim-based setup split into ~10 subdirectories:

- `default.nix` — main entry point, imports all submodules
- `lsp.nix` — LSP servers (Kotlin, Python, Nix, Java, TypeScript, HTML)
- `dap.nix` — Debug Adapter Protocol
- `ai.nix` — AI integrations
- `keymaps.nix` — keybindings (reference: `docs/keymaps.md`)
- `modules/` — individual plugin configs (Telescope, Oil, Treesitter, Snacks, Lspsaga, Rustaceanvim, etc.)

## Platform Differences

| Feature | darwin | mac | pc | wsl |
|---|---|---|---|---|
| Window manager | AeroSpace | Hyprland | Hyprland | — |
| Status bar | Sketchybar | Waybar | Waybar | — |
| Display | macOS native | single monitor | dual 1080p (240+144Hz) | — |
| Special | Homebrew, nix-darwin | nixos-apple-silicon, SSHFS | Nvidia drivers, auto-login | minimal |

Shared packages (fastfetch, tgpt, glow, rbw, rustup, etc.) live in `home-manager/common.nix`. Platform-specific packages go in the respective `home-mac.nix` / `home.nix` / `home-wsl.nix`.

## Nix Flake Inputs

Key inputs: `nixpkgs`, `home-manager`, `nixvim`, `stylix` (theming), `nix-darwin`, `nixos-apple-silicon`. Pin changes require `nix flake update` and rebuilding.
