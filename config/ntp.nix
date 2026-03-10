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


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
