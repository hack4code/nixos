{
    description = "Secure Boot Enabled NixOS Config";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";

        lanzaboote = {
            url = "github:nix-community/lanzaboote/v0.4.2";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixos-hardware, lanzaboote, ...}:
    let
        system = "x86_64-linux";
        pkgsUnstable = import nixpkgs { inherit system; };
    in
    {
        nixosConfigurations.KISS = nixpkgs.lib.nixosSystem {
            modules = [
                ./configuration.nix
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
                # (
                #     {lib, ... }:
                #     {
                #         services.fwupd = {
                #             enable = true;
                #             package = pkgsUnstable.fwupd;
                #         };
                #     }
                # )
            ];
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
