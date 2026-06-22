# Default: build (bare `just` runs this)
default:
  @just build

username := env_var_or_default('USERNAME', shell('whoami'))
git_user := env_var_or_default('GIT_USER', shell('git config user.name'))
git_email := env_var_or_default('GIT_EMAIL', shell('git config user.email'))
nom := if shell('command -v nom 2>/dev/null') == '' { 'cat' } else { 'nom' }

# Write config.nix from runtime values
_write_config:
  printf '{\n  username = "%s";\n  gituser = "%s";\n  gitemail = "%s";\n}\n' '{{username}}' '{{git_user}}' '{{git_email}}' > config.nix

# Apply configuration (auto-detects Darwin vs Linux vs WSL)
build: _write_config
  #!/usr/bin/env bash
  set -euo pipefail
  case "$(uname -s)" in
    Darwin)
      echo "Detected platform: darwin"
      sudo NIXPKGS_ALLOW_UNFREE=1 USERNAME="{{username}}" darwin-rebuild switch --flake .#"{{username}}" --impure --show-trace 2>&1 | {{nom}}
      ;;
    *)
      if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
        echo "Detected platform: wsl"
        sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#wsl --impure 2>&1 | {{nom}}
      elif [ "$(uname -m)" = "aarch64" ]; then
        echo "Detected platform: mac (apple silicon)"
        sudo cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix
        sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#mac --impure --show-trace 2>&1 | {{nom}}
      else
        echo "Detected platform: pc"
        sudo cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix
        sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#pc --impure 2>&1 | {{nom}}
      fi
      ;;
  esac

# macOS (nix-darwin) shortcut
mac: _write_config
  sudo NIXPKGS_ALLOW_UNFREE=1 USERNAME="{{username}}" darwin-rebuild switch --flake .#"{{username}}" --impure --show-trace 2>&1 | {{nom}}

# WSL shortcut
wsl: _write_config
  sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#wsl --impure 2>&1 | {{nom}}

# Bootstrap Nix flakes on a fresh system (idempotent)
enable-flakes:
  #!/usr/bin/env bash
  set -euo pipefail
  conf=/etc/nix/nix.conf
  line="experimental-features = nix-command flakes"
  if [ -f "$conf" ] && grep -qF "$line" "$conf"; then
    echo "Flakes already enabled"
    exit 0
  fi
  echo "Enabling flakes..."
  sudo mkdir -p /etc/nix
  echo "$line" | sudo tee -a "$conf" > /dev/null
  if command -v systemctl &>/dev/null; then
    sudo systemctl restart nix-daemon
  elif command -v launchctl &>/dev/null; then
    sudo launchctl kickstart -k system/org.nixos.nix-daemon
  fi
  echo "Done. Run 'just build' to apply config."

# Format all Nix files
fmt:
  nix fmt -- .

# Dry-run check (no build)
check:
  nix build .#nixosConfigurations.pc.config.system.build.toplevel --dry-run --impure

# Garbage collect
clean:
  sudo nix-collect-garbage -d

# Full verify (format + all hosts dry-run)
verify:
  #!/usr/bin/env bash
  set -euo pipefail
  nix fmt -- --ci .
  NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.pc.config.system.build.toplevel --dry-run --impure
  NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.wsl.config.system.build.toplevel --dry-run --impure
  if [ "$(uname -m)" = "aarch64" ]; then
    NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.mac.config.system.build.toplevel --dry-run --impure
  else
    echo "Skipping mac build — requires aarch64 host"
  fi


