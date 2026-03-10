update: flake switch

flake:
	env https_proxy=socks5h://10.0.0.1:1080 nix flake update

switch:
	nixos-rebuild switch --sudo --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS"

offline:
	nixos-rebuild switch --sudo --offline --impure --show-trace --print-build-logs --verbose --flake ".#KISS"


# vim: set filetype=make :
