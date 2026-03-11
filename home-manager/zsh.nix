{ config, lib, ... }:

let
    userName = config.userName;
    userHome = config.userHome;
    vpsName = config.vpsName;
in
{
    home-manager.users.${userName} = {
        programs.zsh = rec {
            enable = true;

            defaultKeymap = "emacs";

            dotDir = "${userHome}/.config/zsh";

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
                strategy = [
                    "completion"
                ];
            };

            history = {
                size = 100000;
                expireDuplicatesFirst = true;
                extended = true;
                ignoreAllDups = true;
                ignoreDups = true;
                ignoreSpace = true;
                saveNoDups = true;
                share = false;
                path = "$HOME/.local/share/zsh/history";
                ignorePatterns = [
                    "rm *"
                    "pkill *"
                    "cd *"
                    "mkdir *"
                    "nl"
                    "ng"
                    "nr"
                    "nu"
                    "mu"
                    "mus"
                    "ms"
                    "mss"
                    "mo"
                    "mn"
                    "gp"
                    "gP"
                    "gPf"
                    "gd"
                    "gcm"
                    "gcam"
                    "gcaa"
                    "gl"
                    "glp"
                    "gln"
                    "gs"
                    "grc"
                    "gwm"
                    "gwe"
                    "jf"
                    "jfi"
                    "jb"
                    "jbi"
                    "rt"
                    "st"
                ];
            };

            siteFunctions = {
                mkcd = ''
                    mkdir --parents "$1" && cd "$1"
                '';
           };

            sessionVariables = { };

            setOptions = [ ];

            shellAliases = {
                ip = "ip -color";
                ip6 = "ip -color -6";
                wp = "wl-copy";
                tp = "cd \"$(mktemp -d)\"";
                lg = "lazygit";
                li = "linode-cli --suppress-warnings";
                ms = "make switch";
                mss = "make switch-stable";
                mu = "make update";
                mus = "make update-stable";
                mn = "make nconfig";
                mo = "make oldconfig";
                vc = "kssh -T ${vpsName}";
                vd = "kssh -T ${vpsName} docker container";
                vl = "kssh -T ${vpsName} docker container list";
                vg = "kssh -T ${vpsName} docker container logs";
                jf = "journalctl --follow";
                jfi = "journalctl --follow --identifier";
                jb = "journalctl --boot";
                jbi = "journalctl --boot --identifier";
                gp = "git pull";
                gP = "git push";
                gPf = "git push --force";
                gd = "git diff";
                gcm = "git commit --message";
                gcam = "git commit --all --message";
                gcaa = "git commit --all --amend";
                gl = "git log";
                glp = "git log --patch";
                gln = "git log --name-only";
                gs = "git status";
                grc = "git rebase --continue";
                gwm = "git switch main";
                gwe = "git switch e";
                t = "date '+%F %H:%M %A'";
                rt = "systemctl reboot";
                st = "systemctl poweroff";
                icat = "kitten icat";
            };

            initContent = lib.mkOrder 1500 ''
                # keymap
                bindkey -s '^[x' "cd ~ && reset\n"
                bindkey -s '^[m' "matrix.sh\n"
                bindkey -s '^[s' "sway\n"
                bindkey -s '^[j' "journalctl --boot --follow\n"

                # man
                less_termcap[md]="''${fg_bold[blue]}"
                less_termcap[so]="''${fg_bold[red]}''${bg[dark grey]}"
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
                    "podman"
                    "ssh"
                    "sudo"
                    "systemd"
                    "uv"
                    "zsh-interactive-cd"
                ];

                extraConfig = ''
                    if [[ $TERM == "xterm-kitty" ]]; then
                        ZSH_THEME="bira"
                    else
                        ZSH_THEME="gentoo"
                    fi

                    HIST_STAMPS="yyyy-mm-dd"

                    umask 077

                    autoload compinit
                    zstyle ':completion:*' menu select
                    zstyle ':completion:*' add-space no
                    zmodload zsh/complist
                    bindkey -M menuselect 'h' vi-backward-char
                    bindkey -M menuselect 'l' vi-forward-char
                    bindkey -M menuselect 'j' vi-down-line-or-history
                    bindkey -M menuselect 'k' vi-up-line-or-history

                    zstyle ':omz:plugins:eza' 'icons' yes
                    zstyle ':omz:plugins:eza' 'time-style' '+%Y-%m-%d %H:%M'


                    SWAY=$(command -v sway)
                    function sway {
                        if [[ $TERM == "xterm-kitty" ]]; then
                            return
                        fi

                        exec "$SWAY" &>/tmp/sway.log
                    }
                '';
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
