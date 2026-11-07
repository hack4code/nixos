{ config, pkgs, lib, ... }:

let
    kernelVersion = config.kernelVersion;
    kernelUrl = config.kernelUrl;
    kernelHash = config.kernelHash;
    socks5Proxy = config.socks5Proxy;
in
{
    boot = {
        kernelPatches = [
            pkgs.kernelPatches.request_key_helper
        ];

        kernelPackages = pkgs.linuxPackages_custom {
            version = kernelVersion;
            src = if (lib.strings.hasInfix "github" kernelUrl) then
                pkgs.fetchFromGitHub {
                    owner = "torvalds";
                    repo = "linux";
                    tag = "v${kernelVersion}";
                    hash = kernelHash;
                    curlOpts = "-L --retry 8 --proxy ${socks5Proxy}";
                }
            else
                pkgs.fetchurl {
                    url = kernelUrl;
                    sha256 = kernelHash;
                };
            configfile = ./kernel/config;
        };

        consoleLogLevel = 5;

        kernelParams = lib.mkForce [
            /* root */
            "root=fstab"
            "rootfstype=ext4"
            "rw"
            /* module */
            "module.sig_enforce=1"
            /* efi */
            "efi=runtime"
            /* kernel harden */
            "hardened_usercopy=1"
            "init_on_alloc=1"
            "init_on_free=1"
            "randomize_kstack_offset=on"
            "page_alloc.shuffle=1"
            "slab_nomerge"
            "psi=1"
            "pti=on"
            "hash_pointers=always"
            "proc_mem.force_override=never"
            "mitigations=auto"
            /* wine */
            "ia32_emulation=on"
            /* linux security module */
            "lsm=capability,landlock,yama,loadpin,safesetid,integrity,selinux,bpf"
            /* */
            "transparent_hugepage=always"
            "transparent_hugepage_tmpfs=always"
            "split_lock_detect=off"
            "split_lock_mitigate=0"
            "preempt=full"
            /* amd gpu */
            "amdgpu.dcdebugmask=0x4"
            /* systemd */
            "systemd.tpm2_measured_os=0"
            /* thinkpad screen */
            "video=eDP-1:2160x1350"
        ];

        kernelModules = [
            "amdgpu"
            "i915"
            "ntsync" /* bottles */
            "hid_betopff" /* joystick */
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
                enable = true;
                consoleMode = "max";
            };

            timeout = 3;
        };

        initrd = {
            enable = true;

            systemd = {
                tpm2 = {
                    enable = false;
                };

                network = {
                    enable = false;
                    wait-online = {
                        enable = false;
                    };
                };
            };

            compressor = "zstd";

            includeDefaultModules = false;

            kernelModules = [
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

        lanzaboote = {
            autoEnrollKeys = {
                enable = true;
            };

            autoGenerateKeys = {
                enable = true;
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
