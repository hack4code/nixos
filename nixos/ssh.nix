{ config, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        programs.ssh = {
            enable = true;
            hashKnownHosts = false;

            matchBlocks = {
                linode = {
                    host = "linode";
                    hostname = "10.0.0.1";
                    port = 22;
                    user = "root";
                    addressFamily = "inet";
                    checkHostIP = false;
                    compression = true;
                    forwardX11 = false;
                    serverAliveCountMax = 3;
                    serverAliveInterval = 16;
                    extraOptions = {
                        StrictHostKeyChecking = "no";
                        EnableEscapeCommandline = "yes";
                        UserKnownHostsFile = "/dev/null";
                        PKCS11Provider = "/run/current-system/sw/lib/libtpm2_pkcs11.so";
                    };
                };
            };
        };

        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
