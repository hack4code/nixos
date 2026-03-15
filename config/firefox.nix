{ lib, ... }:

{
    options = with lib; with types; {
        ffNoticationsAllow = mkOption { type = listOf str; };
        ffHttpAllow = mkOption { type = listOf str; };
        ffCookiesAllow = mkOption { type = listOf str; };
    };

    config = {
        ffNoticationsAllow = [ ];
        ffHttpAllow = [ ];
        ffCookiesAllow = [ ];
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
