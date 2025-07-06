{ config, pkgs, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
    bwSession = config.bwSession;
in
{
    home-manager.users.${userName} = {
        programs.zsh = {
            enable = true;

            defaultKeymap = "emacs";

            dotDir = ".config/zsh/";

            autocd = true;
            cdpath = [
                "$HOME"
                "$HOME/music"
                "$HOME/source"
                "$HOME/source/docker"
                "$HOME/source/systemd"
                "$HOME/code"
            ];

            enableCompletion = true;

            syntaxHighlighting.enable = true;

            autosuggestion = {
                enable = true;
                highlight = "bold, underline";
                strategy = [ "history" ];
            };

            history = {
                size = 10000;
                ignoreAllDups = true;
                ignoreSpace = true;
                saveNoDups = true;
                path = "$HOME/.config/zsh/zsh_history";
            };

            sessionVariables = {
                PATH = "$HOME/bin:$HOME/.local/bin:$PATH:/usr/share/bcc/tools/:";

                /* xdg */
                XDG_CONFIG_HOME = "$HOME/.config";
                XDG_CACHE_HOME = "$HOME/.cache";
                XDG_DATA_HOME = "$HOME/.local/share";
                XDG_STATE_HOME = "$HOME/.local/state";
                XDG_DOCUMENTS_DIR = "$HOME/document";
                XDG_DOWNLOAD_DIR = "$HOME/download";
                XDG_MUSIC_DIR = "$HOME/music";
                XDG_VIDEOS_DIR = "$HOME/movie";
                XDG_PICTURES_DIR = "$HOME/picture";
                XDG_DESKTOP_DIR = "$HOME/temp";
                XDG_PUBLICSHARE_DIR = "$HOME/temp";
                XDG_TEMPLATES_DIR = "$HOME/temp";

                XCURSOR_PATH = "$XCURSOR_PATH:~/.local/share/icons";
                XCURSOR_THEME = "Graphite-dark-nord-cursor";
                XCURSOR_SIZE = 20;

                LANG = "en_US.UTF-8";
                EDITOR = "vim";

                GPG_TTY = "$(tty)";
                LIBVIRT_DEFAULT_URI = "qemu:///system";
                GNUPGHOME = "$HOME/.config/gpg";

                /* go */
                GOPATH = "$HOME/.local/share/go";

                /* fzf */
                FZF_DEFAULT_OPTS = "$FZF_DEFAULT_OPTS --border rounded --color 'dark,hl:red,pointer:green,current-hl:bright-red' --marker='>' --pointer='◆' --separator='─' --scrollbar='│'";
                FZF_CTRL_R_OPTS = "--bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'";

                /* fcitx5 */
                SDL_IM_MODULE = "fcitx";
                XMODIFIERS = "@im=fcitx";
                GTK_IM_MODULE = "wayland";
                QT_IM_MODULE = "fcitx";

                /* sway */
                # WLR_RENDERER = "vulkan";
                SDL_VIDEODRIVER = "wayland";
                QT_QPA_PLATFORM = "wayland";

                /* bitwarden */
                BW_SESSION = "${bwSession}";
            };

            shellAliases = {
                ip = "ip -color";
                wp = "wl-copy";
                jc = "journalctl";
                jf = "journalctl --follow";
                jb = "journalctl --boot";
                gl = "git pull";
                gp = "git push";
                gf = "git push --force";
                gd = "git diff";
                gc = "git commit";
                ga = "git commit --all";
                gg = "git log";
                gt = "git status";
                dh = "duf --only-mp /home";
                sed = "sed -E";
                paste = "paste --delimiters \" \"";
                reboot = "systemctl reboot";
            };

            oh-my-zsh = {
                enable = true;

                plugins = [
                    "sudo"
                    "fzf"
                    "systemd"
                    "kitty"
                    "podman"
                    "ssh"
                    "eza"
                    "gh"
                    "uv"
                    "colored-man-pages"
                ];

                extraConfig = ''
                    if [[ "$TERM" == "xterm-kitty" ]]; then
                        ZSH_THEME="bira"
                    else
                        ZSH_THEME="gentoo"
                    fi

                    HIST_STAMPS="yyyy-mm-dd"

                    umask 0077

                    autoload compinit
                    zstyle ':completion:*' menu select
                    zstyle ':completion:*' add-space false
                    zmodload zsh/complist
                    bindkey -M menuselect 'h' vi-backward-char
                    bindkey -M menuselect 'k' vi-up-line-or-history
                    bindkey -M menuselect 'l' vi-forward-char
                    bindkey -M menuselect 'j' vi-down-line-or-history

                    bindkey -s '^[x' "cd ~ && cls\n"
                    bindkey -s '^[u' "matrix\n"
                    bindkey -s '^[t' "date '+%F %H:%M %A'\n"
                    bindkey -s '^[s' "sway\n"
                    bindkey -s '^[j' "journalctl -b -f\n"
                    bindkey -s '^[e' "git switch e\n"
                    bindkey -s '^[a' "git switch main\n"


                    function color {
                        if (($# != 1)); then
                            echo "please give the color value!!!"
                            return 1
                        fi
                        tput setaf "$1"
                        echo "Hello World!"
                    }


                    function post {
                        if (($# < 1)); then
                            return 1;
                        fi
                        curl -F "file=@$1" https://0x0.st
                    }

                    function matrix {
                        local COLORS=(green red blue yellow cyan magenta)
                        local N=$(($RANDOM % ''${#COLORS[@]} + 1))

                        cmatrix -a -C "''${COLORS[$N]}"
                        curl -s -o /dev/null -X GET 'http://127.0.0.1:8080/system/idle'
                    }


                    function gruvbox {
                        source ${pkgs.vimPlugins.gruvbox}/gruvbox_256palette.sh
                    }


                    function cls {
                        clear
                        gruvbox
                        # if [[ "$TERM" == "xterm-kitty" ]]; then
                        #     fastfetch
                        # fi
                    }


                    function sysupdate {
                        paru --skipreview --quiet -Syu
                    }


                    function sysclean {
                        sudo pacman -Rns $(pacman -Qtdq)
                    }


                    function vpsid {
                        linode-cli linodes list --json | jq -r '.[].id' | head --lines 1
                    }


                    function vpsdf {
                        ssh -T linode "df -h -l -t ext4 --output=source,size,used,avail,pcent"
                    }


                    function vpsls {
                        ssh -T linode 'cd ~/download/complete/; du --human-readable --all --max-depth 1' | sed 's:\./::' | awk '{ if (! (($2==".") && (NR<=2))) print $0; }'
                    }


                    function magnet {
                        sed -nE 's/.*(magnet:.+)\]$/\1\n/p'
                    }


                    SWAY=$(command -v sway)
                    function sway {
                        if [[ "$TERM" == "xterm-kitty" ]]; then
                            return
                        fi

                        while [[ -z "$(wpctl status | grep -F Headphones | grep -v Microphone | cut -d . -f 1 | awk '{print $2}' | tr -d '\s\n')" ]]; do
                            sleep 1s
                        done
                        wpctl set-default "$(wpctl status | grep -F Headphones | grep -v Microphone | cut -d . -f 1 | awk '{print $2}' | tr -d '\s\n')"
                        exec "$SWAY"
                    }


                    #
                    [[ $- == *i* ]] && cls
                '';
            };
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion = "${version}";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
