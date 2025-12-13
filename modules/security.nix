{ pkgs, ... }:

{
    security = {
        rtkit = {
            enable = true;
        };

        polkit = {
            enable = true;
        };

        tpm2 = {
            enable = true;
            pkcs11 = {
                enable = true;
            };
            abrmd = {
                enable = true;
            };
            tctiEnvironment = {
                enable = true;
                interface = "tabrmd";
            };
        };

        pam = {
            services = {
                swaylock = {
                    text = ''
                        auth sufficient ${pkgs.linux-pam}/lib/security/pam_unix.so try_first_pass likeauth nullok
                        auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
                        auth required ${pkgs.linux-pam}/lib/security/pam_deny.so
                        auth required ${pkgs.linux-pam}/lib/security/pam_unix.so
                    '';
                };

                login = {
                    fprintAuth = false;
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
