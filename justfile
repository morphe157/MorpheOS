# Color variables for terminal output
_bold := "\\033[1m"
_reset := "\\033[0m"
_green := "\\033[32m"
_cyan := "\\033[36m"
_yellow := "\\033[33m"
_red := "\\033[31m"
_blue := "\\033[34m"
_magenta := "\\033[35m"

# Default: build (bare `just` runs this)
default:
  @just build

username := env_var_or_default('USERNAME', shell('whoami'))
git_user := env_var_or_default('GIT_USER', shell('git config user.name'))
git_email := env_var_or_default('GIT_EMAIL', shell('git config user.email'))
nom := if shell('command -v nom 2>/dev/null') == '' { 'cat' } else { 'nom' }

# Apply configuration (auto-detects Darwin vs Linux vs WSL)
build:
  #!/usr/bin/env bash
  set -euo pipefail
  export USERNAME="{{username}}" GIT_USER="{{git_user}}" GIT_EMAIL="{{git_email}}"
  case "$(uname -s)" in
    Darwin)
      echo -e "\n{{_bold}}{{_blue}}━━━  Platform: macOS (nix-darwin)  ━━━{{_reset}}"
      NIXPKGS_ALLOW_UNFREE=1 nix build \
        ".#darwinConfigurations.{{username}}.system" \
        --no-link --impure --show-trace --log-format internal-json -v \
        2>&1 | {{nom}} --json
      sudo NIXPKGS_ALLOW_UNFREE=1 USERNAME="{{username}}" \
        darwin-rebuild activate --flake .#"{{username}}" --impure
      echo -e "{{_green}}✓ Build complete{{_reset}}\n"
      ;;
    *)
      if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
        echo -e "\n{{_bold}}{{_cyan}}━━━  Platform: WSL  ━━━{{_reset}}"
        sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#wsl --impure 2>&1 | {{nom}}
        echo -e "{{_green}}✓ Build complete{{_reset}}\n"
      elif [ "$(uname -m)" = "aarch64" ]; then
        echo -e "\n{{_bold}}{{_magenta}}━━━  Platform: macOS (Apple Silicon)  ━━━{{_reset}}"
        sudo cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix
        sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#mac --impure --show-trace 2>&1 | {{nom}}
        echo -e "{{_green}}✓ Build complete{{_reset}}\n"
      else
        echo -e "\n{{_bold}}{{_yellow}}━━━  Platform: PC (NixOS)  ━━━{{_reset}}"
        sudo cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix
        sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#pc --impure 2>&1 | {{nom}}
        echo -e "{{_green}}✓ Build complete{{_reset}}\n"
      fi
      ;;
  esac

# macOS (nix-darwin) shortcut
mac:
  echo -e "\n{{_bold}}{{_blue}}━━━  nix-darwin build  ━━━{{_reset}}"
  USERNAME="{{username}}" GIT_USER="{{git_user}}" GIT_EMAIL="{{git_email}}" \
    NIXPKGS_ALLOW_UNFREE=1 nix build \
    ".#darwinConfigurations.{{username}}.system" \
    --no-link --impure --show-trace --log-format internal-json -v \
    2>&1 | {{nom}} --json
  sudo USERNAME="{{username}}" GIT_USER="{{git_user}}" GIT_EMAIL="{{git_email}}" \
    NIXPKGS_ALLOW_UNFREE=1 \
    darwin-rebuild activate --flake .#"{{username}}" --impure
  echo -e "{{_green}}✓ Done{{_reset}}\n"

# WSL shortcut
wsl:
  echo -e "\n{{_bold}}{{_cyan}}━━━  WSL rebuild  ━━━{{_reset}}"
  sudo USERNAME="{{username}}" GIT_USER="{{git_user}}" GIT_EMAIL="{{git_email}}" \
    NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#wsl --impure 2>&1 | {{nom}}
  echo -e "{{_green}}✓ Done{{_reset}}\n"

# Bootstrap Nix flakes on a fresh system (idempotent)
enable-flakes:
  #!/usr/bin/env bash
  set -euo pipefail
  conf=/etc/nix/nix.conf
  line="experimental-features = nix-command flakes"
  if [ -f "$conf" ] && grep -qF "$line" "$conf"; then
    echo -e "{{_green}}✓ Flakes already enabled{{_reset}}"
    exit 0
  fi
  echo -e "{{_yellow}}⟳ Enabling flakes...{{_reset}}"
  sudo mkdir -p /etc/nix
  echo "$line" | sudo tee -a "$conf" > /dev/null
  if command -v systemctl &>/dev/null; then
    echo -e "{{_yellow}}⟳ Restarting nix-daemon...{{_reset}}"
    sudo systemctl restart nix-daemon
  elif command -v launchctl &>/dev/null; then
    echo -e "{{_yellow}}⟳ Restarting nix-daemon...{{_reset}}"
    sudo launchctl kickstart -k system/org.nixos.nix-daemon
  fi
  echo -e "{{_green}}✓ Done. Run '{{_bold}}just build{{_reset}}{{_green}}' to apply config.{{_reset}}"

# Format all Nix files
fmt:
  @echo -e '{{_bold}}{{_cyan}}━━━  nix fmt  ━━━{{_reset}}'
  nix fmt -- .

# Dry-run check (no build)
check:
  @echo -e '{{_bold}}{{_yellow}}━━━  Dry-run check  ━━━{{_reset}}'
  USERNAME="{{username}}" GIT_USER="{{git_user}}" GIT_EMAIL="{{git_email}}" \
    nix build .#nixosConfigurations.pc.config.system.build.toplevel --dry-run --impure

# Garbage collect
clean:
  @echo -e '{{_bold}}{{_red}}━━━  nix-collect-garbage  ━━━{{_reset}}'
  sudo nix-collect-garbage -d

# Full verify (format + all hosts dry-run)
verify:
  #!/usr/bin/env bash
  set -euo pipefail
  export USERNAME="{{username}}" GIT_USER="{{git_user}}" GIT_EMAIL="{{git_email}}"
  echo -e "\n{{_bold}}{{_cyan}}═══  Verify: Format check  ═══{{_reset}}"
  nix fmt -- --ci .
  echo -e "{{_green}}✓ Format OK{{_reset}}"
  echo -e "\n{{_bold}}{{_cyan}}═══  Verify: PC  ═══{{_reset}}"
  NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.pc.config.system.build.toplevel --dry-run --impure
  echo -e "{{_green}}✓ PC OK{{_reset}}"
  echo -e "\n{{_bold}}{{_cyan}}═══  Verify: WSL  ═══{{_reset}}"
  NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.wsl.config.system.build.toplevel --dry-run --impure
  echo -e "{{_green}}✓ WSL OK{{_reset}}"
  if [ "$(uname -m)" = "aarch64" ]; then
    echo -e "\n{{_bold}}{{_cyan}}═══  Verify: Mac  ═══{{_reset}}"
    NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.mac.config.system.build.toplevel --dry-run --impure
    echo -e "{{_green}}✓ Mac OK{{_reset}}"
  else
    echo -e "{{_yellow}}⚠ Skipping Mac — requires aarch64 host{{_reset}}"
  fi
  echo -e "\n{{_green}}{{_bold}}✓ All checks passed{{_reset}}"


