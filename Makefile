.PHONY: all

UNAME_S := $(shell uname -s)
$(info Detected os: $(UNAME_S))
$(info Using username: ${USER})


ifeq ($(UNAME_S),Darwin)
build: check-user-provided make_config
	NIXPKGS_ALLOW_UNFREE=1 USER=$(USER) darwin-rebuild switch --flake .#$(USER) --impure --show-trace
else
build: check-user-provided make_config
	NIXPKGS_ALLOW_UNFREE=1 USER=$(USER) sudo nixos-rebuild switch --flake .#pc --impure
endif

all: build

make_config:
	echo "{" > config.nix
	echo "  username = \"${USER}\";" >> config.nix
	echo "}" >> config.nix

clean:
	sudo nix-collect-garbage -d

check-user-provided:
ifndef USER
	$(error "Please provide USER env variable, e.g. ./make USER=myuser")
endif
