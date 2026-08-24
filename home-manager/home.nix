{ config, pkgs, nixOSVersion, ... }:

let
    userName = config.userName;
    cursorName = config.cursorName;
    gmailMailBoxes = config.gmailMailBoxes;
    bwSession = config.bwSession;
in
{
    home-manager.users.${userName} = { lib, ... }:
    {
        home = {
            stateVersion = nixOSVersion;

            enableNixpkgsReleaseCheck = false;
            preferXdgDirectories = true;

            shell = {
                enableZshIntegration = true;
            };

            sessionPath = [
                "$HOME/.local/bin"
            ];

            sessionVariables = {
                # GNUPGHOME = "$HOME/.config/gpg";
                # GOPATH = "$HOME/.local/share/go";
                # GPG_TTY = "$(tty)";

                /* fcitx5 */
                GTK_IM_MODULE = "wayland";
                SDL_IM_MODULE = "fcitx";
                XMODIFIERS = "@im=fcitx";
                QT_IM_MODULE = "fcitx";

                /* ibus */
                # GTK_IM_MODULE = "ibus";
                # XMODIFIERS = "@im=ibus";
                # QT_IM_MODULE = "ibus";

                /* sway */
                WLR_RENDERER = "vulkan";
                SDL_VIDEODRIVER = "wayland";
                QT_QPA_PLATFORM = "wayland";
                QT_ENABLE_HIGHDPI_SCALING = "1";
                QT_FONT_DPI = "96";
                # QT_SCALE_FACTOR = "1.0";

                /* noctalia-shell */
                QS_ICON_THEME = "candy-icons";

                /* bitwarden */
                BW_SESSION = "${bwSession}";

                /* tpm2 */
                TPM2_PKCS11_BACKEND = "esysdb";
                TSS2_LOG = "fapi+NONE";

                /* vaapi */
                # LIBVA_DRIVER_NAME = "iHD";

                /* bottles */
                PROTON_USE_NTSYNC = "1";
            };

            packages = with pkgs; [
                bitwarden-cli
                linode-cli
                (
                    callPackage ./rpcd/rpcd.nix { }
                )
                (
                    callPackage ./openurl/openurl.nix { }
                )
            ];

            pointerCursor = {
                enable = true;
                name = cursorName;
                package = pkgs.graphite-cursors;
                size = 18;
                gtk = {
                    enable = true;
                };
            };

            activation =
            let
                mboxes = lib.strings.concatStrings (lib.strings.intersperse " " (map (v: "mail/${v} mail/${v}/new mail/${v}/cur mail/${v}/tmp") gmailMailBoxes));
            in
            {
                initHome = lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" ] ''
                    test -d mail || mkdir mail mail/sent mail/trash mail/inbox mail/drafts ${mboxes}
                    test -d book || mkdir book book/.reading
                    test -d movie || mkdir movie movie/.rsync movie/.camer
                    test -d music || mkdir music music/lyrics music/playlist music/song music/youtube
                    test -d picture || mkdir picture picture/icon picture/mpv picture/screen picture/wallpaper
                    test -d temp || mkdir temp temp/drive temp/test temp/vps
                    test -d code || mkdir code
                    test -d document || mkdir document
                    test -d download || mkdir download
                    test -d source || mkdir source
                    test -d .local/share/zsh || mkdir .local/share/zsh
                    test -d .local/share/fetchmail || mkdir .local/share/fetchmail
                    test -d .local/share/tpm2-tss || (mkdir -p .local/share/tpm2-tss/user/keystore .local/share/tpm2-tss/system/keystore .local/share/tpm2-tss/log; tss2_provision;)
                    test -d .cache/yazi || mkdir .cache/yazi
                '';
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
