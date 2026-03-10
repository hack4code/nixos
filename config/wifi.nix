{ lib, ... }:

{
    options = with lib; with types; {
        wifiSSID = mkOption { type = str; };
        wifiUUID = mkOption { type = str; };
        wifiPassWord = mkOption { type = str; };
        wifiInterface = mkOption { type = str; };
    };

    config = {
        wifiSSID = "TP-LINK_1225";
        wifiUUID = "b4447384-06e8-4ef3-8689-f68589f1537c";
        wifiPassWord = "123456";
        wifiInterface = "wlan0";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
