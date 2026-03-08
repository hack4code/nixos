{ config, pkgs, ... }:

let
    userName = config.userName;
    homeManagerVersion = config.homeManagerVersion;
    cursorName = config.cursorName;
    gmailMailBoxes = config.gmailMailBoxes;
    bwSession = config.bwSession;
in
{
    home-manager.users.${userName} = { lib, ... }:
    {
        home = {
            stateVersion = homeManagerVersion;
            enableNixpkgsReleaseCheck = false;
            preferXdgDirectories = true;

            shell = {
                enableZshIntegration = true;
            };

            sessionPath = [
                "$HOME/.local/bin"
            ];

            sessionVariables = {
                EDITOR = "vim";
                LANG = "en_US.UTF-8";
                LIBVIRT_DEFAULT_URI = "qemu:///system";

                /* pager */
                PAGER = "${pkgs.moor}/bin/moor";
                MANPAGER = "${pkgs.moor}/bin/moor";
                # MANPAGER = "vim +Man!";

                /* moor */
                MOOR = "--colors=16M --no-statusbar --no-linenumbers --terminal-fg --wrap";

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

                /* bitwarden */
                BW_SESSION = "${bwSession}";
            };

            packages = with pkgs; [
                bitwarden-cli
                frogmouth
                linode-cli
                mpc
                /* icon theme */
                adwaita-icon-theme
                adwaita-qt
                candy-icons
                kdePackages.breeze
                morewaita-icon-theme
                /* */
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
                    test -d temp || mkdir temp temp/drive temp/test
                    test -d code || mkdir code
                    test -d document || mkdir document
                    test -d download || mkdir download
                    test -d source || mkdir source
                    test -d .local/share/fetchmail || mkdir .local/share/fetchmail
                    test -d .local/share/tpm2-tss || (mkdir -p .local/share/tpm2-tss/user/keystore .local/share/tpm2-tss/system/keystore .local/share/tpm2-tss/log; tss2_provision;)
                '';
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
