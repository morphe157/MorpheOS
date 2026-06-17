.DEFAULT_GOAL := build

# Default to the current user; override with `make USERNAME=foo` if needed.
USERNAME ?= $(shell whoami)

$(info Using username: $(USERNAME))

# Single entry point: `make` works on every platform.
# Auto-detects Darwin / WSL / Apple-Silicon NixOS / Linux desktop and
# runs the right rebuild (with sudo where required) on its own.
build: make_config
	@set -e; \
	uname_s=$$(uname -s); \
	if [ "$$uname_s" = "Darwin" ]; then \
		echo "Detected platform: darwin"; \
		sudo NIXPKGS_ALLOW_UNFREE=1 USERNAME=$(USERNAME) darwin-rebuild switch --flake .#$(USERNAME) --impure --show-trace; \
	elif grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then \
		echo "Detected platform: wsl"; \
		sudo NIXPKGS_ALLOW_UNFREE=1 USERNAME=$(USERNAME) nixos-rebuild switch --flake .#wsl --impure; \
	elif [ "$$(uname -m)" = "aarch64" ]; then \
		echo "Detected platform: mac (apple silicon)"; \
		cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix; \
		sudo NIXPKGS_ALLOW_UNFREE=1 USERNAME=$(USERNAME) nixos-rebuild switch --flake .#mac --impure; \
	else \
		echo "Detected platform: pc"; \
		cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix; \
		sudo NIXPKGS_ALLOW_UNFREE=1 USERNAME=$(USERNAME) nixos-rebuild switch --flake .#pc --impure; \
	fi

make_config:
	@echo "{" > config.nix
	@echo "  username = \"$(USERNAME)\";" >> config.nix
	@echo "  gituser = \"$(GITUSER)\";" >> config.nix
	@echo "  gitemail = \"$(GITEMAIL)\";" >> config.nix
	@echo "}" >> config.nix

clean:
	sudo nix-collect-garbage -d

check:
	nix build .#nixosConfigurations.pc.config.system.build.toplevel --dry-run --impure

fmt:
	nix fmt -- --impure
