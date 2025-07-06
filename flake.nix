{
    description = "Secure Boot Enabled NixOS Config";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        lanzaboote = {
            url = "github:nix-community/lanzaboote/v0.4.2";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, lanzaboote, ...}: {
        nixosConfigurations = {
            KISS = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
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
                ];
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
