{ pkgs, ... }:

{
    services = {
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
            uefiCapsuleSettings = {
                DisableShimForSecureBoot = true;
            };
        };

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
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
