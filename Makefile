switch:
	nixos-rebuild switch --sudo --impure --flake .
	systemctl --user disable swaync.service

offline:
	nixos-rebuild switch --offline --sudo --impure --flake .
	systemctl --user disable swaync.service
