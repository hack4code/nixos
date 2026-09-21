{ config, nixOSVersion, ... }:

let
    eGPUPciID = config.eGPUPciID;
in
{
    programs = {
        gamemode = {
            enable = true;

            enableRenice = true;

            settings = {
                general = {
                    renice = 10;
                    inhibit_screensaver = 0;
                };

                gpu = {
                    apply_gpu_optimisations = "accept-responsibility";
                    gpu_device = 1;
                    amd_performance_level = "high";
                };
            };
        };

        gamescope = {
            enable = true;

            capSysNice = true;

            env = { };
            args = [
                "--rt"
                "--prefer-vk-device ${eGPUPciID}"
            ];
        } // (if nixOSVersion == "26.11" then
        {
            enableWsi = false;
        }
        else
        {
        });
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
