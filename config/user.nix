{ lib, ... }:

{
    options = with lib; with types; {
        userName = mkOption { type = str; };
        groupName = mkOption { type = str; };
        userPassWord = mkOption { type = str; };
        accountName = mkOption { type = str; };
        uid = mkOption { type = int; };
        gid = mkOption { type = int; };
    };

    config = {
        userName = "e";
        groupName = "e";
        userPassWord = "123456";
        uid = 1000;
        gid = 1000;
        accountName = "code4hack";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
