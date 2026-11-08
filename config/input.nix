{ lib, ... }:

{
    options = with lib; with types; {
        keyboard = mkOption { type = str; };
        cherry = mkOption { type = str; };
        touchpad = mkOption { type = str; };
        trackpoint = mkOption { type = str; };
    };

    config = {
        keyboard = "";
        cherry = "";
        touchpad = "";
        trackpoint = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
