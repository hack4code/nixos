{ pkgs, ... }:

{
    services.pipewire = {
        enable = true;

        audio = {
            enable = true;
        };

        alsa = {
            enable = true;
            support32Bit = true;
        };

        pulse = {
            enable = true;
        };

        wireplumber = {
            enable = true;
        };

        jack = {
            enable = true;
        };

        socketActivation = true;

        extraConfig = {
            pipewire = {
                "pulse-module" = {
                    "pulse.cmd" = [
                        {
                            "cmd" = "load-module";
                            "args" = "module-switch-on-connect";
                            "flags" = [];
                        }
                        {
                            "cmd" = "load-module";
                            "args" = "module-zeroconf-discover";
                            "flags" = [];
                        }
                        {
                            "cmd" = "load-module";
                            "args" = "module-always-sink";
                            "flags" = [];
                        }
                    ];
                };
            };
        };

        wireplumber = {
            configPackages = [
                (
                    pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
                        monitor.bluez.properties = {
                            bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
                            bluez5.codecs = [ sbc sbc_xq aac ]
                            bluez5.hfphsp-backend = "native"
                            bluez5.enable-hw-volume = true
                            bluez5.enable-sbc-xq = true
                            bluez5.enable-msbc = true
                        }
                   ''
                )
                (
                    pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/disable-logind.conf" ''
                        wireplumber.profiles = {
                            main = {
                                monitor.bluez.seat-monitoring = disabled
                            }
                        }
                    ''
                )
            ];

            extraConfig = {
                # "log-level-debug" = {
                #     "context.properties" = {
                #         "log.level" = "D";
                #     };
                # };

                "sony-hq" = {
                    "monitor.bluez.rules" = [
                        {
                            matches = [
                                {
                                    "device.name" = "bluez_output.20:64:DE:85:A4:E3";
                                }
                            ];

                            actions = {
                                update-props = {
                                    "bluez5.auto-connect" = "[ hfp_hf hsp_hs a2dp_sink hfp_ag hsp_ag a2dp_source ]";
                                    "bluez5.a2dp.ldac.quality" = "hq";
                                    "bluez5.a2dp.aac.bitratemode" = 0;
                                };
                            };
                        }
                    ];
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
