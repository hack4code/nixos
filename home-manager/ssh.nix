{ config, ... }:

let
    userName = config.userName;
    vpsName = config.vpsName;
in
{
    home-manager.users.${userName} = {
        programs.ssh = {
            enable = true;
            enableDefaultConfig = false;

            matchBlocks = {
                "${vpsName}" = {
                    host = "${vpsName}";
                    hostname = "10.0.0.1";
                    port = 22;
                    user = "root";
                    addressFamily = "inet";
                    checkHostIP = false;
                    compression = true;
                    forwardX11 = false;
                    hashKnownHosts = false;
                    serverAliveCountMax = 3;
                    serverAliveInterval = 16;
                    extraOptions = {
                        LogLevel = "QUIET";
                        StrictHostKeyChecking = "no";
                        EnableEscapeCommandline = "yes";
                        UserKnownHostsFile = "/dev/null";
                        PKCS11Provider = "/run/current-system/sw/lib/libtpm2_pkcs11.so";
                    };
                };
            };
        };

    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
