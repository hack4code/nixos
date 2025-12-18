{
    virtualisation = {
        containers = {
            containersConf = {
                settings = {
                    containers = {
                        log_driver = "journald";
                    };
                };
            };
        };

        podman = {
            enable = true;
            dockerCompat = false;
            defaultNetwork = {
                settings = {
                    dns_enabled = false;
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
