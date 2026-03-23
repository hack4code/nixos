{
    services.keyd = {
        enable = false;

        keyboards = {
            cherry = {
                ids = [
                ];

                settings = {
                    main = {
                        capslock = "overload(control, esc)";
                        rightcontrol = "rightmeta";
                    };
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
