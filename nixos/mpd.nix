{ config, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        services.mpd = {
            enable = true;

            network = {
                listenAddress = "127.0.0.1";
                port = 6600;
                startWhenNeeded = false;
            };

            musicDirectory = /home/${userName}/music/song;
            playlistDirectory = /home/${userName}/music/playlist;

            extraConfig = ''
                sticker_file "/home/${userName}/.local/share/mpd/sticker.sql"
                state_file "/home/${userName}/.local/state/mpd/state"
                log_level "info"
            '';
        };

        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
