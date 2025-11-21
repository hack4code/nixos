update: flake switch

flake:
	sudo env https_proxy=socks5h://10.0.0.1:1080 nix flake update

switch:
	sudo nixos-rebuild switch --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS"

offline:
	sudo nixos-rebuild switch --offline --impure --show-trace --print-build-logs --verbose --flake ".#KISS"
