{ config, ... }:

let
    userName = config.userName;
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
                maildir = {
                    path = "gmail";
                };
                folders = {
                    inbox = "inbox";
                };
                imap = {
                    host = "imap.gmail.com";
                    port = 993;
                    tls = {
                        enable = true;
                    };
                };
                neomutt = {
                    enable = false;
                };
            };
        };

        programs.neomutt = {
            enable = true;
            /*
            sourcePrimaryAccount = false;
            unmailboxes = true;

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

                mailboxes `echo $HOME/mail/*`

                # general ------------- foreground ---- background -----------------------------
                color error		          color167	      default
                color indicator		      brightgreen	    default
                color markers		        color210	      default
                # color message		        default		      default
                # color normal		        default		      default
                # color prompt		        default	        default
                color search		        color84		      default
                color status 		        color141	      color236
                color tilde		          color231	      default
                color tree		          color141	      default

                # message index ------- foreground ---- background -----------------------------
                color index		          color210	      default 	    ~D # deleted messages
                color index		          color84		      default 	    ~F # flagged messages
                color index		          color117	      default 	    ~N # new messages
                color index		          color212	      default 	    ~Q # messages which have been replied to
                color index		          color215	      default 	    ~T # tagged messages
                color index		          color141	      default		    ~v # messages part of a collapsed thread

                # message headers ----- foreground ---- background -----------------------------
                color header		        color142        default		    ^Subject:.* # subject
                color header		        color214        default		    ^Date:.*    # date

                # message body -------- foreground ---- background -----------------------------
                color attachment	      color245  	    default
                color body		          cyan 	          default		    [\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+         # email
                color body		          blue 	          default		    (https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+  # url
                color quoted		        color61		      default
                color quoted1		        color117	      default
                color quoted2		        color84		      default
                color quoted3		        color215	      default
                color quoted4		        color212	      default
                color signature		      color212	      default

                # sidebar ------------  foreground ---- background -----------------------------
                color sidebar_new       color14         default
                color sidebar_divider   color13         default
                color sidebar_highlight brightgreen     default
                color sidebar_indicator lightred        default
            '';
            */
        };

        home.file.".config/neomutt" = {
            source = ./neomutt;
            recursive = true;
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
