{ config, ... }:

let
    nixosVersion = config.nixosVersion;
in
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

            trusted-users = [
                "@wheel"
            ];

            experimental-features = [
                "flakes"
                "nix-command"
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
            allowUnfree = true;
        };
    };

    system = {
        autoUpgrade = {
            enable = false;
        };

        etc = {
            overlay = {
                enable = true;
            };
        };

        stateVersion = nixosVersion;
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
