{ lib, ... }:

{
    options = with lib; with types; {
       gmailUserName  = mkOption { type = str; };
       gmailPassword  = mkOption { type = str; };
    };

    config = {
        gmailUserName = "";
        gmailPassword = "";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
