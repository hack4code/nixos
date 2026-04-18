{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.zathura = {
            enable = true;

            options = {
                render-loading = false;
                adjust-open = "width";
                recolor = true;
                scroll-step = 30;
                selection-clipboard = "clipboard";
                statusbar-home-tilde = true;
                font = "JetBrains Mono 16";
                continuous-hist-save = true;
                statusbar-basename = true;
                show-recent = 6;
                incremental-search = true;
                database = "sqlite";
                selection-notification = false;
                vertical-center = true;
                zoom-center = true;
                guioptions = "";
                default-bg = "#ffffff";
                default-fg = "#000000";
                recolor-lightcolor = "#ffffff";
                recolor-darkcolor = "#000000";
                render-loading-bg = "#ffffff";
                render-loading-fg = "#000000";
                highlight-color = "#f5e8c6";
                # inputbar-bg = "#ffffff";
                # inputbar-fg = "#000000";
                # statusbar-bg = "#ffffff";
                # statusbar-fg = "#d79921";
                # index-bg = "#ffffff";
                # index-fg = "#000000";
                # completion-bg = "#ffffff";
                # completion-fg = "#000000";
                # completion-group-bg = "#ffffff";
                # completion-group-fg = "#000000";
                # completion-highlight-bg = "";
                # completion-highlight-fg = "";
                # index-active-bg = "#000000";
                # index-active-fg = "#ffffff";
            };

            mappings = {
                "u" = "scroll half-up";
                "d" = "scroll half-down";
                "b" = "scroll full-up";
                "f" = "scroll full-down";
                "=" = "zoom in";
                ";" = "nohlsearch";
                "<C-o>" = "file_chooser";
                "h" = "scroll page-top";
                "l" = "scroll page-bottom";
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
