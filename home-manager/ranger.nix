{ config, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        programs.ranger = {
            enable = true;

            settings = {
                viewmode = "miller";
                column_ratios = "1,2,4";
                show_hidden = false;
                confirm_on_delete = "never";
                preview_script = "~/.config/ranger/scope.sh";
                automatically_count_files = true;
                preview_images = true;
                preview_images_method = "kitty";
                w3m_delay = 0.8;
                colorscheme = "dracula";
                preview_files = false;
                preview_directories = true;
                collapse_preview = true;
                wrap_plaintext_previews = true;
                status_bar_on_top = false;
                draw_progress_bar_in_status_bar = false;
                draw_borders = "both";
                dirname_in_tabs = false;
                mouse_enabled = false;
                display_size_in_main_column = false;
                display_size_in_status_bar = true;
                display_free_space_in_status_bar = false;
                tilde_in_titlebar = true;
                padding_right = true;
                show_cursor = false;
                sort = "basename";
                sort_reverse = false;
                sort_case_insensitive = false;
                sort_directories_first = true;
                sort_unicode = true;
                line_numbers = "relative";
                relative_current_zero = false;
                one_indexed = true;
                save_tabs_on_exit = false;
            };

            rifle = [
                { condition = "mime ^video, has mpv, X, flag f"; command = "mpv -- \"$@\""; }
                { condition = "ext mkv, has mpv, X, flag f"; command = "mpv -- \"$@\""; }
                { condition = "ext pdf, has zathura, X, flag f"; command = "zathura -- \"$@\""; }
                { condition = "ext epub, has zathura, X, flag f"; command = "zathura -- \"$@\""; }
                { condition = "mime ^image, has swayimg, X, flag f"; command = "swayimg -- \"$@\""; }
                { condition = "!mime ^text, label editor, ext ass|srt"; command = "\${VISUAL:-$EDITOR} -- \"$@\""; }
                { condition = "!mime ^text, label pager, ext ass|srt"; command = "\"$PAGER\" -- \"$@\""; }
                { condition = "mime ^text, label editor"; command = "\${VISUAL:-$EDITOR} -- \"$@\""; }
                { condition = "mime ^text, label pager"; command = "\"$PAGER\" -- \"$@\""; }
            ];
        };

        home.file.".config/ranger" = {
            source = ../ranger;
            recursive = true;
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
