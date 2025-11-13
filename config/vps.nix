{ lib, ... }:

{
    options = with lib; with types; {
        vpsName = mkOption { type = str; };
    };

    config = {
        vpsName = "NULL";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
