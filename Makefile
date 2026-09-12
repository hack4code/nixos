update: flake switch
update-stable: flake boot-stable


enable_idleInhibitor:
	noctalia-shell ipc call idleInhibitor enable

disable_idleInhibitor:
	noctalia-shell ipc call idleInhibitor disable

flake:
	env https_proxy=socks5h://10.0.0.1:1080 nix flake update

boot:
	nixos-rebuild boot --sudo --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS-UNSTABLE"

boot-stable:
	nixos-rebuild boot --sudo --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS-STABLE"

switch:
	nixos-rebuild switch --sudo --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS-UNSTABLE"

offline:
	nixos-rebuild switch --sudo --offline --impure --show-trace --print-build-logs --verbose --flake ".#KISS-UNSTABLE"

switch-stable:
	nixos-rebuild switch --sudo --impure --use-substitutes --show-trace --print-build-logs --verbose --flake ".#KISS-STABLE"


# vim: set filetype=make :
