{ pkgs, modulesPath, ... }:

{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/d6c140eb-11ac-44e6-bbba-ac909cae0fdf";
        fsType = "ext4";
        options = [
            "noatime"
            "nodiratime"
            "discard"
        ];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/37CC-CC6E";
        fsType = "vfat";
        options = [
            "fmask=0077"
            "dmask=0077"
        ];
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/c6f540c8-14e5-4857-8d7e-9faf87c00dcc";
        fsType = "ext4";
        options = [
            "noatime"
            "nodiratime"
            "discard"
        ];
    };

    swapDevices = [
        {
            device = "/dev/disk/by-uuid/cc587f2b-c2bb-4bb0-bddf-5d7cce87f8b4";
        }
    ];

    hardware = {
        enableAllFirmware = false;
        enableRedistributableFirmware = true;
        firmwareCompression = "zstd";

        cpu = {
            intel = {
                updateMicrocode = true;
            };
        };

        graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = with pkgs; [
                intel-media-driver
                vpl-gpu-rt
                mesa
                libva
                libva-utils
            ];
        };

        intel-gpu-tools = {
            enable = true;
        };

        bluetooth = {
            enable = true;

            powerOnBoot = true;

            settings = {
                Policy = {
                    AutoEnable = "true";
                };

                General = {
                    ControllerMode = "dual";
                    Experimental = true;
                    KernelExperimental = true;
                    DiscoverableTimeout = 180;
                    FastConnectable = true;
                };
            };
        };

        acpilight = {
            enable = true;
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
