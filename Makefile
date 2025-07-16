switch:
	nixos-rebuild switch --flake . -L --impure --sudo --upgrade

boot:
	nixos-rebuild boot --flake . -L --impure --sudo

update:
	nix flake update
