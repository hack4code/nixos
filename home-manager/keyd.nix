{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        home.file.".config/keyd/app.conf" = {
            executable = false;
            force = true;
            text = ''
                [firefox]
                ctr.j = C-pageup
                ctr.k = C-pagedown
                ctr.h = C-S-pageup
                ctr.l = C-S-pagedown
            '';
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
