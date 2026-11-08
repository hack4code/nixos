{ lib, ... }:

{
    options = with lib; with types; {
        kernelVersion = mkOption { type = str; };
        kernelHash = mkOption { type = str; };
        kernelUrl = mkOption { type = str; };
    };

    config = {
        kernelVersion = "";
        kernelHash = "";
        kernelUrl = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
