{
    description = "Secure Boot Enabled NixOS Config";

    nixConfig = {
        substituters = [
            "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
            "https://mirror.sjtu.edu.cn/nix-channels/store"
            "https://mirrors.ustc.edu.cn/nix-channels/store"
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
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
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-hardware = {
            url = "github:NixOS/nixos-hardware/master";
        };

        lanzaboote = {
            url = "github:nix-community/lanzaboote/v1.0.0";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs-stable, nixpkgs, home-manager, nixos-hardware, lanzaboote, ...}:
    {
        nixosConfigurations = {
            KISS = nixpkgs.lib.nixosSystem rec {
                system = "x86_64-linux";
                specialArgs = {
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

                    stable = false;
                };

                modules = [
                    home-manager.nixosModules.home-manager
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
            };

        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
