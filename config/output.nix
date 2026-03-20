{ lib, ... }:

{
    options = with lib; with types; {
        monitorThinkpad = mkOption { type = str; };
        monitorSamsung = mkOption { type = str; };
        bgThinkpad = mkOption { type = str; };
        bgSamsung = mkOption { type = str; };
    };

    config = {
        monitorThinkpad = "";
        monitorSamsung = "";
        bgThinkpad = "";
        bgSamsung = "";
        bgLock = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
