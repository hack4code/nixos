switch:
	nixos-rebuild switch --cores 7 --sudo --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS"
	systemctl --user disable swaync.service

offline:
	nixos-rebuild switch --offline --sudo --impure --show-trace --print-build-logs --verbose --flake ".#KISS"
	systemctl --user disable swaync.service
