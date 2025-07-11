switch:
	nixos-rebuild switch --flake . -L --impure --upgrade --sudo

boot:
	nixos-rebuild boot --flake . -L --impure --upgrade --sudo

update:
	nix flake update
