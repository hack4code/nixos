{ ... }:

{
    systemd.oomd = {
        enable = true;

        settings = {
            OOM = {
                DefaultMemoryPressureLimit = "60%";
                SwapUsedLimit = "80%";
                DefaultMemoryPressureDurationSec = "20s";
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
