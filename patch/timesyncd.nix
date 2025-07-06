{
    systemd.services."systemd-timesyncd" = {
        overrideStrategy = "asDropin";
        unitConfig.After = "dnscrypt-proxy2.service";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
