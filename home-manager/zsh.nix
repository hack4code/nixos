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
                share = true;
                path = "$HOME/.local/share/zsh/history";

                ignorePatterns = (map (x: x + " *") (builtins.attrNames shellAliases)) ++ [
                    "rm *"
                    "pkill *"
                    "kill *"
                    "mkdir *"
                    "mkcd *"
                    "ls *"
                    "la *"
                    "ll *"
                    "vi *"
                    "vim *"
                    "nvim *"
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
                gcaa = "git commit --all --amend";
                gcam = "git commit --all --message";
                gcm = "git commit --message";
                gd = "git diff";
                gl = "git log";
                gln = "git log --name-only";
                glp = "git log --patch";
                gPf = "git push --force";
                gp = "git pull";
                gP = "git push";
                grc = "git rebase --continue";
                gs = "git status";
                gwe = "git switch e";
                gwm = "git switch main";
                icat = "kitten icat";
                ip6 = "ip -color -6";
                ip = "ip -color";
                jbi = "journalctl --boot --identifier";
                jb = "journalctl --boot";
                jfi = "journalctl --follow --identifier";
                jf = "journalctl --follow";
                lg = "lazygit";
                li = "linode";
                lp = "lsof -iTCP -sTCP:listen -P -n";
                mn = "make nconfig";
                mo = "make oldconfig";
                ms = "make switch";
                mss = "make switch-stable";
                mu = "make update";
                mus = "make update-stable";
                mp = "glow --pager";
                mm = "glow --pager README.md";
                rt = "systemctl reboot";
                st = "systemctl poweroff";
                t = "date '+%F %H:%M %A'";
                tp = "cd \"$(mktemp -d)\"";
                vc = "kssh -T ${vpsName}";
                vd = "kssh -T ${vpsName} docker container";
                vg = "kssh -T ${vpsName} docker container logs";
                vl = "kssh -T ${vpsName} docker container list";
                wp = "wl-copy";
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

            completionInit = "autoload -U compinit && compinit";

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

                    # autoload compinit
                    zmodload zsh/zpty
                    zmodload zsh/complist

                    zstyle ':completion:*' menu select
                    zstyle ':completion:*' add-space no
                    bindkey -M menuselect 'h' vi-backward-char
                    bindkey -M menuselect 'l' vi-forward-char
                    bindkey -M menuselect 'j' vi-down-line-or-history
                    bindkey -M menuselect 'k' vi-up-line-or-history

                    # eza
                    if [[ $TERM == "xterm-kitty" ]]; then
                        zstyle ':omz:plugins:eza' 'icons' yes
                    else
                        zstyle ':omz:plugins:eza' 'icons' no
                    fi
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
