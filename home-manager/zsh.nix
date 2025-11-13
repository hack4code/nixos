{ config, lib, ... }:

let
    userName = config.userName;
    vpsName = config.vpsName;
    bwSession = config.bwSession;
in
{
    home-manager.users.${userName} = {
        programs.zsh = rec {
            enable = true;

            defaultKeymap = "emacs";

            dotDir = ".config/zsh";

            autocd = true;
            cdpath = [
                "$HOME"
                "$HOME/source"
                "$HOME/code"
                "$HOME/music"
                "$HOME/source/nixos/extra"
            ];

            enableCompletion = true;

            syntaxHighlighting = {
                enable = true;
            };

            autosuggestion = {
                enable = true;
                # highlight = "bold";
                strategy = [ "history" ];
            };

            history = {
                size = 100000;
                ignoreAllDups = true;
                ignoreSpace = true;
                saveNoDups = true;
                path = "$HOME/.config/zsh/zsh_history";
            };

            sessionVariables = {
                PATH = "$HOME/.local/bin/:$PATH:";

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
                GTK_IM_MODULE = "wayland";
                SDL_IM_MODULE = "fcitx";
                XMODIFIERS = "@im=fcitx";
                QT_IM_MODULE = "fcitx";

                /* ibus */
                # GTK_IM_MODULE = "ibus";
                # XMODIFIERS = "@im=ibus";
                # QT_IM_MODULE = "ibus";


                /* sway */
                WLR_RENDERER = "vulkan";
                SDL_VIDEODRIVER = "wayland";
                QT_QPA_PLATFORM = "wayland";

                /* bitwarden */
                BW_SESSION = "${bwSession}";
            };

            shellAliases = {
                ip = "ip -color";
                wp = "wl-copy";
                tp = "cd \"$(mktemp -d)\"";
                linode = "linode-cli --suppress-warnings";
                vc = "kssh -T ${vpsName}";
                vd = "kssh -T ${vpsName} docker container";
                vdl = "kssh -T ${vpsName} docker container list";
                vdg = "kssh -T ${vpsName} docker container logs";
                jf = "journalctl --follow";
                jfi = "journalctl --follow --identifier";
                jb = "journalctl --boot";
                jbi = "journalctl --boot --identifier";
                gu = "git pull";
                gp = "git push";
                gpf = "git push --force";
                gd = "git diff";
                gc = "git commit";
                gca = "git commit --all";
                gcam = "git commit --all --message";
                gcaa = "git commit --all --amend";
                gl = "git log";
                glp = "git log --patch";
                gln = "git log --name-only";
                gs = "git status";
                gr = "git rebase";
                grm = "git rebase main";
                grc = "git rebase --continue";
                gw = "git switch";
                gwm = "git switch main";
                gwe = "git switch e";
                t = "date '+%F %H:%M %A'";
                reboot = "systemctl reboot";
            };

            initContent = lib.mkOrder 1500 ''
                # keymap
                bindkey -s '^[x' "cd ~ && clear\n"
                bindkey -s '^[m' "matrix.sh\n"
                bindkey -s '^[s' "sway\n"
                bindkey -s '^[j' "journalctl --boot --follow\n"

                # man
                less_termcap[md]="''${fg_bold[blue]}"
                less_termcap[so]="''${fg_bold[red]}''${bg[darkgrey]}"
            '';

            zsh-abbr = {
                enable = true;
                abbreviations = shellAliases;
            };

            oh-my-zsh = {
                enable = true;

                plugins = [
                    "colored-man-pages"
                    "direnv"
                    "eza"
                    "fzf"
                    "gh"
                    "kitty"
                    "uv"
                    "podman"
                    "sudo"
                    "ssh"
                    "systemd"
                ];

                extraConfig = ''
                    if [[ $TERM == "xterm-kitty" ]]; then
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
                    bindkey -M menuselect 'l' vi-forward-char
                    bindkey -M menuselect 'j' vi-down-line-or-history
                    bindkey -M menuselect 'k' vi-up-line-or-history


                    function color {
                        if (($# != 1)); then
                            echo "please give the color value!!!"
                            return 1
                        fi
                        tput setaf "$1"
                        echo "Hello World!"
                    }


                    SWAY=$(command -v sway)
                    function sway {
                        if [[ $TERM == "xterm-kitty" ]]; then
                            return
                        fi

                        while [[ -z "$(wpctl status | grep -F Headphones | grep -v Microphone | cut -d . -f 1 | awk '{print $2}' | tr -d '\s\n')" ]]; do
                            sleep 1s
                        done
                        wpctl set-default "$(wpctl status | grep -F Headphones | grep -v Microphone | cut -d . -f 1 | awk '{print $2}' | tr -d '\s\n')"
                        exec "$SWAY"
                    }
                '';
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
