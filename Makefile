switch:
	sudo nixos-rebuild switch --flake . -L --impure --show-trace

boot:
	sudo nixos-rebuild boot --flake . -L --impure --show-trace

update:
	nix flake update
