{ config, ... }:

let
    userName = config.userName;
    accountName = config.accountName;
    version = config.nixosVersion;
in
{

    home-manager.users.${userName} = {
        accounts.email = {
            maildirBasePath = "mail";
            accounts.gmail = {
                primary = true;
                flavor = "gmail.com";
                address = "code4hack@gmail.com";
                userName = "code4hack";
                realName = "Liu Wei";
                passwordCommand = "bw list items --search fetchmail | jq -r '.[].login.password'";
                maildir.path = "gmail";
                folders = {
                    inbox = "inbox";
                };
                imap = {
                    host = "imap.gmail.com";
                    port = 993;
                    tls.enable = true;
                };
                neomutt.enable = false;
            };
        };

        programs.neomutt = {
            enable = true;

            editor = "vim";
            checkStatsInterval = 120;

            sidebar = {
                enable = true;
                shortPath = true;
                width = 30;
                format = "%B(%N|%S)";
            };

            sort = "date-received";

            binds = [
                { key = "\\Cp"; action = "sidebar-prev"; map = [ "index" "pager" ]; }
                { key = "\\Cn"; action = "sidebar-next"; map = [ "index" "pager" ]; }
                { key = "\\Co"; action = "sidebar-open"; map = [ "index" "pager" ]; }
                { key = "\\C]"; action = "sidebar-first"; map = [ "index" "pager" ]; }

                { key = "g"; action = "first-entry"; map = [ "index" ]; }
                { key = "G"; action = "last-entry"; map = [ "index" ]; }
                { key = "zt"; action = "current-top"; map = [ "index" ]; }
                { key = "zz"; action = "current-middle"; map = [ "index" ]; }
                { key = "zb"; action = "current-bottom"; map = [ "index" ]; }
                { key = "\\Cj"; action = "next-new-then-unread"; map = [ "index" "pager" ]; }

                { key = "["; action = "half-up"; map = [ "pager" ]; }
                { key = "]"; action = "half-down"; map = [ "pager" ]; }
                { key = "H"; action = "top"; map = [ "pager" ]; }
                { key = "L"; action = "bottom"; map = [ "pager" ]; }
            ];

            macros = [
                { key = "\\Ca"; action = "<tag-pattern>~N<enter><tag-prefix><clear-flag>N<untag-pattern>.<enter>"; map = [ "index" ]; }
            ];

            settings = {
                pager_stop = "yes";
                pager_index_lines = 5;
                read_inc = 25;
                mailcap_path = "\"~/.config/neomutt/mailcap\"";
                sidebar_visible = "yes";
                sidebar_delim_chars = "'/.'";
                sidebar_divider_char = "'| '";
                sidebar_format = "'%B(%N|%S)'";
                beep = "yes";
                collapse_unread = "yes";
            };

            extraConfig = ''
                set arrow_cursor
                set edit_headers

                # header
                ignore *
                unignore Subject Date
                unhdr_order *
                hdr_order Subject Date

                auto_view text/html

                set display_filter="exec sed -r \"s/^Date:\\s*(([F-Wa-u]{3},\\s*)?[[:digit:]]{1,2}\\s+[A-Sa-y]{3}\\s+[[:digit:]]{4}\\s+[[:digit:]]{1,2}:[[:digit:]]{1,2}(:[[:digit:]]{1,2})?\\s+[+-][[:digit:]]{4})/date +'Date: %F %H:%M:%S,%A' -d '\\1'/e\""

                source color.muttrc
            '';
        };

        home.file.".config/neomutt" = {
            source = ../neomutt;
            recursive = true;
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
