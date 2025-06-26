{ config, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
	home-manager.users.${userName} = {
		programs.git = {
			enable = true;
			userName = "code4hack";
			userEmail = "code4hack+github@gmail.com";
		};

		home.stateVersion  = "${version}";
	};
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
