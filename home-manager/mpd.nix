{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        services.mpd = {
            enable = true;

            network = {
                listenAddress = "127.0.0.1";
                port = 6600;
                startWhenNeeded = true;
            };

            musicDirectory = /home/${userName}/music/song;
            playlistDirectory = /home/${userName}/music/playlist;

            extraConfig = ''
                sticker_file "/home/${userName}/.local/share/mpd/sticker.sql"
                state_file "/home/${userName}/.local/state/mpd/state"
                log_file "/home/${userName}/.local/share/mpd/log"
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


# vim: ts=4 sw=4 sts=4 ft=nix et:
