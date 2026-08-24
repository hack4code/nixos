{ config, pkgs, lib, ... }:

let
    kernelVersion = config.kernelVersion;
    kernelUrl = config.kernelUrl;
    kernelHash = config.kernelHash;
in
{
    boot = {
        kernelPackages = pkgs.linuxPackages_custom {
            version = kernelVersion;
            src = if (lib.strings.hasInfix "github" kernelUrl) then
                pkgs.fetchFromGitHub {
                    owner = "torvalds";
                    repo = "linux";
                    tag = "v${kernelVersion}";
                    hash = kernelHash;
                }
            else
                pkgs.fetchurl {
                    url = kernelUrl;
                    sha256 = kernelHash;
                };
            configfile = ./kernel/config;
        };

        kernelParams = lib.mkForce [
            /* log */
            "loglevel=5"
            /* root */
            "root=fstab"
            "rootfstype=ext4"
            "rw"
            /* efi */
            "efi=runtime"
            /* kernel harden */
            "hardened_usercopy=1"
            "init_on_alloc=1"
            "init_on_free=1"
            "randomize_kstack_offset=on"
            "page_alloc.shuffle=1"
            "slab_nomerge"
            "pti=on"
            "hash_pointers=always"
            "iommu.passthrough=0"
            "iommu.strict=1"
            "proc_mem.force_override=never"
            "mitigations=auto"
            "kfence.sample_interval=100"
            "vdso32=0"
            /* wine */
            "ia32_emulation=on"
            /* linux security module */
            "lsm=capability,landlock,yama,loadpin,safesetid,integrity,selinux,bpf"
            # "pcie_ports=native" /* touchpad mouse bug */
            # "pci=assign-busses,hpbussize=0x33,realloc,hpmmiosize=128M,hpmmioprefsize=16G" /* touchpad mouse bug */
            /* video */
            "video=eDP-1:2160x1350@60"
            "video=HDMI-A-4:2560x1440@75"

        ];

        kernelModules = [
            "amdgpu"
            "i915"
        ];

        extraModprobeConfig = ''
            options ttm pages_limit=31457280
            options ttm page_pool_size=15728640
            options i915 enable_guc=3
        '';

        loader = {
            efi = {
                canTouchEfiVariables = true;
            };
            systemd-boot = {
                consoleMode = "max";
            };
            timeout = 3;
        };

        initrd = {
            enable = true;
            systemd = {
                enable = true;
                tpm2 = {
                    enable = false;
                };
            };
            includeDefaultModules = false;
            kernelModules = [
                "autofs4"
                /* nvme */
                "hwmon"
                "nvme_core"
                "nvme"
                /* ext4 */
                "mbcache"
                "jbd2"
                "crc16"
                "ext4"
                /* erofs */
                "erofs"
                /* efi */
                "efivarfs"
                /* bridge */
                "bridge"
                "br_netfilter"
            ];
        };

        blacklistedKernelModules = [
            "xe"
            "i2c_i801"
        ];

        tmp = {
            useTmpfs = true;
            tmpfsSize = "60%";
            cleanOnBoot = true;
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
