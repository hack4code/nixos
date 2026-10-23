{
    description = "A flake for Alibaba PuHui fonts";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs { inherit system; };
    in
    {
        packages = {
            PuHuiTi = pkgs.stdenv.mkDerivation {
                name = "puhui";

                src = self;

                postInstall = ''
                    mkdir -p $out/share/fonts/
                    ${pkgs.findutils}/bin/find . -type d -name '*PuHuiTi*' -exec cp -r {} $out/share/fonts/ \;
                '';

                meta = {
                    description = "Alibaba PuHuiTi fonts";
                };
            };
        };

        defaultPackage = self.packages.${system}.PuHuiTi;

        devShells.default = pkgs.mkShell {
            buildInputs = [
                pkgs.fontconfig
                self.packages.${system}.PuHuiTi
            ];
            shellHook = ''
                export FONTCONFIG_FILE=${pkgs.makeFontsConf {
                    fontDirectories = [ self.packages.${system}.PuHuiTi ];
                }}
            '';
        };
    });
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
