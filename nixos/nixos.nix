{ config, ... }:

let
    userName = config.userName;
in
{
    fileSystems."/etc/nixos" = {
        depends = [
            "/"
            "/home"
        ];
        device = "/home/${userName}/source/nixos";
        options = [
            "bind"
            "ro"
        ];
    };

}


# vim: ts=4 sw=4 sts=4 ft=nix et:
