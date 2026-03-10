{ lib, ... }:

{
    options = with lib; with types; {
        gitUser = mkOption { type = str; };
        gitEmail = mkOption { type = str; };
    };

    config = {
        gitUser = "";
        gitEmail = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
