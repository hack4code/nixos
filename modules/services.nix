{ pkgs, nixOSVersion, ... }:

{
    # environment.etc."thunderbolt/thunderbolt-rescan.sh" = {
    #     text = ''
    #     #!/usr/bin/env bash

    #     echo 1 > /sys/bus/pci/rescan
    #     '';

    #     mode = "0700";
    # };

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
                    publish-address = true;
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

        udev = {
            enable = true;

            extraRules = ''
                ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", GROUP="video", MODE="0664"
                KERNEL=="ntsync", MODE="0666", TAG+="uaccess"
            '';
            # ACTION=="change", SUBSYSTEM=="thunderbolt", RUN+="/etc/thunderbolt/thunderbolt-rescan.sh"
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
