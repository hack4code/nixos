{ config, pkgs, ... }:

let
    userName = config.userName;
    userHome = config.userHome;
    gmailAccount = config.gmailAccount;
    gmailMailBoxes = config.gmailMailBoxes;
in
{
    home-manager.users.${userName} = {
        accounts.email = {
            maildirBasePath = userHome;
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

                {
                    key = "\\Cb";
                    action = "<pipe-message>urlscan --nohelp --run 'open_url_from_kitty.py {}'<enter>";
                    map = [ "index" "pager" ];
                }
            ];

            settings = {
                folder="~/mail/";
                tilde="yes";
                ts_enabled="yes";
                ts_status_format="%B";
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
                color        error                  color1          default
                color        message                color9          default
                color        prompt                 color190        default
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
                color        status                 color141        color237
                color        tilde                  color231        default
                color        tree                   color141        default
                color        underline              color223        default

                color        sidebar_divider        color13         default
                color        sidebar_new            color6          default
                color        sidebar_indicator      color9          color237
                color        sidebar_highlight      color142        default

                color        index                  color117        default     ~U
                color        index                  color59         default     ~D

                color        header                 color142        default     "^Subject:"

                color        body                   color142        default     "(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+"
                color        body                   color208        default     "[-a-z_0-9.%$]+@[-a-z_0-9.]+\\.[-a-z][-a-z]+"
                color        body                   color208        default     "mailto:[-a-z_0-9.]+@[-a-z_0-9.]+"
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

        home.file.".config/urlscan/config.json" = {
            executable = false;
            force = true;
            text = ''
                {
                    "palettes": {
                        "default": [
                            [
                                "header",
                                "white",
                                "dark gray",
                                "bold",
                                "#ffffff",
                                "#0000aa"
                            ],
                            [
                                "footer",
                                "white",
                                "light red",
                                "standout",
                                "#ffffff",
                                "#aa0000"
                            ],
                            [
                                "search",
                                "white",
                                "dark green",
                                "standout",
                                "#ffffff",
                                "#00aa00"
                            ],
                            [
                                "msgtext",
                                "",
                                "",
                                "",
                                "",
                                ""
                            ],
                            [
                                "msgtext:ellipses",
                                "yellow",
                                "default",
                                "",
                                "#aaaaaa",
                                "#000000"
                            ],
                            [
                                "urlref:number:braces",
                                "yellow",
                                "default",
                                "",
                                "#aaaaaa",
                                "#000000"
                            ],
                            [
                                "urlref:number",
                                "light red",
                                "default",
                                "standout",
                                "#ffff00",
                                "#000000"
                            ],
                            [
                                "urlref:url",
                                "dark green",
                                "default",
                                "standout",
                                "#ffffff",
                                "#000000"
                            ],
                            [
                                "url:sel",
                                "light green",
                                "dark blue",
                                "bold",
                                "#ffffff",
                                "#0000aa"
                            ]
                        ]
                    },
                    "keys": {
                        "/": "search_key",
                        "0": "digits",
                        "1": "digits",
                        "2": "digits",
                        "3": "digits",
                        "4": "digits",
                        "5": "digits",
                        "6": "digits",
                        "7": "digits",
                        "8": "digits",
                        "9": "digits",
                        "a": "add_url",
                        "C": "clipboard",
                        "c": "context",
                        "ctrl l": "clear_screen",
                        "f": "page_down",
                        "b": "page_up",
                        "d": "del_url",
                        "f1": "help_menu",
                        "G": "bottom",
                        "g": "top",
                        "j": "down",
                        "k": "up",
                        "J": "next",
                        "K": "previous",
                        "P": "clipboard_pri",
                        "l": "link_handler",
                        "o": "open_queue",
                        "O": "open_queue_win",
                        "p": "palette",
                        "Q": "quit",
                        "q": "quit",
                        "R": "reverse",
                        "S": "all_shorten",
                        "s": "shorten",
                        "u": "all_escape"
                    }
                }
            '';
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
