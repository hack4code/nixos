{ config, ... }:

let
    userName = config.userName;
    userHome = config.userHome;
in
{
    home-manager.users.${userName} = {
        home.file.".config/systemd/user/mpd.service.d/50-patch.conf" = {
            executable = false;
            force = true;
            text = ''
                [Service]
                    LimitRTPRIO=40
                    LimitRTTIME=infinity
            '';
        };

        services.mpd-mpris = {
            enable = true;
        };

        services.mpd = {
            enable = true;

            network = {
                listenAddress = "127.0.0.1";
                port = 6600;
                startWhenNeeded = true;
            };

            musicDirectory = "${userHome}/music/song";
            playlistDirectory = "${userHome}/music/playlist";

            extraConfig = ''
                sticker_file "${userHome}/.local/share/mpd/sticker.sql"
                state_file "${userHome}/.local/state/mpd/state"
                log_file "${userHome}/.local/share/mpd/log"
                log_level "info"

                auto_update "yes"
                auto_update_depth "0"

                audio_output {
                    type "pipewire"
                    name "Mpd Pipewire Output"
                }

                audio_output {
                    type "fifo"
                    name "visualizer"
                    path "/tmp/mpd.fifo"
                    format "44100:16:2"
                }
            '';
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
