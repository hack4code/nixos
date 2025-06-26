{ config, pkgs, lib, ... }:

# let
#     home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
# in
 {
    imports = [
        /* home manager */
        # ( import "${home-manager}/nixos" )
        <home-manager/nixos>
        /* config */
        ./nixos/user.nix
        ./nixos/os.nix
        ./nixos/wireguard.nix
        ./nixos/bitwarden.nix
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
        /* systemd */
        ./nixos/services.nix
        ./nixos/pipewire.nix
        ./nixos/kremap.nix
        ./nixos/wg-quick.nix
        ./nixos/dnscrypt-proxy.nix
        ./nixos/nfs.nix
        /* sway */
        ./nixos/sway.nix
        ./nixos/swaylock.nix
        ./nixos/swaync.nix
        ./nixos/waybar.nix
        ./nixos/ssh.nix
        ./nixos/btop.nix
        ./nixos/htop.nix
        ./nixos/xdg-desktop-portal.nix
        ./nixos/zsh.nix
        ./nixos/neomutt.nix
        ./nixos/ranger.nix
        ./nixos/kitty.nix
        ./nixos/mpd.nix
        ./nixos/ncmpcpp.nix
        ./nixos/wofi.nix
        ./nixos/mpv.nix
        ./nixos/zathura.nix
        ./nixos/firefox.nix
        ./nixos/vim.nix
        ./nixos/downmovie.nix
        ./nixos/syncdrive.nix
        ./nixos/script.nix
        ./nixos/fcitx5.nix
        ./nixos/rime.nix
    ];

    /* nix */
    nix.settings = {
        max-jobs = 7;
        cores = 7;
        substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
    };

    /* home manager */
    home-manager.backupFileExtension = "backup";

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
    security.tpm2.tctiEnvironment.enable = true;

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
            ncmpcpp
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
        /* tpm2 */
        tpm2-tools
        tpm2-tss
        tpm2-pkcs11
        tpm2-abrmd
        /* firmware */
        sof-firmware
        /* console font */
        kbd
    ];
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
