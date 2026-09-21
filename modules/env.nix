{ pkgs, ... }:

{
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
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
