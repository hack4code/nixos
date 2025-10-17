update: flake switch
switch: rebuild systemd
offline: rebuild-offline systemd

flake:
	env https_proxy=socks5h://10.0.0.1:1080 nix flake update

systemd:
	systemctl --user disable swaync.service

rebuild:
	# sudo nixos-rebuild switch --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS-STABLE"
	nixos-rebuild switch --sudo --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS-UNSTABLE"

rebuild-offline:
	# sudo nixos-rebuild switch --offline --impure --show-trace --print-build-logs --verbose --flake ".#KISS-STABLE"
	nixos-rebuild switch --sudo --offline --impure --show-trace --print-build-logs --verbose --flake ".#KISS-UNSTABLE"
