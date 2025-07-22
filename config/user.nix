{ lib, ... }:

{
    options = with lib; with types; {
        userName = mkOption { type = str; };
        accountName = mkOption { type = str; };
    };

    config = {
        userName = "e";
        accountName = "code4hack";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
