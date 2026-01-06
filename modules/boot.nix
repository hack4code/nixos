{ config, pkgs, ... }:

let
    kernelVersion = config.kernelVersion;
    kernelSha256 = config.kernelSha256;
    kernel = "linux-${kernelVersion}.tar.xz";
in
{
    boot = {
        kernelPackages = pkgs.linuxPackages_custom {
            version = kernelVersion;
            src = pkgs.fetchurl {
                urls = [
                    "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/${kernel}"
                    "https://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v6.x/${kernel}"
                    "https://cdn.kernel.org/pub/linux/kernel/v6.x/${kernel}"
                ];
                sha256 = kernelSha256;
            };
            configfile = ./kernel/config;
        };

        kernelParams = [
            "loglevel=5"
            "rootfstype=ext4"
            "efi=runtime"
            "rw"
            /* kernel harden */
            "hardened_usercopy=1"
            "init_on_alloc=1"
            "init_on_free=1"
            "randomize_kstack_offset=on"
            "page_alloc.shuffle=1"
            "slab_nomerge"
            "pti=on"
            # "nosmt"
            "hash_pointers=always"
            "page_poison=1"
            "iommu.passthrough=0"
            "iommu.strict=1"
            "proc_mem.force_override=never"
            "mitigations=auto"
            "kfence.sample_interval=100"
            "vsyscall=none"
            "vdso32=0"
            "cfi=kcfi"
        ];

        kernelModules = [
        ];

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
                /* */
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

        consoleLogLevel = 3;
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
