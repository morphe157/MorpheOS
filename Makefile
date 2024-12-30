all:
	sudo nixos-rebuild switch --flake .#pc --impure

mac:
	sudo nixos-rebuild switch --flake .#mac --impure

clean:
	sudo nix-collect-garbage -d

