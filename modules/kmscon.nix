{ ... }:

{
    services.kmscon = {
        enable = true;

        hwaccel = true;
        useXkbConfig = true;
        term = "xterm-256color";
        font-name = "Google Sans Code, Noto Sans CJK SC";
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
