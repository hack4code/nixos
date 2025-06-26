{ config, lib, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        programs.htop = {
            enable = true;

            settings = {
                color_scheme = 6;
                cpu_count_from_one = 1;
                hide_kernel_threads = 0;
                hide_userland_threads = 0;
                hide_running_in_container = 0;
                shadow_other_users = 0;
                show_thread_names = 1;
                show_program_path = 0;
                highlight_base_name = 1;
                highlight_deleted_exe = 1;
                shadow_distribution_path_prefix = 1;
                highlight_megabytes = 1;
                highlight_threads = 1;
                highlight_changes = 1;
                find_comm_in_cmdline = 1;
                strip_exe_from_cmdline = 1;
                show_merged_command = 0;
                header_margin = 0;
                screen_tabs = 0;
                detailed_cpu_time = 0;
                show_cpu_usage = 1;
                show_cpu_frequency = 0;
                show_cpu_temperature = 1;
                degree_fahrenheit = 0;
                show_cached_memory = 1;
                update_process_names = 0;
                enable_mouse = 0;
                delay = 30;
                hide_function_bar = 2;
                fields = [
                    "PID"
                    "PERCENT_CPU"
                    "PERCENT_MEM"
                    "M_RESIDENT"
                    "M_SHARE"
                    "M_VIRT"
                    "COMM"
                ];
            };
        };

        home.stateVersion = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
