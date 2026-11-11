{ config, pkgs, nixOSVersion, ... }:

let
    timeZone = config.timeZone;
in
{
    imports = [
        ./fonts/fontconfig.nix
        ./config/bitwarden.nix
        ./config/dnscrypt-proxy.nix
        ./config/firefox.nix
        ./config/git.nix
        ./config/gmail.nix
        ./config/gpu.nix
        ./config/gruvbox.nix
        ./config/input.nix
        ./config/kernel.nix
        ./config/nfs.nix
        ./config/ntp.nix
        ./config/output.nix
        ./config/podman.nix
        ./config/rtorrent.nix
        ./config/sony.nix
        ./config/system.nix
        ./config/theme.nix
        ./config/user.nix
        ./config/vps.nix
        ./config/weechat.nix
        ./config/wifi.nix
        ./config/wg-quick.nix
        ./config/wireguard.nix
        ./config/proxy.nix
        ./modules/boot.nix
        ./modules/console.nix
        ./modules/dnscrypt-proxy.nix
        ./modules/env.nix
        ./modules/fcitx5.nix
        ./modules/fwupd.nix
        ./modules/game.nix
        ./modules/hardware.nix
        ./modules/jremap.nix
        ./modules/kremap.nix
        ./modules/networking.nix
        ./modules/nfs.nix
        ./modules/nix.nix
        ./modules/oomd.nix
        ./modules/pipewire.nix
        ./modules/podman.nix
        ./modules/power.nix
        ./modules/security.nix
        ./modules/services.nix
        ./modules/sudo.nix
        ./modules/sway.nix
        ./modules/sysctl.nix
        ./modules/theme.nix
        ./modules/user.nix
        ./modules/weechat.nix
        ./modules/wg-quick.nix
        ./home-manager/btop.nix
        ./home-manager/direnv.nix
        ./home-manager/downmovie.nix
        ./home-manager/fcitx5.nix
        ./home-manager/fd.nix
        ./home-manager/fetchmail.nix
        ./home-manager/firefox.nix
        ./home-manager/fontconfig.nix
        ./home-manager/fzf.nix
        ./home-manager/git.nix
        ./home-manager/home.nix
        ./home-manager/htop.nix
        ./home-manager/kitty.nix
        ./home-manager/lazygit.nix
        ./home-manager/man.nix
        ./home-manager/mpd.nix
        ./home-manager/mpv.nix
        ./home-manager/ncmpcpp.nix
        ./home-manager/neomutt.nix
        ./home-manager/neovim.nix
        ./home-manager/noctalia.nix
        ./home-manager/podman.nix
        ./home-manager/rime.nix
        ./home-manager/ripgrep.nix
        ./home-manager/rtorrent.nix
        ./home-manager/scripts.nix
        ./home-manager/sherlock.nix
        ./home-manager/sndctl.nix
        ./home-manager/ssh.nix
        ./home-manager/swayctl.nix
        ./home-manager/swayimg.nix
        ./home-manager/sway.nix
        ./home-manager/syncdrive.nix
        ./home-manager/theme.nix
        ./home-manager/uv.nix
        ./home-manager/xdg.nix
        ./home-manager/yazi.nix
        ./home-manager/zathura.nix
        ./home-manager/zsh.nix
    ] ++ (if nixOSVersion == "26.11" then
    [
        ./modules/greetd.nix
    ] else [
    ]);

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
    };

    environment = {
        shells = with pkgs; [
            zsh
            bashInteractive
        ];

        systemPackages = with pkgs; [
            /******************
                tool
            *******************/
            bat
            bc
            binutils
            blktrace
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
            # weechat-matrix-rs
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
        ];
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
