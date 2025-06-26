{
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 5;

    boot.loader.systemd-boot = {
        enable = true;
        consoleMode = "max";
    };

    boot.initrd.enable = true;
    boot.initrd.systemd.enable = true;
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
