{ lib, ... }:

{
    options = with lib; with types; {
        rtorrentListenPort = mkOption { type = int; };
    };

    config = {
        rtorrentListenPort = 0;
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
