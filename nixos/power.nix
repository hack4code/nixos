{
    powerManagement = {
        enable = true;
        cpuFreqGovernor = "performance";
        resumeCommands = ''
            rfkill block `rfkill --json | jq -r '.rfkilldevices.[] | select(.device=="hci0") | .id'`
            rfkill unblock `rfkill --json | jq -r '.rfkilldevices.[] | select(.device=="hci0") | .id'`
        '';
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
