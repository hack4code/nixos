{ config, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        programs.btop = {
            enable = true;

            settings = {
                color_theme = "tokyo-night";
                theme_background = "False";
                truecolor = "True";
                force_tty = "False";
                vim_keys = "True";
                rounded_corners = "True";
                graph_symbol = "braille";
                show_boxes = "cpu net mem proc";
                update_ms = 3000;
                proc_sorting = "cpu direct";
                proc_reversed = "False";
                proc_tree = "False";
                proc_colors = "False";
                proc_gradient = "False";
                proc_per_core = "True";
                proc_cpu_graphs = "False";
                proc_info_smaps = "False";
                proc_left = "False";
                proc_filter_kernel = "False";
                proc_aggregate = "False";
                show_gpu_info = "On";
                show_uptime = "False";
                show_cpu_freq = "False";
                background_update = "False";
                mem_below_net = "True";
                show_io_stat = "True";
                io_mode = "False";
                net_download = 16;
                net_upload = 2;
                net_sync = "False";
                show_battery = "False";
                log_level = "WARNING";
            };
        };

        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
