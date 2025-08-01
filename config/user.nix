{ lib, ... }:

{
    options = with lib; with types; {
        userName = mkOption { type = str; };
        userPassWord = mkOption { type = str; };
        accountName = mkOption { type = str; };
        userID = mkOption { type = int; };
    };

    config = {
        userName = "e";
        userPassWord = "123456";
        userID = 1000;
        accountName = "code4hack";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
