update: flake switch

switch:
	sudo nixos-rebuild switch --cores 7 --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS"
	systemctl --user disable swaync.service

offline:
	sudo nixos-rebuild switch --offline --impure --show-trace --print-build-logs --verbose --flake ".#KISS"
	systemctl --user disable swaync.service

flake:
	sudo env https_proxy=socks5h://10.0.0.1:1080 nix flake update
