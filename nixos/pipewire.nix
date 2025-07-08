{
    services.pipewire = {
        enable = true;
        alsa.enable = true;
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
                "bluez5.enable-sbc-xq" = true;
                "bluez5.enable-msbc" = true;
                "bluez5.enable-hw-volume" = true;
                "bluez5.roles" = [
                    "hsp_hs"
                    "hsp_ag"
                    "hfp_hf"
                    "hfp_ag"
                ];
            };
        };

        wireplumber.extraConfig."11-bluetooth-policy" = {
            "wireplumber.settings" = {
                "bluetooth.autoswitch-to-headset-profile" = false;
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
