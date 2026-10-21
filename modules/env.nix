{ pkgs, ... }:

{
    environment = {
        sessionVariables = {
            LANG = "en_US.UTF-8";
            EDITOR = "vim";

            /* pager */
            PAGER = "${pkgs.moor}/bin/moor";
            MOOR = "--colors=16M --no-statusbar --no-linenumbers --terminal-fg --wrap --render-unprintable=whitespace";
            MANPAGER = "${pkgs.moor}/bin/moor";
            SYSTEMD_PAGER = "${pkgs.moor}/bin/moor";
            SYSTEMD_PAGERSECURE = "true";

            /* tpm2 */
            TPM2_PKCS11_BACKEND = "esysdb";
            TPM2_PKCS11_LOG_LEVEL = 0;
            TSS2_LOG = "fapi+NONE";

            /* termfilechooser */
            GTK_USE_PORTAL = "1";

            /* libvirt */
            LIBVIRT_DEFAULT_URI = "qemu:///system";
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
