{ lib, ... }:

{
    options = with lib; with types; {
        userName = mkOption { type = str; };
        uid = mkOption { type = int; };
        userPassWord = mkOption { type = str; };
        userHome = mkOption { type = str; };
        userLocation = mkOption { type = str; };
        userAvatarImage = mkOption { type = str; };
    };

    config = {
        userName = "";
        uid = 1000;
        userPassWord = "";
        userHome = "";
        userLocation = "";
        userAvatarImage = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
