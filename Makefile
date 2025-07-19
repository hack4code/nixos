switch:
	nixos-rebuild switch --impure --sudo --upgrade --print-build-logs --flake .

update:
	nix flake update
