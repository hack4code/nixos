{ config, ... }:

let
    userName = config.userName;
    interface = config.wifiInterface;
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
                presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,nexpandtab:0:default cpu:0:block,net:0:tty";
                vim_keys = true;
                rounded_corners = true;
                graph_symbol = "braille";
                graph_symbol_cpu = "braille";
                graph_symbol_gpu = "braille";
                graph_symbol_mem = "braille";
                graph_symbol_net = "braille";
                graph_symbol_proc = "braille";
                shown_boxes = "cpu net proc";
                update_ms = 3000;
                proc_sorting = "cpu direct";
                proc_reversed = false;
                proc_tree = false;
                proc_colors = true;
                proc_gradient = false;
                proc_per_core = true;
                proc_mem_bytes = false;
                proc_cpu_graphs = false;
                proc_info_smaps = false;
                proc_left = false;
                proc_filter_kernel = false;
                proc_aggregate = true;
                cpu_graph_upper = "Auto";
                cpu_graph_lower = "Auto";
                show_gpu_info = "On";
                cpu_invert_lower = true;
                cpu_single_graph = true;
                cpu_bottom = false;
                show_uptime = false;
                check_temp = true;
                cpu_sensor = "Auto";
                show_coretemp = true;
                cpu_core_map = "";
                temp_scale = "celsius";
                base_10_sizes = false;
                show_cpu_freq = false;
                clock_format = "";
                background_update = false;
                custom_cpu_name = "";
                disks_filter = "";
                mem_graphs = false;
                mem_below_net = true;
                zfs_arc_cached = false;
                show_swap = false;
                swap_disk = false;
                show_disks = false;
                only_physical = true;
                use_fstab = true;
                zfs_hide_datasets = false;
                disk_free_priv = false;
                show_io_stat = false;
                io_mode = false;
                io_graph_combined = true;
                io_graph_speeds = "";
                net_download = 16;
                net_upload = 2;
                net_auto = false;
                net_sync = false;
                net_iface = "${interface}";
                base_10_bitrate = "False";
                show_battery = false;
                selected_battery = "Auto";
                show_battery_watts = true;
                log_level = "WARNING";
                nvml_measure_pcie_speeds = true;
                rsmi_measure_pcie_speeds = true;
                gpu_mirror_graph = true;
                custom_gpu_name0 = "";
                custom_gpu_name1 = "";
                custom_gpu_name2 = "";
                custom_gpu_name3 = "";
                custom_gpu_name4 = "";
                custom_gpu_name5 = "";
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
