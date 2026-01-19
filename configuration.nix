{ config, pkgs, ... }:

let
    timeZone = config.timeZone;
in
{
    imports = [
        ./patch/tpm2-tss-fapi.nix
        ./fonts/fontconfig.nix
        ./config/bitwarden.nix
        ./config/dnscrypt-proxy.nix
        ./config/gmail.nix
        ./config/input.nix
        ./config/kernel.nix
        ./config/ntp.nix
        ./config/output.nix
        ./config/podman.nix
        ./config/system.nix
        ./config/theme.nix
        ./config/user.nix
        ./config/vps.nix
        ./config/wifi.nix
        ./config/wireguard.nix
        ./modules/boot.nix
        ./modules/dnscrypt-proxy.nix
        ./modules/hardware.nix
        ./modules/kremap.nix
        ./modules/networking.nix
        ./modules/nfs.nix
        ./modules/nix.nix
        ./modules/pipewire.nix
        ./modules/podman.nix
        ./modules/power.nix
        ./modules/security.nix
        ./modules/services.nix
        ./modules/sudo.nix
        ./modules/sysctl.nix
        ./modules/user.nix
        ./modules/wg-quick.nix
        ./modules/theme.nix
        ./home-manager/btop.nix
        ./home-manager/direnv.nix
        ./home-manager/downmovie.nix
        ./home-manager/fcitx5.nix
        ./home-manager/fetchmail.nix
        ./home-manager/firefox.nix
        ./home-manager/git.nix
        ./home-manager/home.nix
        ./home-manager/htop.nix
        ./home-manager/kitty.nix
        ./home-manager/lazygit.nix
        ./home-manager/mpd.nix
        ./home-manager/mpv.nix
        ./home-manager/ncmpcpp.nix
        ./home-manager/neomutt.nix
        ./home-manager/podman.nix
        ./home-manager/ranger.nix
        ./home-manager/rime.nix
        ./home-manager/scripts.nix
        ./home-manager/sherlock.nix
        ./home-manager/sndctl.nix
        ./home-manager/ssh.nix
        ./home-manager/swayctl.nix
        ./home-manager/swayimg.nix
        ./home-manager/swaylock.nix
        ./home-manager/swaync.nix
        ./home-manager/sway.nix
        ./home-manager/syncdrive.nix
        ./home-manager/theme.nix
        ./home-manager/uv.nix
        ./home-manager/vim.nix
        ./home-manager/waybar.nix
        ./home-manager/xdg.nix
        ./home-manager/zathura.nix
        ./home-manager/zsh.nix
    ];


    time = {
        timeZone = timeZone;
        hardwareClockInLocalTime = false;
    };

    home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "backup";
    };

    programs = {
        appimage = {
            enable = true;
            binfmt = true;
        };

        zsh = {
            enable = true;
        };

        light = {
            enable = true;
        };

        neovim = {
            enable = true;
            defaultEditor = true;
        };

        # uv
        nix-ld = {
            enable = true;
        };

        wireshark = {
            enable = true;
            package = pkgs.wireshark;
            dumpcap = {
                enable = true;
            };
        };

        sway = {
            enable = true;

            wrapperFeatures = {
                gtk = true;
            };

            extraPackages = with pkgs; [
                swaybg
                swaylock
                swayimg
                swayidle
                swaynotificationcenter
                waybar
                clipman
                wl-clipboard
                kitty
                weechat
                ranger
                w3m
                neomutt
                zathura
                sherlock-launcher
                wl-kbptr
                wlr-randr
                slurp
                xdg-desktop-portal-termfilechooser
            ];
        };
    };

    environment = {
        shells = with pkgs; [
            zsh
            bashInteractive
        ];

        systemPackages = with pkgs; [
            /* compress */
            p7zip
            unrar
            /* tool */
            bat
            bc
            binutils
            coreutils
            dosfstools
            duf
            eza
            fastfetch
            fd
            file
            fzf
            iotop
            jq
            libnotify
            procps
            qrencode
            sysstat
            /* git */
            gh
            git
            /* video */
            ffmpeg
            libvpl
            /* podman */
            podman-compose
            /* net */
            axel
            conntrack-tools
            curl
            dig
            ethtool
            iproute2
            mtr
            nmap
            openssh
            pwru
            rclone
            # tcptrace
            wget
            /* transmission */
            transmission_4
            /* tpm2 */
            tpm2-tools
            /* firmware */
            linux-firmware
            sof-firmware
            /* bluetooth */
            pavucontrol
            pulseaudio
            /* console font */
            kbd
            /* secure boot */
            sbctl
            /* bluetooth */
            bluez-tools
            /* ifuse */
            libimobiledevice
            ifuse
            /* usb */
            usbutils
            /* develop */
            glibcInfo
            gnumake
            linux-manual
            man-pages
            /* game */
            # dwarf-fortress
            # nethack
            tetris
            superTux
            pcsx2
            # rpcs3
            # mame
            # mame-tools
        ];
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
