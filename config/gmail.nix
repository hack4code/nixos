{ lib, ... }:

{
    options = with lib; with types; {
        gmailAccount = mkOption { type = str; };
        gmailPassword = mkOption { type = str; };
    };

    config = {
        gmailAccount = "";
        gmailPassword = "";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
