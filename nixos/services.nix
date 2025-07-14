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

        upower.enable = true;
        power-profiles-daemon.enable = true;
        acpid.enable = true;
        fwupd.enable = true;
        /* iphone */
        usbmuxd.enable = true;
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
