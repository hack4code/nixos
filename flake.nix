{
    description = "Secure Boot Enabled NixOS Config";

    nixConfig = {
        substituters = [
            "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            # "https://mirror.sjtu.edu.cn/nix-channels/store"
            # "https://mirrors.ustc.edu.cn/nix-channels/store"
        ];

        trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
    };

    inputs = {
        nixpkgs = {
            url = "github:NixOS/nixpkgs/nixos-unstable";
        };

        nixpkgs-stable = {
            url = "github:NixOS/nixpkgs/nixos-25.11";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager-stable = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs-stable";
        };

        noctalia-qs = {
            url = "github:noctalia-dev/noctalia-qs/v0.0.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        noctalia = {
            url = "github:noctalia-dev/noctalia-shell/v4.7.1";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.noctalia-qs.follows = "noctalia-qs";
        };

        nixos-hardware = {
            url = "github:NixOS/nixos-hardware/master";
        };

        lanzaboote = {
            url = "github:nix-community/lanzaboote/v1.0.0";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ nixpkgs-stable, home-manager-stable, nixpkgs, home-manager, nixos-hardware, lanzaboote, ...}:
    {
        nixosConfigurations = rec {
            system = "x86_64-linux";

            pkgs-unstable = import nixpkgs {
                inherit system;
                config = {
                    allowUnfree = true;
                };
            };

            pkgs-stable = import nixpkgs-stable {
                inherit system;
                config = {
                    allowUnfree = true;
                };
            };

            modules-base = [
                nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
                lanzaboote.nixosModules.lanzaboote
                ({ lib, ... }: {
                    boot.loader.systemd-boot.enable = lib.mkForce false;
                    boot.lanzaboote = {
                        enable = true;
                        pkiBundle = "/var/lib/sbctl";
                    };
                })
                ./configuration.nix
            ];

            modules-stable = modules-base ++ [
                home-manager-stable.nixosModules.home-manager
            ];

            modules-unstable = modules-base ++ [
                home-manager.nixosModules.home-manager
            ];

            KISS-STABLE = nixpkgs-stable.lib.nixosSystem {
                specialArgs = {
                    inherit pkgs-stable;
                    inherit pkgs-unstable;
                    inherit inputs;
                    stable = true;
                };
                modules = modules-stable;
            };

            KISS-UNSTABLE = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    inherit pkgs-stable;
                    inherit pkgs-unstable;
                    inherit inputs;
                    stable = false;
                };
                modules = modules-unstable;
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
