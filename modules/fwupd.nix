{ pkgs, ... }:

{
    services.fwupd = {
        enable = true;

        package = pkgs.fwupd.overrideAttrs (old: {
            postPatch = (old.postPatch or "") + ''
              substituteInPlace meson.build \
                  --replace-fail \
                  "efi_app_location = join_paths(dependency('fwupd-efi').get_variable(pkgconfig: 'prefix'), 'libexec', 'fwupd', 'efi')" \
                  "efi_app_location = '/run/fwupd-efi'"
            '';
        });

        uefiCapsuleSettings = {
            DisableShimForSecureBoot = true;
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
