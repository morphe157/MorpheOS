.PHONY: all


UNAME_S := $(shell uname -s)
$(info Detected os: $(UNAME_S))
$(info Using username: $(USERNAME))
ifeq ($(UNAME_S),Darwin)
build: check-user-provided
	NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#$(USERNAME) --impure --show-trace
else
build: check-user-provided
	NIXPKGS_ALLOW_UNFREE=1 sudo nixos-rebuild switch --flake .#pc --impure --show-trace
endif

all: build

clean:
	sudo nix-collect-garbage -d

check-user-provided:
ifndef USERNAME
	$(error "Please provide USERNAME env variable, e.g. ./make USERNAME=myuser")
endif
