{ lib, ... }:

{
    options = with lib; with types; {
        userName = mkOption { type = str; };
        accountName = mkOption { type = str; };
        userID = mkOption { type = int; };
    };

    config = {
        userName = "e";
        accountName = "code4hack";
        userID = 1000;
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
