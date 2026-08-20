{ config, pkgs, ... }:

let
    userName = config.userName;
    colorRed = config.colorRed;
    colorLightRed = config.colorLightRed;
    colorGreen = config.colorGreen;
    colorLightGreen = config.colorLightGreen;
    colorPurple = config.colorPurple;
    colorWhite = config.colorWhite;
    colorBlue = config.colorBlue;
    colorAqua = config.colorAqua;
in
{
    home-manager.users.${userName} = {
        programs.fzf = {
            enable = true;

            enableZshIntegration = true;

            colors = {
                hl = "${colorRed}";
                "hl+" = "${colorLightRed}";
                pointer = "${colorLightGreen}";
                query = "${colorGreen}";
                info = "${colorPurple}";
                border = "${colorWhite}";
                prompt = "${colorBlue}";
                separator = "${colorAqua}";
                spinner = "${colorLightGreen}";
            };

            defaultCommand = "fd --type f --hidden --follow --exclude .git";

            defaultOptions = [
                "--border=rounded"
                "--marker='>'"
                "--pointer='◆'"
                "--separator='─'"
                "--scrollbar=''"
            ];

            historyWidget = {
                options = [
                    "--wrap=word"
                    "--wrap-sign='\t↳ '"
                    "--bind 'ctrl-y:execute-silent(echo -n {2..} | ${pkgs.wl-clipboard}/bin/wl-copy)+abort'"
                ];
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
