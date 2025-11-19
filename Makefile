update: flake switch
switch: rebuild
offline: rebuild-offline

flake:
	sudo env https_proxy=socks5h://10.0.0.1:1080 nix flake update

systemd:
	systemctl --user disable swaync.service

rebuild:
	# nixos-rebuild switch --sudo --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS"
	sudo nixos-rebuild switch --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS"

rebuild-offline:
	# nixos-rebuild switch --sudo --offline --impure --show-trace --print-build-logs --verbose --flake ".#KISS"
	sudo nixos-rebuild switch --offline --impure --show-trace --print-build-logs --verbose --flake ".#KISS"
