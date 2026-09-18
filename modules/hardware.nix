{ pkgs, modulesPath, ... }:

{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/9084d34c-2ed7-4c52-919f-baca77d3d4f9";
        fsType = "ext4";
        options = [
            # "noatime"
            # "nodiratime"
            "discard"
        ];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/5B93-CD49";
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
            device = "/dev/disk/by-uuid/2cc3d8a2-8fc1-4a22-b870-21908a07eb52";
        }
    ];

    hardware = {
        firmware = [
            pkgs.linux-firmware
        ];
        enableRedistributableFirmware = true;
        firmwareCompression = "zstd";
        # enableAllFirmware = false;

        cpu = {
            intel = {
                updateMicrocode = true;
            };
        };

        amdgpu = {
            opencl = {
                enable = true;
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
