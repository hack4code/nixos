{ config, pkgs, ... }:

let
    userName = config.userName;
    colorWhite = config.colorWhite;
    colorGray = config.colorGray;
    colorRed = config.colorRed;
    colorYellow = config.colorYellow;
    colorBlack = config.colorBlack;
    colorGreen = config.colorGreen;
    colorBlue = config.colorBlue;
    colorOrange = config.colorOrange;
    colorPurple = config.colorPurple;
    colorForeground = config.colorForeground;
    colorLightWhite = config.colorLightWhite;
    colorLightBlue = config.colorLightBlue;
    colorLightGreen = config.colorLightGreen;
    colorLightOrange = config.colorLightOrange;
    colorLightRed = config.colorLightRed;
    colorLightPurple = config.colorLightPurple;
    colorBackground0 = config.colorBackground0;
    colorBackground1 = config.colorBackground1;
    colorBackground2 = config.colorBackground2;
    # wgServerIp4Address = config.wgServerIp4Address;
in
{
    home-manager.users.${userName} = {
        programs.yazi = {
            enable = true;
            shellWrapperName = "yz";
            enableBashIntegration = true;
            enableZshIntegration = true;

            extraPackages = [ ];

            plugins = {
                full-border = pkgs.yaziPlugins.full-border;
                no-status= pkgs.yaziPlugins.no-status;
                sshfs = pkgs.yaziPlugins.sshfs;
            };

            initLua = ''
                --- full border
                require("full-border"):setup {
                    type = ui.Border.ROUNDED,
                }

                --- no status
                require("no-status"):setup()

                --- user name & host name
                Header:children_add(function()
                    return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("${colorBlue}")
                end, 500, Header.LEFT)

                --- sshfs
                require("sshfs").setup({
                    mount_dir = os.getenv("HOME") .. "/temp/vps",
                    default_mount_point = "home",
                    default_user = "auto",
                    sshfs_options = {
                        "reconnect",                      -- Auto-reconnect on connection loss
                        "ConnectTimeout=12",               -- Connection timeout in seconds
                        "compression=yes",                -- Enable compression
                        "ServerAliveInterval=30",         -- Keep-alive interval (15s × 3 = 45s timeout)
                        "ServerAliveCountMax=3",          -- Keep-alive message count
                    }
                })
            '';

            keymap = {
                mgr = {
                    prepend_keymap = [
                        { on = [ "q" ]; run = "quit"; }
                        { on = "T"; run = "shell --orphan --confirm \"${pkgs.kitty}/bin/kitty --class floatkitty --override font_size=13 --override modify_font='cell_height +10px'\""; }
                        { on = [ "]" ]; run = "plugin parent-arrow 1"; }
                        { on = [ "[" ]; run = "plugin parent-arrow -1"; }
                        { on = [ "H" ]; run = "arrow top"; }
                        { on = [ "L" ]; run = "arrow bot"; }
                        { on = [ "F" ]; run = "forward"; }
                        { on = [ "B" ]; run = "back"; }
                        { on = [ "g" "d" ]; run = "cd ~/download/"; }
                        { on = [ "g" "m" ]; run = "cd ~/movie/"; }
                        { on = [ "g" "b" ]; run = "cd ~/book/"; }
                        { on = [ "g" "s" ]; run = "cd ~/source/"; }
                        { on = [ "g" "g" ]; run = "cd ~/game/"; }
                        { on = [ "g" "p" ]; run = "cd ~/picture/"; }
                        { on = [ "g" "c" ]; run = "cd ~/movie/Camera/"; }
                        { on = [ "g" "v" ]; run = "cd ~/temp/vps/linode/"; }
                        { on = ["M" "m"]; run = "plugin sshfs -- mount"; }
                        { on = ["M" "u"]; run = "plugin sshfs -- unmount"; }
                        { on = ["M" "h"]; run = "plugin sshfs -- home"; }
                    ];
                };
            };

            settings = {
                log = {
                    enabled = false;
                };

                mgr = {
                    linemode = "size";
                    sort_by = "alphabetical";
                    show_hidden = false;
                    sort_sensitive = false;
                    sort_dir_first = false;
                    sort_reverse = false;
                    ratio = [ 1 4 3 ];
                };

                pick = {
                    Origin = "center";
                };

                preview = {
                    max_width = 1000;
                    image_quality = 50;
                    cache_dir = "~/.cache/yazi/";
                };

                plugin = {
                    prepend_previewers = [
                        { mime = "video/*"; run = "noop"; }
                    ];
                };

                opener = {
                    play = [
                        {
                            run = "${pkgs.mpv}/bin/mpv %s";
                            orphan = true;
                            for = "linux";
                        }
                    ];

                    display = [
                        {
                            run = "${pkgs.swayimg}/bin/swayimg %s";
                            orphan = true;
                            for = "linux";
                        }
                    ];

                    read = [
                        {
                            run = "${pkgs.zathura}/bin/zathura %s";
                            orphan = true;
                            for = "linux";
                        }
                    ];

                    edit = [
                        {
                            run = "$EDITOR %s";
                            block = true;
                            for = "linux";
                        }
                    ];

                    unrar = [
                        {
                            run = "${pkgs.unrar}/bin/unrar e %s";
                            block = true;
                            for = "linux";
                        }
                    ];

                    unzip = [
                        {
                            run = "${pkgs.p7zip}/bin/7z e %s";
                            block = true;
                            for = "linux";
                        }
                    ];

                    open = [
                        {
                            run = "xdg-open %s1";
                            for = "linux";
                        }
                    ];
                };

                open = {
                    rules = [
                        { mime = "text/*"; use = "edit"; }
                        { mime = "video/*"; use = "play"; }
                        { mime = "image/*"; use = "display"; }
                        { url = "*.pdf"; use = "read"; }
                        { url = "*.epub"; use = "read"; }
                        { url = "*.rar"; use = "unrar"; }
                        { url = "*.zip"; use = "unzip"; }
                        { url = "*.7z"; use = "unzip"; }
                        { url = "*.srt"; use = "edit"; }
                    ];
                };
            };

            theme = {
                indicator = {
                    parent = {
                        bg = "${colorBackground2}";
                    };

                    current = {
                        fg = "${colorLightGreen}";
                        bg = "${colorBackground1}";
                    };

                    preview = {
                        underline = true;
                    };
                };

                manager = {
                    cwd = {
                        fg = "${colorLightBlue}";
                    };

                    find_keyword = {
                        fg = "${colorLightGreen}";
                        italic = true;
                    };

                    find_position = {
                        fg = "${colorLightOrange}";
                        bg = "reset";
                        italic = true;
                    };

                    marker_selected = {
                        fg = "${colorLightGreen}";
                        bg = "${colorLightGreen}";
                    };

                    marker_copied = {
                        fg = "${colorLightGreen}";
                        bg = "${colorLightGreen}";
                    };

                    marker_cut = {
                        fg = "${colorLightRed}";
                        bg = "${colorLightRed}";
                    };

                    tab_active = {
                        fg = "${colorBackground0}";
                        bg = "${colorBackground2}";
                    };

                    tab_inactive = {
                        fg = "${colorGray}";
                        bg = "${colorBackground1}";
                    };

                    border_symbol = "│";
                    border_style  = {
                        fg = "${colorBlack}";
                    };
                };

                status = {
                    separator_open = "";
                    separator_close = "";
                    separator_style = {
                        fg = "${colorBackground1}";
                        bg = "${colorBackground1}";
                    };

                    progress_label = {
                        fg = "${colorForeground}";
                        bold = true;
                    };

                    progress_normal = {
                        fg = "${colorBackground2}";
                        bg = "${colorBackground1}";
                    };

                    progress_error = {
                        fg = "${colorLightRed}";
                        bg = "${colorBackground1}";
                    };

                    permissions_t = { fg = "${colorBackground2}"; };
                    permissions_r = { fg = "${colorLightGreen}"; };
                    permissions_w = { fg = "${colorLightRed}"; };
                    permissions_x = { fg = "${colorLightGreen}"; };
                    permissions_s = { fg = "${colorBlack}"; };
                };

                mode = {
                    normal_main = {
                        fg = "${colorBackground0}";
                        bg = "${colorGray}";
                        bold = true;
                    };

                    normal_alt = {
                        fg = "${colorBackground0}";
                        bg = "${colorGray}";
                        bold = true;
                    };

                    select_main = {
                        fg = "${colorBackground0}";
                        bg = "${colorLightGreen}";
                        bold = true;
                    };

                    select_alt = {
                        fg = "${colorBackground0}";
                        bg = "${colorLightGreen}";
                        bold = true;
                    };

                    unset_main  = {
                        fg = "${colorBackground0}";
                        bg = "${colorLightPurple}";
                        bold = true;
                    };

                    unset_alt  = {
                        fg = "${colorBackground0}";
                        bg = "${colorLightPurple}";
                        bold = true;
                    };
                };

                select = {
                    border = {
                        fg = "${colorBackground2}";
                    };

                    active = {
                        fg = "${colorLightOrange}";
                    };

                    inactive = { };
                };

                tasks = {
                    border  = {
                        fg = "${colorBackground2}";
                    };

                    title   = { };

                    hovered = {
                        underline = true;
                    };
                };

                which = {
                    mask = {
                        bg = "${colorBackground1}";
                    };

                    cand = {
                        fg = "${colorLightBlue}";
                    };

                    rest = {
                        fg = "${colorGray}";
                    };

                    desc = {
                        fg = "${colorLightOrange}";
                    };

                    separator = "  ";

                    separator_style = {
                        fg = "${colorBackground2}";
                    };
                };

                input = {
                    border = {
                        fg = "${colorLightWhite}";
                    };

                    title = { };

                    value = { };

                    selected = {
                        reversed = true;
                    };
                };

                help = {
                    on = {
                        fg = "${colorLightOrange}";
                    };

                    exec = {
                        fg = "${colorLightBlue}";
                    };

                    desc    = {
                        fg = "${colorGray}";
                    };

                    hovered = {
                        bg = "${colorBackground2}";
                        bold = true;
                    };

                    footer  = {
                        fg = "${colorBackground1}";
                        bg = "${colorGray}";
                    };
                };

                filetype = {
                    rules = [
                        { mime = "image/*"; fg = "${colorGreen}"; }
                        { mime = "video/*"; fg = "${colorRed}"; }
                        { mime = "audio/*"; fg = "${colorYellow}"; }
                        { mime = "application/zip"; fg = "${colorOrange}"; }
                        { mime = "application/gzip"; fg = "${colorOrange}"; }
                        { mime = "application/x-tar"; fg = "${colorOrange}"; }
                        { mime = "application/x-bzip"; fg = "${colorOrange}"; }
                        { mime = "application/x-bzip2"; fg = "${colorOrange}"; }
                        { mime = "application/x-7z-compressed"; fg = "${colorOrange}"; }
                        { mime = "application/x-rar"; fg = "${colorOrange}"; }
                        { url = "*"; fg = "${colorWhite}"; }
                        { url = "*/"; fg = "${colorBlue}"; }
                    ];
                };

                icon = {
                    append_exts = [
                        { name = "nsp"; text = "󰊖"; fg = "${colorPurple}"; }
                    ];
                };
            };

            # vfs = {
            #     services = {
            #         linode = {
            #             host = wgServerIp4Address;
            #             port = 22;
            #             type = "sftp";
            #             user = "root";
            #         };
            #     };
            # };
        };

        home.file.".config/yazi/plugins/parent-arrow.yazi/main.lua" = {
            executable = false;
            force = true;
            text = ''
                --- @sync entry
                local function entry(_, job)
                    local parent = cx.active.parent
                    if not parent then return end

                    local target = parent.files[parent.cursor + 1 + job.args[1]]
                    if target and target.cha.is_dir then
                        ya.emit("cd", { target.url })
                    end
                end

                return { entry = entry }
            '';
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
