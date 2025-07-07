{
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        jack.enable = true;
        socketActivation = true;
        wireplumber.extraConfig.bluetoothEnhancements = {
            "monitor.bluez.properties" = {
                "bluez5.enable-sbc-xq" = true;
                "bluez5.enable-msbc" = true;
                "bluez5.enable-hw-volume" = true;
                "bluez5.roles" = [
                    "hsp_hs"
                    "hsp_ag"
                    "hfp_hf"
                    "hfp_ag"
                    "bap_sink"
                    "a2dp_sink"
                ];
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
