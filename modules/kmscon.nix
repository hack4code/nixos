{ ... }:

{
    services.kmscon = {
        enable = true;

        useXkbConfig = false;

        config = {
            hwaccel = true;
            gpus = "all";
            libseat = false;
            multi-monitor = "clone";
            font-name = "Google Sans Code, Noto Sans CJK SC";
            term = "xterm-256color";
            session-max = 3;
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
