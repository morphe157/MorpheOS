all:
	sudo nixos-rebuild switch --flake .#morphe --impure

clean:
	sudo nix-collect-garbage -d
