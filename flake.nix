{
    description = "Secure Boot Enabled NixOS Config";

    inputs = {
        nixpkgs = {
            url = "github:NixOS/nixpkgs/nixos-unstable";
        };

        lanzaboote = {
            url = "github:nix-community/lanzaboote/v0.4.2";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-hardware = {
            url = "github:NixOS/nixos-hardware/master";
        };

        nixpkgs-stable = {
            url = "github:NixOS/nixpkgs/nixos-25.05";
        };
    };

    outputs = { nixpkgs-stable, nixpkgs, home-manager, nixos-hardware, lanzaboote, ...}:
    {
        nixosConfigurations = {
            KISS = nixpkgs.lib.nixosSystem rec {
                system = "x86_64-linux";
                specialArgs = {
                    pkgs-stable = import nixpkgs-stable {
                        inherit system;
                        config = {
                            allowUnfree = true;
                        };
                    };
                };

                modules = [
                    home-manager.nixosModules.home-manager
                    nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
                    lanzaboote.nixosModules.lanzaboote
                    (
                        { lib, ... }:
                        {
                            boot.loader.systemd-boot.enable = lib.mkForce false;
                            boot.lanzaboote = {
                                enable = true;
                                pkiBundle = "/var/lib/sbctl";
                            };
                        }
                    )
                    ./configuration.nix
                ];
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
