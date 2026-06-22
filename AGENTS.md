# MorpheOS

**Generated:** 2026-06-23
**Commit:** 9751786
**Branch:** master

## OVERVIEW

Nix flake managing 4 system targets (NixOS PC/WSL/Mac + nix-darwin) plus home-manager user envs. Pure Nix — zero TS/Py/Rust.

## STRUCTURE

```
./
├── configs/           # Per-app Nix module configs (39 files, 8 subdirs)
│   ├── neovim/        # nixvim: lsp/cmp/dap/keymaps + per-plugin modules
│   ├── sketchybar/    # Shell scripts + rc for macOS menu bar
│   ├── terminal/      # ghostty/tmux/shell/jetpack configs
│   └── waybar/        # Waybar bar + weather widget
├── hosts/             # Host-specific configs (darwin/mac/pc/wsl)
├── home-manager/      # User envs: Linux, macOS, WSL + shared common.nix
├── modules/           # Custom NixOS modules (hyprland/nvidia/sshfs/kotlin_lsp)
├── lib/               # Shared lib: mkHomeManagerModule helpers
├── codelldb/          # codelldb Nix package derivation
├── docs/              # keymaps.md + empty superpowers scaffolding
├── assets/            # Wallpapers (jpg, png)
├── .github/           # CI: format check + dry-run build on push/PR
├── .omo/              # OpenCode session continuation data (gitignored)
├── flake.nix          # Entry point: 3 nixosConfigurations + darwinConfigurations
└── justfile           # Build runner (just build/fmt/verify/clean)
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add system package/service | `hosts/<name>.nix` | Import configs/ for app configs |
| Add user package/program | `home-manager/home*.nix` or `common.nix` | common.nix for shared across hosts |
| Add app config | `configs/<app>.nix` | Named after app, imported by hosts |
| Configure neovim LSP | `configs/neovim/lsp.nix` | Per-LSP enable/disable |
| Configure neovim plugin | `configs/neovim/modules/plugins/<name>.nix` | One file per plugin |
| Add/modify NixOS module | `modules/<name>.nix` | Define options + config |
| Add lib helper | `lib/morphe.nix` | Shared across all hosts |
| CI/CD | `.github/workflows/check.yml` | Format + dry-run build |
| Build/format/verify | `justfile` | `just build`, `just fmt`, `just verify` |

## CONVENTIONS

- **One `.nix` file per app config** in `configs/`. Named after the application.
- **Neovim plugins** get one file each in `configs/neovim/modules/plugins/`.
- **Host configs** at `hosts/<name>.nix` — import `configs/` and `modules/`. No inline app config.
- **home-manager variants** replicate the Linux/macOS/WSL split from hosts.
- **`common.nix`** for shared user config across all platforms (git, dev tools).
- **`flake.nix`** declares all inputs centrally. No `builtins.fetchGit` on NixOS hosts.
- **`justfile`** auto-detects platform, single `just build` everywhere.
- **Nix formatter**: `nixfmt` (`nix fmt`).
- **Nix linter**: `statix` via devShell + Neovim LSP.
- **Shell scripts** in `configs/sketchybar/` for macOS menu bar widgets.
- **Runtime identity** (username/gituser/gitemail) passed via env vars using `builtins.getEnv` + `--impure`. `justfile` exports them from `env_var_or_default` fallbacks (whoami, git config).

## ANTI-PATTERNS (THIS PROJECT)

- **`builtins.fetchGit` without rev pin** — breaks reproducibility. Home-mac.nix and home-wsl.nix use it for nixvim. Fix: use flake input like NixOS hosts.
- **Impure `--impure` flag** — required for `builtins.getEnv` to work. Acceptable tradeoff for portability.
- **SketchyBar shell bugs**: unquoted vars in `battery.sh`, stale `$?` check in `cpu_temperature.sh`.
- **Disabled copilot-lua in cmp.nix** with "re-enable after hash update" — unactioned upstream drift.
- **Empty scaffolding dirs**: `docs/superpowers/plans/`, `docs/superpowers/specs/` — remove or fill.
- **No README.md or LICENSE** at root.

## COMMANDS

```bash
just build       # Auto-detect platform, apply config
just mac         # nix-darwin build + activate
just wsl         # NixOS-WSL rebuild
just fmt         # nix fmt -- .
just verify      # Format check + dry-run all hosts
just check       # Dry-run PC build only
just clean       # nix-collect-garbage -d
nix fmt          # Format all Nix files (formatter = nixfmt)
```

## NOTES

- Runtime identity (username/gituser/gitemail) injected via `builtins.getEnv`. `just build` exports env vars from `env_var_or_default` fallbacks — no generated file needed.
- No test framework exists — validation = `nix build` success + `nix fmt` compliance.
- darwin host uses `darwin-rebuild`, NixOS hosts use `nixos-rebuild switch`.
- `docs/gen_doc.sh` uses legacy `nix-instantiate --strict --json --eval` — update to `nix eval`.
- `.omo/` directory holds OpenCode agent session state — gitignored, not project config.
- **After touching `.nix` files**, run `just verify` (format check + dry-run all hosts).
