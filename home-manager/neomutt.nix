{ config, pkgs, ... }:

let
    userName = config.userName;
    gmailAccount = config.gmailAccount;
    gmailMailBoxes = config.gmailMailBoxes;
in
{
    home-manager.users.${userName} = {
        accounts.email = {
            maildirBasePath = "/home/${userName}";
            accounts.gmail = {
                enable = true;

                primary = true;
                userName = gmailAccount;
                realName = gmailAccount;
                address = "${gmailAccount}@gmail.com";

                passwordCommand = "bw list items --search fetchmail | jq -r '.[].login.password'";
                imap = {
                    host = "imap.gmail.com";
                    port = 993;
                    tls = {
                        enable = true;
                    };
                };

                msmtp = {
                    enable = true;
                };

                getmail = {
                    enable = false;
                };

                mbsync = {
                    enable = false;
                };

                maildir = {
                    path = "mail";
                };

                folders = {
                    inbox = "inbox";
                    drafts = "drafts";
                    trash = "trash";
                    sent = "sent";
                };

                neomutt = {
                    enable = true;
                    mailboxType = "maildir";
                    showDefaultMailbox = false;
                    extraMailboxes = gmailMailBoxes;
                };
            };
        };

        programs.neomutt = {
            enable = true;

            editor = "vim";
            checkStatsInterval = 120;

            sidebar = {
                enable = true;
                shortPath = true;
                width = 36;
                format = "%B(%N|%S)";
            };

            sort = "date-received";

            binds = [
                { key = "\\Ck"; action = "sidebar-prev"; map = [ "index" "pager" ]; }
                { key = "\\Cj"; action = "sidebar-next"; map = [ "index" "pager" ]; }
                { key = "\\Co"; action = "sidebar-open"; map = [ "index" "pager" ]; }
                { key = "\\C0"; action = "sidebar-first"; map = [ "index" "pager" ]; }

                { key = "g"; action = "first-entry"; map = [ "index" ]; }
                { key = "G"; action = "last-entry"; map = [ "index" ]; }
                { key = "zt"; action = "current-top"; map = [ "index" ]; }
                { key = "zz"; action = "current-middle"; map = [ "index" ]; }
                { key = "zb"; action = "current-bottom"; map = [ "index" ]; }

                { key = "<Tab>"; action = "next-unread"; map = [ "index" "pager" ]; }

                { key = "["; action = "half-up"; map = [ "pager" ]; }
                { key = "]"; action = "half-down"; map = [ "pager" ]; }
                { key = "H"; action = "top"; map = [ "pager" ]; }
                { key = "L"; action = "bottom"; map = [ "pager" ]; }
            ];

            macros = [
                {
                    key = "\\Ca";
                    action = "<tag-pattern>~N<enter><tag-prefix><clear-flag>N<untag-pattern>.<enter>";
                    map = [ "index" ];
                }
            ];

            settings = {
                folder="~/mail/";
                tilde="yes";
                mark_old="no";
                move="no";
                pager_stop = "yes";
                delete="yes";
                arrow_cursor="yes";
                use_threads="yes";
                tmp_dir="/tmp/neomutt";
                check_new="yes";
                sidebar_sort_method="unread";
                sidebar_next_new_wrap="yes";
                sidebar_indent_string="   ";
                sidebar_visible = "yes";
                sidebar_delim_chars = "'/.'";
                sidebar_divider_char = "'| '";
                mail_check="60";
                mail_check_recent="yes";
                mail_check_stats="yes";
                maildir_check_cur="yes";
                maildir_trash="no";
                narrow_tree="no";
                sleep_time="0";
                status_on_top="no";
                pager_index_lines = "5";
                read_inc = "25";
                mailcap_path = "~/.config/neomutt/mailcap:/etc/mailcap:/usr/etc/mailcap:/usr/local/etc/mailcap:";
                beep = "yes";
                collapse_unread = "yes";
            };

            extraConfig = ''
                # set display_filter="exec sed -r \"s/^Date:\\s*(([F-Wa-u]{3},\\s*)?[[:digit:]]{1,2}\\s+[A-Sa-y]{3}\\s+[[:digit:]]{4}\\s+[[:digit:]]{1,2}:[[:digit:]]{1,2}(:[[:digit:]]{1,2})?\\s+[+-][[:digit:]]{4})/date +'Date: %F %H:%M:%S,%A' -d '\\1'/e\"";

                ignore *
                unignore Subject
                # unhdr_order *
                # hdr_order Subject

                color        attachment             color109        default
                color        bold                   color229        default
                color        error                  color167        default
                color        hdrdefault             color246        default
                color        indicator              color142        default
                color        markers                color243        default
                color        normal                 default         default
                color        quoted                 color250        default
                color        quoted1                color108        default
                color        quoted2                color250        default
                color        quoted3                color108        default
                color        quoted4                color250        default
                color        quoted5                color108        default
                color        search                 color234        default
                color        signature              color108        default
                color        status                 color141        color236
                color        tilde                  color231        default
                color        tree                   color141        default
                color        underline              color223        default

                color        sidebar_divider        color13         default
                color        sidebar_new            color14         default
                color        sidebar_indicator      color223        color237
                color        sidebar_highlight      color142        default

                color        index                  color117        default     ~U
                color        index                  color59         default     ~D

                color        header                 color142        default     "^Subject:"

                color        body                   color142        default     "[a-z]{3,255}://[[:graph:]]*"
                color        body                   color142        default     "([-[:alnum:]]+\\.)+([0-9]{1,3}|[-[:alpha:]]+)/[[:graph:]]*"
                color        body                   color142        default     "([-[:alnum:]]+\\.){2,255}[-[:alpha:]]{2,10}"
                color        body                   color142        default     "((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])"
                color        body                   color142        default     "(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+"
                color        body                   color208        default     "[-a-z_0-9.%$]+@[-a-z_0-9.]+\\.[-a-z][-a-z]+"
                color        body                   color208        default     "mailto:[-a-z_0-9.]+@[-a-z_0-9.]+"
                color        body                   color234        default     "[;:]-*[)>(<lt;|]"
                color        body                   color229        default     "\\*[- A-Za-z]+\\*"
            '';
        };

        home.file.".config/neomutt/mailcap" = {
            executable = false;
            force = true;
            text = ''
                text/html; ${pkgs.w3m}/bin/w3m -I %{charset} -T text/html; copiousoutput;
            '';
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
