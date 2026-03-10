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


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
