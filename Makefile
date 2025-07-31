switch:
	nixos-rebuild switch --sudo --impure --use-substitutes --print-build-logs --flake .
	systemctl --user disable swaync.service

config:
	nixos-rebuild switch --sudo --impure --no-net --print-build-logs --flake .
	systemctl --user disable swaync.service

test:
	nixos-rebuild test --sudo --impure --use-substitutes --print-build-logs --flake .
