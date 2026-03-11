update: flake switch
update-stable: flake switch-stable

flake:
	env https_proxy=socks5h://10.0.0.1:1080 nix flake update

switch:
	nixos-rebuild switch --sudo --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS-UNSTABLE"

offline:
	nixos-rebuild switch --sudo --offline --impure --show-trace --print-build-logs --verbose --flake ".#KISS-UNSTABLE"

switch-stable:
	nixos-rebuild switch --sudo --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS-STABLE"


# vim: set filetype=make :
