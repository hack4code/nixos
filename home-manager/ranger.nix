{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.ranger = {
            enable = true;

            settings = {
                viewmode = "miller";
                column_ratios = "1,2,4";
                show_hidden = false;
                update_title = true;
                shorten_title = 0;
                show_selection_in_titlebar = true;
                confirm_on_delete = "never";
                automatically_count_files = true;
                preview_images = false;
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

            extraConfig = ''
                default_linemode  unicode_icons
            '';

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
                { condition = "ext zip, has 7z"; command = "7z l \"$1\" | less"; }
                { condition = "ext zip, has 7z"; command = "for file in \"$@\"; do 7z e \"$file\"; done"; }
                { condition = "ext 7z, has 7z"; command = "7z l \"$1\" | less"; }
                { condition = "ext 7z, has 7z"; command = "for file in \"$@\"; do 7z e \"$file\"; done"; }
                { condition = "ext rar, has unrar"; command = "unrar l \"$1\" | less"; }
                { condition = "ext rar, has unrar"; command = "for file in \"$@\"; do unrar e \"$file\"; done"; }
                { condition = "ext tar|gz|bz2|xz, has tar"; command = "tar vvtf \"$1\" | \"$PAGER\""; }
                { condition = "ext tar|gz|bz2|xz, has tar"; command = "for file in \"$@\"; do tar vvxf \"$file\"; done"; }
                { condition = "ext bz2, has bzip2"; command = "for file in \"$@\"; do bzip2 -dk \"$file\"; done"; }
            ];
        };

        home.file.".config/ranger" = {
            source = ./ranger;
            recursive = true;
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
