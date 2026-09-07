{ config, pkgs, ... }:

let
    userName = config.userName;
    colorForeground = config.colorForeground;
    colorBackground = config.colorBackground;
    colorBackground1 = config.colorBackground1;
    colorBackground4 = config.colorBackground4;
    colorBlack = config.colorBlack;
    colorLightBlack = config.colorLightBlack;
    colorRed = config.colorRed;
    colorLightRed = config.colorLightRed;
    colorGreen = config.colorGreen;
    colorLightGreen = config.colorLightGreen;
    colorYellow = config.colorYellow;
    colorLightYellow = config.colorLightYellow;
    colorBlue = config.colorBlue;
    colorLightBlue = config.colorLightBlue;
    colorPurple = config.colorPurple;
    colorLightPurple = config.colorLightPurple;
    colorAqua = config.colorAqua;
    colorLightAqua = config.colorLightAqua;
    colorWhite = config.colorWhite;
    colorLightWhite = config.colorLightWhite;
    colorGray = config.colorGray;
in
{

    home-manager.users.${userName} = {
        programs.kitty = {
            enable = true;

            enableGitIntegration = true;

            shellIntegration = {
                enableBashIntegration = true;
                enableZshIntegration = true;
                mode = "no-title";
            };

             font = {
                 name = "Google Sans Code";
                 size = 15.0;
             };

            actionAliases = {
                "kitty_scrollback_nvim" = "kitten ${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py";
            };

            keybindings = {
                "kitty_mod+w" = "no_op";
                "kitty_mod+r" = "no_op";
                "kitty_mod+g" = "no_op";
                "kitty_mod+n" = "new_tab";
                "kitty_mod+q" = "close_tab";
                "kitty_mod+k" = "next_tab";
                "kitty_mod+j" = "previous_tab";
                "kitty_mod+h" = "kitty_scrollback_nvim";
                "kitty_mod+l" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
                "super+c" = "copy_to_clipboard";
                "super+v" = "paste_from_clipboard";
            };

            settings = {
                undercurl_style = "thin-sparse";
                disable_ligatures = "never";
                cursor_shape = "underline";
                cursor_trail = 3;
                focus_follows_mouse = "no";
                close_on_child_death = "yes";
                open_url_with = "open_url_from_kitty.sh";
            };

            extraConfig = ''
                modify_font cell_height +6px

                symbol_map U+4E00-U+9FFF MiSans
                symbol_map U+3400-U+4DBF MiSans TC

                symbol_map U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E634,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF Symbols Nerd Font
                symbol_map U+1F000-U+1F02F,U+1F0A0-U+1F0FF,U+1F100-U+1F64F,U+1F680-U+1F6FF,U+1F910-U+1F96B,U+1F980-U+1F9E0 Noto Color Emoji

                allow_remote_control socket
                listen_on unix:@kitty

                kitty_mod ctrl+shift

                tab_bar_edge bottom
                tab_bar_margin_width 2.0
                tab_bar_margin_height 0.0 0.0
                tab_bar_style powerline
                tab_bar_align left
                tab_powerline_style angled
                tab_title_template "{index}"

                window_padding_width 4 8

                # color
                cursor                  ${colorGray}
                cursor_text_color       background

                url_color               ${colorBlue}
                url_style               curly

                visual_bell_color       ${colorYellow}
                bell_border_color       ${colorLightYellow}

                active_tab_foreground   ${colorForeground}
                active_tab_background   ${colorBackground4}
                inactive_tab_foreground ${colorGray}
                inactive_tab_background ${colorBackground1}
                inactive_tab_font_style italic
                active_tab_font_style   bold-italic

                foreground              ${colorForeground}
                background              ${colorBackground}
                background_opacity      1.0

                selection_foreground    ${colorBackground4}
                selection_background    ${colorForeground}

                #: black
                color0                  ${colorBlack}
                color8                  ${colorLightBlack}

                #: red
                color1                  ${colorRed}
                color9                  ${colorLightRed}

                #: green
                color2                  ${colorGreen}
                color10                 ${colorLightGreen}

                #: yellow
                color3                  ${colorYellow}
                color11                 ${colorLightYellow}

                #: blue
                color4                  ${colorBlue}
                color12                 ${colorLightBlue}

                #: purple
                color5                  ${colorPurple}
                color13                 ${colorLightPurple}

                #: aqua
                color6                  ${colorAqua}
                color14                 ${colorLightAqua}

                #: white
                color7                  ${colorWhite}
                color15                 ${colorLightWhite}
            '';
        };

        home.file.".config/kitty/open-actions.conf" = {
            executable = false;
            force = true;
            text = ''
                protocol http, https
                mime     image/*
                action   launch --type=overlay swayimg "exec://${pkgs.curl}/bin/curl -s -o - \"''${URL}\""
            '';
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
