{ lib, ... }:

{
    options = with lib; with types; {
        wifiSSID = mkOption { type = str; };
        wifiUUID = mkOption { type = str; };
        wifiPassWord = mkOption { type = str; };
        wifiInterface = mkOption { type = str; };
    };

    config = {
        wifiSSID = "";
        wifiUUID = "";
        wifiPassWord = "";
        wifiInterface = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
