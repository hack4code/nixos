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
        ./config/git.nix
        ./config/gmail.nix
        ./config/gruvbox.nix
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
        ./input/fcitx5.nix
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
        ./home-manager/rtorrent.nix
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
        ./home-manager/fzf.nix
        ./home-manager/ripgrep.nix
        ./home-manager/fd.nix
        ./home-manager/man.nix
        ./home-manager/fontconfig.nix
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

    documentation = {
        enable = true;

        doc = {
            enable = true;
        };

        nixos = {
            enable = true;
        };

        dev = {
            enable = true;
        };

        man = {
            enable = true;

            cache = {
                enable = false;
            };

            man-db = {
                enable = true;
            };
        };
    };

    programs = {
        appimage = {
            enable = true;
            binfmt = true;
        };

        zsh = {
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
                # weechatScripts.autosort
                # weechatScripts.colorize_nicks
                # weechatScripts.url_hint
                # weechatScripts.buffer_autoset
                # weechatScripts.weechat-go
                ranger
                w3m
                neomutt
                zathura
                sherlock-launcher
                wl-kbptr
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

        defaultPackages = [];
        # corePackages = with pkgs; [ ];

        systemPackages = with pkgs; [
            /******************
                tool
            *******************/
            p7zip
            unrar
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
            ripgrep
            sysstat
            moor
            /******************
                git
            *******************/
            gh
            git
            /******************
                docker
            *******************/
            podman-compose
            /******************
                net
            *******************/
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
            /* transmission */
            transmission_4
            /******************
                font
            *******************/
            kbd
            /******************
                secure boot
            *******************/
            sbctl
            /******************
                hardware
            *******************/
            /* usb */
            usbutils
            /* lscpi */
            pciutils
            /* camer */
            snapshot
            /* ifuse */
            libimobiledevice
            ifuse
            /* bluetooth */
            bluez-tools
            pavucontrol
            pulseaudio
            /* video */
            ffmpeg
            libvpl
            /* firmware */
            linux-firmware
            sof-firmware
            /* tpm2 */
            tpm2-tools
            /******************
                develop
            *******************/
            gnumake
            /******************
                man
            *******************/
            man-db
            linux-manual
            man-pages
            man-pages-posix
            # glibcInfo
            /******************
                zsh
            *******************/
            nix-zsh-completions
            zsh-autocomplete
            zsh-completion-sync
            zsh-completions
            /******************
                game
            *******************/
            tetris
            /* ps2 */
            pcsx2
            /* ps3 */
            rpcs3
            /* ps4 */
            # shadps4
            /* Wii U */
            cemu
            /* switch */
            nsz
            ryubing
            /* pc */
            # dwarf-fortress
            # nethack
            # superTux
        ];
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
