{ config, ... }:

let
    userName = config.userName;
in
{
    fileSystems."/export/wireguard" = {
        depends = [
            "/"
            "/home"
        ];
        device = "/home/${userName}/source/wireguard";
        options = [ "bind" ];
    };

    fileSystems."/export/docker" = {
        depends = [
            "/"
            "/home"
        ];
        device = "/home/${userName}/source/docker";
        options = [ "bind" ];
    };

    fileSystems."/export/spider" = {
        depends = [
            "/"
            "/home"
        ];
        device = "/home/${userName}/source/spider";
        options = [ "bind" ];
    };

    services.nfs.server.enable = true;
    services.nfs.server.exports = ''
        /export/docker 10.0.0.1(rw,no_root_squash,nohide,insecure,no_subtree_check)
        /export/spider 10.0.0.1(rw,no_root_squash,nohide,insecure,no_subtree_check)
        /export/wireguard 10.0.0.1(rw,no_root_squash,nohide,insecure,no_subtree_check)
    '';
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
