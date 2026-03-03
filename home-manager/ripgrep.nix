{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.ripgrep = {
            enable = true;

            arguments = [
                "--max-columns-preview"
                "--colors=line:style:bold"
            ];
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
