UNAME_S := $(shell uname -s)
$(info Detected os: $(UNAME_S))
$(info Using username: ${USERNAME})


ifeq ($(UNAME_S),Darwin)
build: check-user-provided make_config
	NIXPKGS_ALLOW_UNFREE=1 USERNAME=$(USERNAME) darwin-rebuild switch --flake .#$(USERNAME) --impure --show-trace
else
build: check-user-provided make_config
	NIXPKGS_ALLOW_UNFREE=1 USERNAME=$(USERNAME) sudo nixos-rebuild switch --flake .#pc --impure
endif

wsl: check-user-provided make_config
	USERNAME=$(USERNAME) sudo nixos-rebuild switch --flake .#wsl --impure

make_config:
	@echo "{" > config.nix
	@echo "  username = \"${USERNAME}\";" >> config.nix
	@echo "  gituser = \"${GITUSER}\";" >> config.nix
	@echo "  gitemail = \"${GITEMAIL}\";" >> config.nix
	@echo "}" >> config.nix

clean:
	sudo nix-collect-garbage -d

check-user-provided:
ifndef USERNAME
	$(error "Please provide USERNAME env variable, e.g. ./make USERNAME=myuser")
endif
