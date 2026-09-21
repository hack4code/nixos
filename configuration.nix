{ config, pkgs, lib, pkgs-unstable, nixOSVersion, ... }:

let
    timeZone = config.timeZone;
in
{
    imports = [
        ./patch/firefox.nix
        ./patch/bottles.nix
        ./patch/weechat.nix
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
        ./config/weechat.nix
        ./config/firefox.nix
        ./config/gpu.nix
        ./config/rtorrent.nix
        ./config/nfs.nix
        ./input/fcitx5.nix
        ./modules/boot.nix
        ./modules/console.nix
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
        ./modules/jremap.nix
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
        ./home-manager/yazi.nix
        ./home-manager/rime.nix
        ./home-manager/rtorrent.nix
        ./home-manager/scripts.nix
        ./home-manager/sndctl.nix
        ./home-manager/ssh.nix
        ./home-manager/swayctl.nix
        ./home-manager/swayimg.nix
        ./home-manager/sway.nix
        ./home-manager/syncdrive.nix
        ./home-manager/theme.nix
        ./home-manager/uv.nix
        ./home-manager/neovim.nix
        ./home-manager/xdg.nix
        ./home-manager/zathura.nix
        ./home-manager/zsh.nix
        ./home-manager/fzf.nix
        ./home-manager/ripgrep.nix
        ./home-manager/fd.nix
        ./home-manager/man.nix
        ./home-manager/fontconfig.nix
        ./home-manager/noctalia.nix
        ./home-manager/sherlock.nix
        ./home-manager/cliphist.nix
    ];

    assertions = lib.mkForce [];

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
            man-db = {
                enable = true;
            };
            cache = {
                enable = false;
                generateAtRuntime = true;
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

        /* uv */
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
                clipman
                urlscan
                w3m
                weechat
                # weechat-matrix-rs
                wl-clipboard
                kitty
                neomutt
                slurp
                swayimg
                urlscan
                w3m
                weechat
                wl-clipboard
                wl-kbptr
                xdg-desktop-portal-termfilechooser
                yazi
                zathura
            ];
        };

        gamemode = {
            enable = true;

            enableRenice = true;

            settings = {
                general = {
                    renice = 10;
                    inhibit_screensaver = 0;
                };

                gpu = {
                    apply_gpu_optimisations = "accept-responsibility";
                    gpu_device = 1;
                    amd_performance_level = "high";
                };

                custom = {
                    # start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
                    # end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
                };
            };
        };

        gamescope = {
            enable = true;

            capSysNice = true;

            env = { };
            args = [
                "--rt"
                "--prefer-vk-device 1ed3:0e46"
            ];
        } // (if nixOSVersion == "26.11" then
            {
                enableWsi = false;
            }
            else
            {
            }
        );
    };

    environment = {
        sessionVariables = {
            LANG = "en_US.UTF-8";
            EDITOR = "vim";

            PAGER = "${pkgs.moor}/bin/moor";
            MOOR = "--colors=16M --no-statusbar --no-linenumbers --terminal-fg --wrap --render-unprintable=whitespace";
            /* man pager */
            MANPAGER = "${pkgs.moor}/bin/moor";
            /* systemd pager */
            SYSTEMD_PAGER = "${pkgs.moor}/bin/moor";
            SYSTEMD_PAGERSECURE = "true";

            /* termfilechooser */
            GTK_USE_PORTAL = "1";

            /* libvirt */
            LIBVIRT_DEFAULT_URI = "qemu:///system";
        };

        shells = with pkgs; [
            zsh
            bashInteractive
        ];

        defaultPackages = [];

        systemPackages = with pkgs; [
            /******************
                tool
            *******************/
            bat
            bc
            binutils
            coreutils
            dosfstools
            duf
            evtest
            eza
            fastfetch
            file
            fzf
            glow
            # googleearth-pro
            iotop
            jq
            libnotify
            lsof
            moor
            mpc
            ncdu
            p7zip
            parted
            perf
            procps
            psmisc
            pv
            qrencode
            sysstat
            sshfs
            unrar
            wtype
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
            /******************
                transmission
            *******************/
            stig
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
            /* brightness */
            ddcutil
            /******************
                develop
            *******************/
            gh
            git
            gnumake
            /******************
                man
            *******************/
            linux-manual
            man-db
            man-pages
            man-pages-posix
            /******************
                zsh
            *******************/
            nix-zsh-completions
            zsh-autocomplete
            zsh-completion-sync
            zsh-completions
            /******************
                yt-dlp
            *******************/
            quickjs-ng
            /******************
                neovim
            *******************/
            lua-language-server
            clang-tools
            pyright
            fd
            bash-language-server
            shellcheck
            shfmt
            nixd
            ripgrep
            /******************
                icon
            *******************/
            adwaita-icon-theme
            adwaita-qt
            candy-icons
            kdePackages.breeze
            kdePackages.breeze-icons
            /******************
                weechat
            *******************/
            weechat-matrix-rs
            /******************
                graphics
            *******************/
            mesa
            mesa_glu
            /******************
                amd
            *******************/
            amdgpu_top
            /******************
                bios
            *******************/
            # uefitool
            # flashrom
            /******************
                game
            *******************/
            tetris
            /* ps2 */
            pcsx2
            /* ps3 */
            # rpcs3
            /* ps4 */
            shadps4
            /* Wii U */
            # cemu
            /* switch */
            nsz
            eden
            /* windows */
            wine64
            umu-launcher
            bottles
            # lutris-free
        ] ++ (with pkgs-unstable; [
            netwatch
            diskwatch
        ]);
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
