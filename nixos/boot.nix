{ config, pkgs, ... }:

let
    version = config.kernelVersion;
    sha256 = config.kernelSha256;
    userName = config.userName;
in
{
    boot = {
        consoleLogLevel = 3;

        kernelPackages = pkgs.linuxPackages_custom {
            version = version;
            src = pkgs.fetchurl {
                urls = [
                    "file:///home/${userName}/code/linux-${version}.tar.xz"
                    "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-${version}.tar.xz"
                    "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz"
                ];
                sha256 = sha256;
                preferLocalBuild = true;
            };
            configfile = ../kernel/config;
        };

        kernelParams = [
            "loglevel=5"
            "rootfstype=ext4"
            "rw"
            "efi=runtime"
            "idle=nomwait"
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
                /* wireless */
                "rfkill"
                "cfg80211"
                "iwlwifi"
            ];
        };

        blacklistedKernelModules = [
            "i2c_i801"
        ];

        tmp = {
            useTmpfs = true;
            tmpfsSize = "60%";
            cleanOnBoot = true;
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
