{ lib, ... }:

{
    options = with lib; with types; {
        ffNoticationsAllow = mkOption { type = listOf str; };
        ffHttpAllow = mkOption { type = listOf str; };
        ffCookiesAllow = mkOption { type = listOf str; };
        ffProxyPort = mkOption { type = int; };
    };

    config = {
        ffNoticationsAllow = [ ];
        ffHttpAllow = [ ];
        ffCookiesAllow = [ ];
        ffProxyPort = 0;
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
