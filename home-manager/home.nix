{ config, pkgs, ... }:

let
    userName = config.userName;
    homeManagerVersion = config.homeManagerVersion;
    cursorName = config.cursorName;
    gmailMailBoxes = config.gmailMailBoxes;
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

            packages = with pkgs; [
                bitwarden-cli
                frogmouth
                linode-cli
                mpc
                (
                    callPackage ./rpcd/rpcd.nix { }
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
