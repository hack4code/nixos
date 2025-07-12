{ config, lib, pkgs, modulesPath, ... }:

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

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    hardware = {
        /* cpu gpu */
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        /* graphics */
        graphics = {
            enable = true;
            extraPackages = with pkgs; [
                intel-media-driver
                libva
            ];
        };
        intel-gpu-tools.enable = true;

        /* bluetooth */
        bluetooth = {
            enable = true;
            powerOnBoot = true;
            package = pkgs.bluez-experimental;
            settings = {
                Policy = {
                    AutoEnable = "true";
                };

                General = {
                    ControllerMode = "dual";
                    Experimental = true;
                    KernelExperimental = true;
                    FastConnectable = true;
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
