{ pkgs, nixOSVersion, ... }:

{
    services = {
        hardware = {
            bolt = {
                enable = true;
            };
        };

        avahi = {
            enable = true;
            nssmdns4 = true;
            nssmdns6 = true;
        } // (if nixOSVersion == "26.11" then {
            settings = {
                publish = {
                    disable-publishing = false;
                    publish-addresses = true;
                };
            };
        } else {
            publish = {
                enable = true;
                userServices = true;
            };
        });

        acpid = {
            enable = true;
        };

        upower = {
            enable = true;
        };

        usbmuxd = {
            enable = true;
            package = pkgs.usbmuxd2;
        };

        power-profiles-daemon = {
            enable = true;
        };

        fprintd = {
            enable = true;
        };

        xserver = {
            videoDrivers = [
                "modesetting"
            ];
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
