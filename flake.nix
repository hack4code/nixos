{
    description = "Secure Boot Enabled NixOS Config";

    nixConfig = {
        substituters = [
            "https://mirror.sjtu.edu.cn/nix-channels/store"
            "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
            "https://mirrors.ustc.edu.cn/nix-channels/store"
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        extra-substituters = [
            "https://noctalia.cachix.org"
        ];
        extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
    };

    inputs = {
        nixpkgs = {
            url = "github:NixOS/nixpkgs/nixos-unstable";
        };

        nixpkgs-stable = {
            url = "github:NixOS/nixpkgs/nixos-26.05";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager-stable = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs-stable";
        };

        noctalia = {
            url = "github:noctalia-dev/noctalia/v5.3.0";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-hardware = {
            url = "github:NixOS/nixos-hardware/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        lanzaboote = {
            url = "github:nix-community/lanzaboote/v1.2.0";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ nixpkgs-stable,  nixpkgs,  nixos-hardware, home-manager, home-manager-stable, lanzaboote, ...}:
    {
        nixosConfigurations =
        let
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
        in
        {
            KISS-STABLE = nixpkgs-stable.lib.nixosSystem {
                specialArgs = {
                    inherit pkgs-stable;
                    inherit pkgs-unstable;
                    inherit inputs;
                    nixOSVersion = "26.05";
                };

                modules = modules-base ++ [
                    home-manager-stable.nixosModules.home-manager
                ];
            };

            KISS-UNSTABLE = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    inherit pkgs-stable;
                    inherit pkgs-unstable;
                    inherit inputs;
                    nixOSVersion = "26.11";
                };

                modules = modules-base ++ [
                    home-manager.nixosModules.home-manager
                ];
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
