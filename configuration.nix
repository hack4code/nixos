{ config, pkgs, lib, ... }:

 {
    imports = [
        /* home manager */
        <home-manager/nixos>
        /* tpm2 */
        ./patch/tpm2-tss-fapi.nix
        ./patch/podman.nix
        # ./patch/timesyncd.nix
        /* config */
        ./config/user.nix
        ./config/os.nix
        ./config/wireguard.nix
        ./config/bitwarden.nix
        ./config/dnscrypt-proxy.nix
        ./config/output.nix
        ./config/wifi.nix
        ./config/ntp.nix
        /* system */
        ./nixos/hardware.nix
        ./nixos/boot.nix
        ./nixos/power.nix
        ./nixos/networking.nix
        ./nixos/sysctl.nix
        ./nixos/fontconfig.nix
        ./nixos/container.nix
        ./nixos/input.nix
        ./nixos/sudo.nix
        /* systemd */
        ./nixos/services.nix
        ./nixos/pipewire.nix
        ./nixos/kremap.nix
        ./nixos/wg-quick.nix
        ./nixos/dnscrypt-proxy.nix
        ./nixos/nfs.nix
        /* sway */
        ./home-manager/sway.nix
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
        ./home-manager/script.nix
        ./home-manager/fcitx5.nix
        ./home-manager/rime.nix
        ./home-manager/uv.nix
    ];

    /* nix */
    nix.settings = {
        cores = 8;
        max-jobs = 7;
        show-trace = true;

        experimental-features = [
            "nix-command"
            "flakes"
        ];

        substituters = [
            "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        ];
    };

    /* nixpkgs */
    nixpkgs = {
        hostPlatform = "x86_64-linux";
        config = {
            allowUnfree = true;
        };
    };

    /* home manager */
    home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "backup";
    };

    /* system */
    system = {
        autoUpgrade.enable = false;
        etc.overlay.enable = true;
        stateVersion = "${config.nixosVersion}";
    };

    /* timezone */
    time.timeZone = "Asia/Shanghai";

    /* security */
    security = {
        rtkit.enable = true;
        polkit.enable = true;

        tpm2 = {
            enable = true;
            pkcs11.enable = true;
            abrmd.enable = true;
            tctiEnvironment = {
                enable = true;
                interface = "tabrmd";
            };
        };
    };

    /* user */
    users.defaultUserShell = pkgs.zsh;
    users.users.${config.userName} =
    let
        userName = config.userName;
    in
    {
        isNormalUser = true;
        home = "/home/${userName}";
        uid = 1000;
        description = "Sky Walker";
        initialPassword = "314159";
        linger = true;
        extraGroups = [ "wheel" "networkmanager" "avahi" "audio" "video" "podman" "tss" ];
    };

    /* programs */
    programs = {
        appimage = {
            enable = true;
            binfmt = true;
        };
        neovim = {
            enable = true;
            defaultEditor = true;
        };
        zsh.enable = true;
        light.enable = true;
        sway = {
            enable = true;
            wrapperFeatures.gtk = true;
            extraPackages = with pkgs; [
                wofi
                waybar
                swaynotificationcenter
                swaybg
                swaylock
                swayimg
                swayidle
                slurp
                wl-clipboard
                clipman
                kitty
                weechat
                ranger
                w3m
                neomutt
                zathura
                wl-kbptr
            ];
        };
    };

    environment = {
        shells = [ pkgs.zsh ];
        pathsToLink = [ "/share/zsh" ];
        systemPackages = with pkgs; [
            /* systemd */
            power-profiles-daemon
            /* tool */
            firefox
            openssh
            ffmpeg
            fastfetch
            p7zip
            dosfstools
            eza
            fzf
            libnotify
            jq
            procps
            coreutils
            bc
            /* shell */
            bash
            /* git */
            gh
            git
            /* video */
            libvpl
            /* container */
            podman-compose
            /* python */
            python3
            uv
            /* network */
            curl
            wget
            nftables
            ethtool
            iproute2
            mtr
            tcpdump
            dig
            rclone
            nmap
            /* tpm2 */
            tpm2-tools
            /* firmware */
            sof-firmware
            /* console font */
            kbd
            /* */
            qrencode
            /* nixos */
            hydra-check
            /* secure boot */
            sbctl
            /* build tootls */
            gnumake
            /* bluetooth */
            bluez-tools
            /* ifuse */
            libimobiledevice
            ifuse
            /* nvim lsp */
            pyright
        ];
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
