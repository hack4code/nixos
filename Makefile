switch:
	nixos-rebuild switch --impure --sudo --upgrade --print-build-logs --flake .
	systemctl --user disable swaync.service

update:
	nix flake update
