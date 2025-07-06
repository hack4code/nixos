{ config, pkgs, lib, ... }:

{
    options = with lib; with types; {
        ntpServers = mkOption { type = listOf str; };
    };

    config = {
        ntpServers = [
            "0.de.pool.ntp.org"
            "1.de.pool.ntp.org"
            "2.de.pool.ntp.org"
            "3.de.pool.ntp.org"
        ];
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
