{ config, pkgs, lib, ... }:

{
    options = with lib; with types; {
        ntpServers = mkOption { type = listOf str; };
    };

    config = {
        ntpServers = [
            "0.us.pool.ntp.org"
            "1.us.pool.ntp.org"
            "2.us.pool.ntp.org"
            "3.us.pool.ntp.org"
        ];
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
