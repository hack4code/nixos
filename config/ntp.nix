{ lib, ... }:

{
    options = with lib; with types; {
        ntpServers = mkOption { type = listOf str; };
    };

    config = {
        ntpServers = [
            "ntp.tuna.tsinghua.edu.cn"
            "3.de.pool.ntp.org"
        ];
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
