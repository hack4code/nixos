{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.ripgrep = {
            enable = true;

            arguments = [
                # "--max-columns-preview"
                "--colors=line:style:bold"
            ];
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
