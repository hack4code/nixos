{ ... }:

{
    # environment.etc."thunderbolt/thunderbolt-rescan.sh" = {
    #     text = ''
    #     #!/usr/bin/env bash

    #     echo 1 > /sys/bus/pci/rescan
    #     '';

    #     mode = "0700";
    # };
    # ACTION=="change", SUBSYSTEM=="thunderbolt", RUN+="/etc/thunderbolt/thunderbolt-rescan.sh"

    services = {
        udev = {
            enable = true;

            extraRules = ''
                ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", GROUP="video", MODE="0664"
                KERNEL=="ntsync", MODE="0666"
            '';

            # packages = with pkgs; [
            #     (writeTextFile {
            #         name = "60-ntsync.rules";
            #         destination = "/etc/udev/rules.d/60-ntsync.rules";
            #         text = ''
            #             KERNEL=="ntsync", MODE="0666"
            #         '';
            #     })
            # ];
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
