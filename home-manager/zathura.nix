{ config, ... }:

let
    userName = config.userName;
    version = config.homeManagerVersion;
in
{
    home-manager.users.${userName} = {
        programs.zathura = {
            enable = true;

            options = {
                render-loading = true;
                adjust-open = "width";
                recolor = true;
                scroll-step = 50;
                selection-clipboard = "clipboard";
                statusbar-home-tilde = true;
                font = "Roboto Mono 16";
                continuous-hist-save = true;
                statusbar-basename = true;
                show-recent = 8;
                incremental-search = true;
                database = "sqlite";
                selection-notification = false;
                vertical-center = true;
                zoom-center = true;
                guioptions = "";
                default-bg = "#ffffff";
                default-fg = "#000000";
                inputbar-bg = "#ffffff";
                inputbar-fg = "#000000";
                recolor-lightcolor = "#ffffff";
                recolor-darkcolor = "#000000";
                statusbar-bg = "#ffffff";
                statusbar-fg = "#d79921";
                index-bg = "#ffffff";
                index-fg = "#000000";
                render-loading-bg = "#ffffff";
                render-loading-fg = "#000000";
                completion-bg = "#ffffff";
                completion-fg = "#000000";
                completion-group-bg = "#ffffff";
                completion-group-fg = "#000000";
                completion-highlight-bg = "";
                completion-highlight-fg = "";
                index-active-bg = "#000000";
                index-active-fg = "#ffffff";
                highlight-color = "#f5e8c6";
            };

            mappings = {
                "u" = "scroll half-up";
                "d" = "scroll half-down";
                "=" = "zoom in";
                ";" = "nohlsearch";
            };
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion  = version;
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
