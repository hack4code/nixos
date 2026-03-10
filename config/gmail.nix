{ lib, ... }:

{
    options = with lib; with types; {
        gmailAccount = mkOption { type = str; };
        gmailPassword = mkOption { type = str; };
        gmailMailBoxes = mkOption { type = listOf str; };
    };

    config = {
        gmailAccount = "";
        gmailPassword = "";
        gmailMailBoxes = [
        ];
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
