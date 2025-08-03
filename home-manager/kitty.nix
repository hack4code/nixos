{ config, pkgs, ... }:

let
    userName = config.userName;
    version = config.homeManagerVersion;
in
{
    home-manager.users.${userName} = {
        programs.kitty = {
            enable = true;

            shellIntegration = {
                enableBashIntegration = true;
                enableZshIntegration = true;
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
                "kitty_mod+o" = "new_tab";
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
                focus_follows_mouse = "no";
                close_on_child_death = "yes";
            };

            extraConfig = ''
                # font_family family='Intel One Mono' postscript_name=IntelOneMono-Regular
                # bold_font  family='Intel One Mono' postscript_name=IntelOneMono-Medium
                # italic_font family='Intel One Mono' postscript_name=IntelOneMono-Italic
                # bold_italic_font family='Intel One Mono' postscript_name=IntelOneMono-MediumItalic
                # font_size 15

                modify_font cell_height +6px
                # modify_font baseline 3
                # box_drawing_scale 0.4, 1, 1.5, 2

                symbol_map U+4E00-U+9FFF Noto Sans Mono CJK SC
                symbol_map U+3400-U+4DBF Noto Sans Mono CJK TC
                symbol_map U+3000-U+30FF Noto Sans Mono CJK JP
                symbol_map U+AC00-U+D7FF Noto Sans Mono CJK KR

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
                cursor                  #928374
                cursor_text_color       background

                url_color               #83a598
                url_style               curly

                visual_bell_color       #8ec07c
                bell_border_color       #8ec07c
                active_border_color     #d3869b
                inactive_border_color   #665c54

                active_tab_foreground   #fbf1c7
                active_tab_background   #665c54
                inactive_tab_foreground #a89984
                inactive_tab_background #3c3836
                inactive_tab_font_style italic
                active_tab_font_style   bold-italic

                foreground              #ebdbb2
                background              #1d2021
                background_opacity      1.0

                selection_foreground    #928374
                selection_background    #ebdbb2

                #: black
                color0                  #665c54
                color8                  #7c6f64

                #: red
                color1                  #cc241d
                color9                  #fb4934

                #: green
                color2                  #98971a
                color10                 #b8bb26

                #: yellow
                color3                  #d79921
                color11                 #fabd2f

                #: blue
                color4                  #458588
                color12                 #83a598

                #: purple
                color5                  #b16286
                color13                 #d3869b

                #: aqua
                color6                  #689d6a
                color14                 #8ec07c

                #: white
                color7                  #a89984
                color15                 #bdae93
            '';
        };

        home.file.".config/kitty/open-actions.conf" = {
            executable = false;
            force = true;
            text = ''
                protocol http, https
                mime     image/*
                action   launch --type=overlay swayimg "exec://wget -qO- ''${URL}"


                #: vim: ts=4 sw=4 sts=4 ft=config et:
            '';
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion  = version;
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
