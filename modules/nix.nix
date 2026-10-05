{ lib, nixOSVersion, ... }:

{
    nix = {
        channel = {
            enable = false;
        };

        settings = {
            cores = 7;
            max-jobs = 7;
            show-trace = true;
            sandbox = true;
            sandbox-fallback = false;
            require-sigs = true;
            auto-optimise-store = true;
            warn-dirty = false;

            trusted-users = [
                "@wheel"
            ];

            experimental-features = [
                "flakes"
                "nix-command"
                "ca-derivations"
                "local-overlay-store"
                "read-only-local-store"
            ];
        };

        gc = {
            automatic = false;
            dates = "weekly";
            options = "--delete-older-than 8d";
            persistent = true;
        };

        optimise = {
            automatic = true;
            persistent = true;
        };
    };

    nixpkgs = {
        hostPlatform = "x86_64-linux";
        config = {
            allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
                "unrar"
                "intel-ocl"
                "zsh-abbr"
                "rpcs3"
                "broadcom-bt-firmware"
                /* firefox */
                "firefox-bin-unwrapped"
                "firefox-bin"
                /* lutris */
                "steam"
                "steam-unwrapped"
                "lutris"
                /* nix */
                "lsfg-vk"
            ];
        };
    };

    system = {
        autoUpgrade = {
            enable = false;
        };

        /* has bug when nixos-install */
        # etc = {
        #     overlay = {
        #         enable = true;
        #     };
        # };

        stateVersion = nixOSVersion;
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
