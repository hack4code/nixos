{ pkgs, ... }:

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
            publish = {
                enable = true;
                userServices = true;
            };
        };

        fwupd = {
            enable = true;
            # uefiCapsuleSettings = {
            #     DisableShimForSecureBoot = true;
            # };
        };

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
            '';
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
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
