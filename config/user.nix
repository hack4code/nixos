{ lib, ... }:

{
    options = with lib; with types; {
        userName = mkOption { type = str; };
        uid = mkOption { type = int; };
        userPassWord = mkOption { type = str; };
        userHome = mkOption { type = str; };
    };

    config = rec {
        userName = "e";
        uid = 1000;
        userPassWord = "123456";
        userHome = "/home/${userName}";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
