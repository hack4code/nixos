{ config, pkgs, pkgs-unstable, ... }:

let
    userName = config.userName;
    userPassWord = config.userPassWord;
    uid = config.uid;
    nixosVersion = config.nixosVersion;
    homeManagerVersion = config.homeManagerVersion;
    timeZone = config.timeZone;
in
{
    imports = [
        ./patch/tpm2-tss-fapi.nix
        ./patch/podman.nix
        ./config/user.nix
        ./config/os.nix
        ./config/wireguard.nix
        ./config/bitwarden.nix
        ./config/dnscrypt-proxy.nix
        ./config/input.nix
        ./config/output.nix
        ./config/wifi.nix
        ./config/ntp.nix
        ./config/gmail.nix
        ./nixos/hardware.nix
        ./nixos/boot.nix
        ./nixos/power.nix
        ./nixos/networking.nix
        ./nixos/sysctl.nix
        ./nixos/container.nix
        ./nixos/sudo.nix
        ./nixos/services.nix
        ./nixos/pipewire.nix
        ./nixos/kremap.nix
        ./nixos/wg-quick.nix
        ./nixos/dnscrypt-proxy.nix
        ./nixos/nfs.nix
        ./fonts/fontconfig.nix
        ./input/ibus.nix
        ./home-manager/sway.nix
        ./home-manager/swayctl.nix
        ./home-manager/sndctl.nix
        ./home-manager/swaylock.nix
        ./home-manager/swaync.nix
        ./home-manager/waybar.nix
        ./home-manager/ssh.nix
        ./home-manager/btop.nix
        ./home-manager/htop.nix
        ./home-manager/xdg-desktop-portal.nix
        ./home-manager/zsh.nix
        ./home-manager/neomutt.nix
        ./home-manager/ranger.nix
        ./home-manager/kitty.nix
        ./home-manager/mpd.nix
        ./home-manager/ncmpcpp.nix
        ./home-manager/wofi.nix
        ./home-manager/mpv.nix
        ./home-manager/zathura.nix
        ./home-manager/firefox.nix
        ./home-manager/vim.nix
        ./home-manager/downmovie.nix
        ./home-manager/syncdrive.nix
        ./home-manager/fcitx5.nix
        ./home-manager/rime.nix
        ./home-manager/uv.nix
        ./home-manager/scripts.nix
        ./home-manager/git.nix
        ./home-manager/direnv.nix
        ./home-manager/fetchmail.nix
        ./home-manager/podman.nix
    ];

    nix = {
        channel = {
            enable = false;
        };

        settings = {
            cores = 7;
            max-jobs = 7;
            show-trace = true;
            sandbox = true;
            sandbox-fallback = false;
            require-sigs = true;
            auto-optimise-store = true;

            trusted-users = [
                "@wheel"
            ];

            experimental-features = [
                "flakes"
                "nix-command"
            ];
        };

        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 8d";
            persistent = true;
        };

        optimise = {
            automatic = true;
            persistent = true;
        };
    };

    nixpkgs = {
        hostPlatform = "x86_64-linux";
        config = {
            allowUnfree = true;
        };
    }; 

    home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "backup";
        users = {
            ${userName} = {
                home = {
                    enableNixpkgsReleaseCheck = false;
                    stateVersion = homeManagerVersion;
                };
            };
        };
    };

    system = {
        autoUpgrade = {
            enable = false;
        };

        etc = {
            overlay = {
                enable = true;
            };
        };

        stateVersion = nixosVersion;
    };

    time = {
        timeZone = timeZone;
        hardwareClockInLocalTime = false;
    };

    security = {
        rtkit = {
            enable = true;
        };

        polkit = {
            enable = true;
        };

        tpm2 = {
            enable = true;
            pkcs11 = {
                enable = true;
            };
            abrmd = {
                enable = true;
            };
            tctiEnvironment = {
                enable = true;
                interface = "tabrmd";
            };
        };

        pam = {
            services = {
                swaylock = {
                    text = ''
                        auth sufficient ${pkgs.linux-pam}/lib/security/pam_unix.so try_first_pass likeauth nullok
                        auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
                        auth required ${pkgs.linux-pam}/lib/security/pam_deny.so
                        auth required ${pkgs.linux-pam}/lib/security/pam_unix.so
                    '';
                };

                login = {
                    fprintAuth = false;
                };
            };
        };
    };

    users = 
    {
        defaultUserShell = pkgs.zsh;

        users = {
            ${userName} = {
                isNormalUser = true;
                home = "/home/${userName}";
                uid = uid;
                description = "Sky Walker";
                initialPassword = userPassWord;
                linger = true;
                extraGroups = [
                    "wheel"
                    "networkmanager"
                    "podman"
                    "tss"
                ];
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

        light = {
            enable = true;
        };

        neovim = {
            enable = true;
            defaultEditor = true;
        };

        sway = {
            package = pkgs-unstable.sway;

            enable = true;

            wrapperFeatures = {
                gtk = true;
            };

            extraPackages =
            let
                swayExtraPackages = with pkgs-unstable; [
                    swaybg
                    # swaylock
                    swayimg
                    swayidle
                ];
            in
            with pkgs; [
                # swaynotificationcenter
                # wofi
                # waybar
                clipman
                wl-clipboard
                # kitty
                weechat
                # ranger
                w3m
                # neomutt
                zathura
                wl-kbptr
                slurp
            ] ++ swayExtraPackages;
        };
    };

    environment = {
        shells = [
            pkgs.zsh
            pkgs.bashInteractive
        ];

        systemPackages = 
        with pkgs; [
            /* compress */
            p7zip
            unrar
            /* sys */
            dosfstools
            procps
            duf
            /* shell */
            bat
            coreutils
            eza
            fastfetch
            fzf
            jq
            libnotify
            qrencode
            /* git */
            gh
            git
            /* video */
            ffmpeg
            libvpl
            /* container */
            podman-compose
            /* python */
            python3
            uv
            /* net */
            axel
            curl
            dig
            ethtool
            iproute2
            mtr
            nftables
            nmap
            openssh
            rclone
            tcpdump
            wget
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
            /* */
            /* nixos */
            hydra-check
            /* secure boot */
            sbctl
            /* bluetooth */
            bluez-tools
            /* ifuse */
            libimobiledevice
            ifuse
            /* vim */
            lua-language-server
            clang-tools
            pyright
            fd
            bash-language-server
            shellcheck
            shfmt
            nixd
            ripgrep
            /* nix */
            /* game */
            tetris
            /* build */
            bc
            gnumake
        ];
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
