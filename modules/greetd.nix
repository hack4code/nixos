{ pkgs, ... }:

{
    services.greetd =
    let
      tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
      # kmscon = "${pkgs.kmscon}/bin/kmscon";
    in
    {
        enable = true;

        useTextGreeter = true;

        settings = {
            default_session = {
                # command = "${kmscon} --no-reset-env --login -- ${tuigreet} --time --cmd zsh -i";
                command = "${tuigreet} --time --cmd zsh";
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
