{ lib, ... }:

{
    options = with lib; with types; {
        bwSession = mkOption { type = str; };
    };

    config = {
        bwSession = "";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
