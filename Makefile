switch:
	nixos-rebuild switch --sudo --impure --flake .
	systemctl --user disable swaync.service

offline:
	nixos-rebuild switch --offline --sudo --impure --flake .
	systemctl --user disable swaync.service

update:
	export http_proxy="socks5://127.0.0.1:1080"
	export https_proxy="socks5://127.0.0.1:1080"
	nix flake update
	unset http_proxy
	unset https_proxy
