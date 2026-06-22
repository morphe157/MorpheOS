.DEFAULT_GOAL := build

# Default to the current user; override with `make USERNAME=foo` if needed.
USERNAME ?= $(shell whoami)
GIT_USER ?= $(shell git config user.name)
GIT_EMAIL ?= $(shell git config user.email)

$(info Using username: $(USERNAME))
$(info Using git user: $(GIT_USER))
$(info Using git email: $(GIT_EMAIL))


# Single entry point: `make` works on every platform.
# Auto-detects Darwin / WSL / Apple-Silicon NixOS / Linux desktop and
# runs the right rebuild (with sudo where required) on its own.
NOM := $(shell command -v nom 2>/dev/null || echo "cat")

build: make_config
	@set -e; \
	uname_s=$$(uname -s); \
	if [ "$$uname_s" = "Darwin" ]; then \
		echo "Detected platform: darwin"; \
		sudo NIXPKGS_ALLOW_UNFREE=1 USERNAME=$(USERNAME) darwin-rebuild switch --flake .#$(USERNAME) --impure --show-trace 2>&1 | $(NOM); \
	elif grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then \
		echo "Detected platform: wsl"; \
		sudo NIXPKGS_ALLOW_UNFREE=1 USERNAME=$(USERNAME) nixos-rebuild switch --flake .#wsl --impure 2>&1 | $(NOM); \
	elif [ "$$(uname -m)" = "aarch64" ]; then \
		echo "Detected platform: mac (apple silicon)"; \
		cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix; \
		sudo NIXPKGS_ALLOW_UNFREE=1 USERNAME=$(USERNAME) nixos-rebuild switch --flake .#mac --impure --show-trace 2>&1 | $(NOM); \
	else \
		echo "Detected platform: pc"; \
		cp /etc/nixos/hardware-configuration.nix ./hosts/hardware-configuration.nix; \
		sudo NIXPKGS_ALLOW_UNFREE=1 USERNAME=$(USERNAME) nixos-rebuild switch --flake .#pc --impure 2>&1 | $(NOM); \
	fi

make_config:
	@echo "{" > config.nix
	@echo "  username = \"$(USERNAME)\";" >> config.nix
	@echo "  gituser = \"$(GIT_USER)\";" >> config.nix
	@echo "  gitemail = \"$(GIT_EMAIL)\";" >> config.nix
	@echo "}" >> config.nix

clean:
	sudo nix-collect-garbage -d

check:
	nix build .#nixosConfigurations.pc.config.system.build.toplevel --dry-run --impure

verify:
	nix fmt -- --ci .
	NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.pc.config.system.build.toplevel --dry-run --impure
	NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.wsl.config.system.build.toplevel --dry-run --impure
	if [ "$$(uname -m)" = "aarch64" ]; then \
		NIXPKGS_ALLOW_UNFREE=1 nix build .#nixosConfigurations.mac.config.system.build.toplevel --dry-run --impure; \
	else \
		echo "Skipping mac build — requires aarch64 host"; \
	fi

fmt:
	nix fmt -- .
