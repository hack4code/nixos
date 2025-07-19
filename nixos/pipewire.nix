{
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        socketActivation = true;

        extraConfig.pipewire = {
            "10-airplay" = {
                "context.modules" = [
                    {
                        name = "libpipewire-module-raop-discover";
                        args = {
                            "raop.latency.ms" = 500;
                        };
                    }
                ];
            };
        };

        wireplumber.extraConfig.bluetoothEnhancements = {
            "monitor.bluez.properties" = {
                bluez5 = {
                    enable-hw-volume = false;
                    enable-sbc-xq = true;
                    enable-msbc = true;
                    roles = [
                        "a2dp_sink"
                        "a2dp_source"
                        "bap_sink"
                        "bap_source"
                        "hsp_hs"
                        "hsp_ag"
                        "hfp_hf"
                        "hfp_ag"
                    ];
                    codecs = [
                        "sbc"
                        "sbc_xq"
                        "aac"
                    ];
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
