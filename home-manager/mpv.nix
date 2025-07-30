{ config, ... }:

let
    userName = config.userName;
    version = config.homeManagerVersion;
in
{
    home-manager.users.${userName} = {
        programs.mpv = {
            enable = true;
            config = {
                fs = true;
                osc = false;
                ontop = true;
                vo = "gpu-next,dmabuf-wayland";
                hwdec = "vaapi";
                hwdec-codecs = "all";
                gpu-api = "vulkan";
                vo-vaapi-scaling = "hq";
                vo-vaapi-scaled-osd = true;
                wayland-internal-vsync = true;
                cursor-autohide = 60;
                video-sync = "display-resample";
                ao = "pipewire";
                volume-max = 200;
                cache = true;
                demuxer-max-bytes = "1024M";
                demuxer-max-back-bytes = "128M";
                cache-pause = false;
                sub-auto = "all";
                sub-font = "Roboto Flex,MiSans";
                sub-font-size = 36;
                sub-border-size = 1;
                sub-border-color = "0/0/0/0.5";
                sub-color = "#e5a50a";
                sub-bold = false;
                sub-pos = 64;
                sub-shadow-color = "0.0/0.0/0.0/0.5";
                sub-shadow-offset = 1;
                sub-ass-override = false;
                sub-hinting = "native";
                sub-line-spacing = 3;
                sub-font-provider = "fontconfig";
                sub-fix-timing = true;
                osd-back-color = "0/0/0/0";
                osd-bar-align-y = 0.9;
                osd-bar-h = 0.8;
                osd-bar-w = 50;
                osd-border-size = 0;
                osd-color = "1/1/1/1";
                osd-duration = 3000;
                osd-font-size = 36;
                osd-font = "Iosevka";
                msg-module = false;
                msg-color = true;
                slang = "chi,en,eng,en-orig";
                alang = "chi,en,eng";
                vlang = "chi,en,eng";
                save-position-on-quit = true;
                stop-screensaver = true;
                watch-later-directory = "~/.local/share/mpv/watch_later";
                screenshot-directory = "~/picture/mpv";
                log-file = "~/.local/share/mpv/log";
                term-status-msg = "\"\${time-pos} \${duration}\"";
            };

            scriptOpts = {
                console = {
                    font = "Iosevka Term";
                    font_size = 18;
                };

                stats = {
                    font = "Iosevka Term";
                    font_mono = "Iosevka";
                    font_size = 18;
                    font_color = "FFFFFF";
                    alpha = 0.6;
                    border_size = 1;
                    duration = 8;
                };
            };

            bindings = {
                UP = "add volume 2";
                DOWN = "add volume -2";
                RIGHT = "seek 10";
                LEFT = "seek -10";
                "9" = "add sub-scale +0.1";
                "=" = "add sub-scale +0.1";
                "0" = "add sub-scale -0.1";
                "-" = "add sub-scale -0.1";
                "k" = "cycle audio";
                "K" = "cycle audio down";
                "HOME" = "seek 0 absolute";
            };

            extraInput = ''
                ESC ignore
            '';
        };

        home.file.".config/mpv" = {
            source = ../mpv;
            recursive = true;
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
