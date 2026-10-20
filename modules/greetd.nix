{ pkgs, ... }:

{
    services.greetd =
    let
      tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
      session = "${pkgs.zsh}/bin/zsh";
    in
    {
        enable = true;

        settings = {
            default_session = {
                command = "${tuigreet} --time --cmd ${session}";
                user = "greeter";
            };
        };
   };

   systemd.services.greetd.serviceConfig = {
       Type = "idle";
       StandardInput = "tty";
       StandardOutput = "tty";
       StandardError = "journal";
       TTYReset = true;
       TTYVHangup = true;
       TTYVTDisallocate = true;
   };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
