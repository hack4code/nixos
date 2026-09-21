{ lib, ... }:

{
    options = with lib; with types; {
        eGPU = mkOption { type = str; };
        eGPUPciID = mkOption { type = str; };
    };

    config = {
        eGPU = "";
        eGPUPciID = "";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
