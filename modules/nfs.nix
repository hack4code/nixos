{ config, ... }:

let
    userHome = config.userHome;
in
{
    fileSystems."/export/wireguard" = {
        depends = [
            "/"
            "/home"
        ];
        device = "${userHome}/source/nixos/extra/vps/wireguard";
        options = [
            "bind"
            "nfsvers=4.2"
        ];
    };

    fileSystems."/export/docker" = {
        depends = [
            "/"
            "/home"
        ];
        device = "${userHome}/source/nixos/extra/vps/docker";
        options = [
            "bind"
            "nfsvers=4.2"
        ];
    };

    fileSystems."/export/spider" = {
        depends = [
            "/"
            "/home"
        ];
        device = "${userHome}/source/spider";
        options = [
            "bind"
            "nfsvers=4.2"
        ];
    };

    services.rpcbind.enable = true;

    services.nfs.idmapd.settings = {
        General = {
            Domain = "KISS.me";
        };

        Mapping = {
            Nobody-User = "nobody";
            Nobody-Group = "nogroup";
        };

        Translation = {
            GSS-Methods = "static,nsswitch";
        };
    };

    services.nfs.server = {
        enable = true;
        nproc = 1;
        exports = ''
            /export/docker 10.0.0.1(rw,no_root_squash,nohide,insecure,no_subtree_check)
            /export/spider 10.0.0.1(rw,no_root_squash,nohide,insecure,no_subtree_check)
            /export/wireguard 10.0.0.1(rw,no_root_squash,nohide,insecure,no_subtree_check)
        '';
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
