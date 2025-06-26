{ config, pkgs, lib, ... }:

 {
    imports = [
        /* home manager */
        <home-manager/nixos>
        /* tpm2 */
        ./module/tpm2-tss-fapi.nix
        /* config */
        ./config/user.nix
        ./config/os.nix
        ./config/wireguard.nix
        ./config/bitwarden.nix
        ./config/dnscrypt-proxy.nix
        ./config/output.nix
        /* system */
        ./nixos/systemd-boot.nix
        ./nixos/hardware.nix
        ./nixos/boot.nix
        ./nixos/networking.nix
        ./nixos/sysctl.nix
        ./nixos/fontconfig.nix
        ./nixos/container.nix
        ./nixos/input.nix
        ./nixos/sudo.nix
        ./nixos/nixos.nix
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
    ];

    /* nix */
    nix.settings = {
        max-jobs = 7;
        cores = 7;
        substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
    };

    /* home manager */
    home-manager.backupFileExtension = "backup";
    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;

    /* system */
    system.stateVersion = "${config.nixosVersion}";
    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = true;
    system.etc.overlay.enable = true;

    programs.appimage.enable = true;
    programs.appimage.binfmt = true;

    /* timezone */
    time.timeZone = "Asia/Shanghai";

    /* shell */
    environment.shells = [ pkgs.zsh ];
    environment.pathsToLink = [ "/share/zsh" ];
    users.defaultUserShell = pkgs.zsh;

    /* security */
    security.rtkit.enable = true;
    security.polkit.enable = true;

    /* tpm2 */
    security.tpm2.enable = true;
    security.tpm2.pkcs11.enable = true;
    security.tpm2.abrmd.enable = true;
    security.tpm2.tctiEnvironment.enable = true;
    security.tpm2.tctiEnvironment.interface = "tabrmd";

    /* user */
    users.users.${config.userName} =
    let userName = config.userName;
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

    /* sway */
    programs.sway = {
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
            kitty
            weechat
            ranger
            neomutt
            zathura
            htop
            btop
            mpv
            mpc
            jupyter
            bitwarden-cli
        ];
    };

    /* package */
    programs.zsh.enable = true;
    programs.light.enable = true;

    environment.systemPackages = with pkgs; [
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
        /* editor */
        vim
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
        axel
        rsync
        nftables
        ethtool
        iproute2
        trippy
        tcpdump
        dig
        rclone
        /* tpm2 */
        tpm2-tools
        /* firmware */
        sof-firmware
        /* console font */
        kbd
    ];
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
