switch:
	sudo nixos-rebuild switch --cores 7 --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS"
	systemctl --user disable swaync.service

offline:
	sudo nixos-rebuild switch --offline --impure --show-trace --print-build-logs --verbose --flake ".#KISS"
	systemctl --user disable swaync.service
