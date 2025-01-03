all:
	sudo nixos-rebuild switch --flake .#pc --impure

mac:
	sudo nixos-rebuild switch --flake .#mac --impure

clean:
	sudo nix-collect-garbage -d

hm:
	NIXPKGS_ALLOW_UNFREE=1 home-manager switch --flake .#mburdyna@mac --impure
