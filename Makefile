switch:
	sudo nixos-rebuild switch --flake . -L --impure

boot:
	sudo nixos-rebuild boot --flake . -L --impure

update:
	nix flake update
