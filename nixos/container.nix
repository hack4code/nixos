{
    virtualisation.containers.enable = true;
    virtualisation = {
        podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
