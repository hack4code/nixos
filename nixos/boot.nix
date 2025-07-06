{ config, pkgs, ... }:

let
    version = config.kernelVersion;
    sha256 = config.kernelSha256;
in
{
    boot = {
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
            "video=DP-3:1920x1080"
            "video=eDP-1:2160x1350"
        ];

        loader = {
            efi.canTouchEfiVariables = true;
            timeout = 5;
            # systemd-boot = {
            #     enable = true;
            #     consoleMode = "max";
            # };
        };

        initrd = {
            enable = true;
            systemd.enable = true;
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
                /* tpm */
                "tpm_tis_core"
                "tpm_tis"
                "tpm_crb"
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

        tmp.useTmpfs = true;
        tmp.tmpfsSize = "60%";
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
