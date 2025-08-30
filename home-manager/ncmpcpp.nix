{ config, pkgs, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.ncmpcpp = {
            enable = true;
            package = pkgs.ncmpcpp.override { visualizerSupport = true; };

            mpdMusicDir = "\"~/music/song\"";

            bindings = [
                { key = "up"; command = "volume_up"; }
                { key = "down"; command = "volume_down"; }
                { key = "j"; command = "scroll_down"; }
                { key = "k"; command = "scroll_up"; }
                { key = "space"; command = "pause"; }
                { key = "ctrl-l"; command = "dummy"; }
                { key = "p"; command = "toggle_visualization_type"; }
                { key = "0"; command = "show_server_info"; }
                { key = "8"; command = "show_visualizer"; }
                { key = "9"; command = "show_clock"; }
            ];

            settings = {
                ncmpcpp_directory = "\"~/.local/share/ncmpcpp\"";
                lyrics_directory = "\"~/music/lyrics\"";
                mpd_connection_timeout = "\"180\"";
                mpd_crossfade_time = "\"5\"";

                connected_message_on_startup = "\"no\"";
                mouse_support = "\"no\"";
                message_delay_time = "\"1\"";
                enable_window_title = "\"no\"";
                follow_now_playing_lyrics = "\"yes\"";
                default_place_to_search_in = "\"database\"";
                autocenter_mode = "\"yes\"";
                ignore_diacritics = "\"yes\"";
                allow_for_physical_item_deletion = "\"yes\"";
                system_encoding = "\"utf8\"";
                regular_expressions = "\"extended\"";
                incremental_seeking = "\"yes\"";
                seek_time = "\"1\"";
                startup_screen = "\"playlist\"";

                playlist_editor_display_mode = "\"columns\"";
                search_engine_display_mode = "\"columns\"";
                browser_display_mode = "\"columns\"";
                playlist_display_mode = "\"columns\"";

                song_status_format = "\" $5%a$8 | $7%t \"";
                song_columns_list_format = "\"(10f)[white]{l} (50)[cyan]{t|f} (18)[blue]{a}\"";
                now_playing_prefix = "";
                centered_cursor = "\"yes\"";
                selected_item_prefix = "\"\"";
                discard_colors_if_item_is_selected = "\"no\"";

                user_interface = "\"alternative\"";
                header_visibility = "\"no\"";
                statusbar_visibility = "\"yes\"";
                progressbar_look = "\"♪†≡\"";
                colors_enabled = "\"yes\"";
                main_window_color = "\"green\"";
                progressbar_color = "\"magenta\"";
                statusbar_color = "\"yellow\"";
                progressbar_elapsed_color = "\"red\"";

                visualizer_data_source = "\"/tmp/mpd.fifo\"";
                visualizer_output_name = "\"visualizer\"";
                visualizer_type = "\"ellipse\"";
                visualizer_autoscale = "\"yes\"";
                visualizer_in_stereo = "\"yes\"";
                visualizer_look = "\"●▮\"";
                visualizer_color = "\"blue, cyan, green, yellow, magenta, red, white\"";

                jump_to_now_playing_song_at_start = "\"yes\"";
                cyclic_scrolling = "\"yes\"";
                lines_scrolled = "\"2\"";

                external_editor = "\"vim\"";
                use_console_editor = "\"yes\"";
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
