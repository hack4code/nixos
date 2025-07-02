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
                theme_background = false;
                truecolor = true;
                force_tty = false;
                vim_keys = true;
                rounded_corners = true;
                proc_reversed = false;
                proc_tree = false;
                proc_colors = true;
                proc_gradient = false;
                proc_per_core = true;
                proc_cpu_graphs = false;
                proc_info_smaps = false;
                proc_left = false;
                proc_filter_kernel = false;
                proc_aggregate = false;
                show_uptime = false;
                show_cpu_freq = false;
                background_update = false;
                mem_below_net = true;
                show_io_stat = false;
                io_mode = false;
                net_download = 16;
                net_upload = 2;
                net_sync = false;
                show_battery = false;
                update_ms = 3000;
                proc_sorting = "cpu direct";
                graph_symbol = "braille";
                show_boxes = "cpu net proc";
                show_gpu_info = "On";
                log_level = "WARNING";
            };
        };

        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
