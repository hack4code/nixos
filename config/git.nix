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


# vim: ts=4 sw=4 sts=4 ft=nix et:
