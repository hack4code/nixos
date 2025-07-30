switch:
	nixos-rebuild switch --sudo --impure --upgrade --print-build-logs --flake .
	systemctl --user disable swaync.service

update:
	nix flake update
