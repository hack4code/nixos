{ config, pkgs, pkgs-stable, nixOSVersion, ... }:

let
    eGPUPciID = config.eGPUPciID;
in
{
    environment.systemPackages = with pkgs; [
        tetris
        /* ps2 */
        pcsx2
        /* ps3 */
        # rpcs3
        /* ps4 */
        shadps4
        /* Wii U */
        # cemu
        /* switch */
        nsz
        eden
    ] ++ (with pkgs-stable; [
        /* windows */
        bottles
    ]);

    programs = {
        gamemode = {
            enable = true;

            enableRenice = true;

            settings = {
                general = {
                    # renice = 4;
                    inhibit_screensaver = 1;
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

            args = [
                "--rt"
                "--hdr-enabled"
                "--force-windows-fullscreen"
                "--backend wayland"
                "--prefer-vk-device ${eGPUPciID}"
            ];
        } // (if nixOSVersion == "26.11" then {
            enableWsi = false;
        }
        else {
        });
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
