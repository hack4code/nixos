{ config, pkgs, ... }:

let
    version = config.kernelVersion;
    sha256 = config.kernelSha256;
in
{
    boot = {
        consoleLogLevel = 5;

        kernelPackages = pkgs.linuxPackages_custom {
            version = version;
            src = pkgs.fetchurl {
                url = "https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-${version}.tar.xz";
                sha256 = sha256;
            };
            configfile = ../kernel/config;
        };

        kernelParams = [
            "rootfstype=ext4"
            "rw"
            "efi=runtime"
        ];

        loader = {
            efi.canTouchEfiVariables = true;
            timeout = 3;
            systemd-boot.consoleMode = "max";
        };

        initrd = {
            enable = true;
            systemd.enable = true;
            systemd.tpm2.enable = false;
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
