{
    powerManagement = {
        enable = true;
        cpuFreqGovernor = "ondemand";
        resumeCommands = ''
            rfkill block bluetooth
            rfkill unblock bluetooth
        '';
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
