{ lib, ... }:

{
    options = with lib; with types; {
        ntpServers = mkOption { type = listOf str; };
    };

    config = {
        ntpServers = [
        ];
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
