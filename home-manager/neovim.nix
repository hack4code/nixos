{ config, pkgs, nixOSVersion, ... }:

let
    userName = config.userName;
    initLua = ''

        vim.g.mapleader = ";"

        vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]

        vim.opt.modeline = true
        vim.opt.wrap = true
        vim.opt.mouse = ""
        vim.opt.backup = false
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.timeoutlen = 500
        vim.opt.updatetime = 4000
        vim.opt.termguicolors = true
        vim.opt.completeopt = "menu,popup"
        vim.opt.shortmess:append("c")
        vim.opt.icon = true
        vim.opt.iconstring = "%t"
        vim.opt.guicursor="n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50"

        vim.keymap.set("n", "<leader>s", "<Cmd>noh<CR>", { silent = true, desc = "nohlsearch" })
        vim.keymap.set("n", "<leader>e", "<Cmd>32Lexplore<CR>", { silent = true, desc = "file explorer" })
        vim.keymap.set("n", "<leader>d", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { silent = true, desc = "disable diagnostics" })
        vim.keymap.set("n", "<leader>p", ':set paste<CR>"+p:set nopaste<CR>', { silent = true, desc = "paste from clipboard" })

        vim.cmd[[autocmd InsertEnter * set cursorline]]
        vim.cmd[[autocmd InsertLeave * set nocursorline]]

        require("vim._core.ui2").enable({})
    '';
in
{
    home-manager.users.${userName} = {
        programs.neovim = {
            enable = true;

            viAlias = true;
            vimAlias = true;

            withNodeJs = false;
            withPython3 = true;
            withRuby = false;

            extraPackages = with pkgs; [
                lua-language-server
                clang-tools
                pyright
                fd
                bash-language-server
                shellcheck
                shfmt
                nixd
                ripgrep
            ];

            plugins = with pkgs.vimPlugins; [
                vim-airline-themes
                kitty-scrollback-nvim
                plenary-nvim
                nvim-treesitter
                {
                    plugin = vim-airline;
                    type = "viml";
                    config = ''
                        let g:airline_theme='base16_gruvbox_dark_hard'
                    '';
                }
                {
                    plugin = gruvbox-nvim;
                    type = "lua";
                    config = ''
                        require('gruvbox').setup({
                            terminal_colors = true,
                            undercurl = true,
                            underline = true,
                            bold = true,
                            italic = {
                                emphasis = false,
                                comments = true,
                                folds = true,
                                strings = false,
                                operators = false,
                            },
                            strikethrough = true,
                            invert_selection = false,
                            invert_signs = false,
                            invert_tabline = false,
                            inverse = true,
                            contrast = 'hard',
                            palette_overrides = {},
                            overrides = {},
                            dim_inactive = false,
                            transparent_mode = false,
                        })
                        vim.cmd('colorscheme gruvbox')
                    '';
                }
                {
                    plugin = telescope-nvim;
                    type = "lua";
                    config = ''
                        require('telescope').setup({
                            defaults = {
                                layout_strategy = 'flex',
                                layout_config = {
                                    flex = {
                                        height = 0.5,
                                        width = 0.4,
                                    },
                                },
                                mappings = {
                                    i = {
                                        ["<C-u>"] = false,
                                    },
                                },
                            },

                            pickers = {
                                find_files = {
                                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                                },

                                buffers = {
                                    theme = "dropdown",
                                    previewer = false,
                                    -- initial_mode = "normal",
                                    layout_config = {
                                        flex = {
                                            height = 0.5,
                                            width = 0.4,
                                        },
                                    },
                                },

                                find_files = {
                                    theme = "dropdown",
                                    previewer = false,
                                    find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
                                    layout_config = {
                                        flex = {
                                            height = 0.8,
                                            width = 0.5,
                                        },
                                    },
                                },

                                diagnostics = {
                                    previewer = false,
                                    -- initial_mode = 'normal',
                                    layout_config = {
                                        flex = {
                                            height = 0.7,
                                            width = 0.8,
                                        },
                                    },
                                },

                                live_grep = {
                                    previewer = true,
                                    layout_config = {
                                        flex = {
                                            height = 0.8,
                                            width = 0.96,
                                        },
                                    },
                                },
                            },
                        })

                        local builtin = require('telescope.builtin')
                        vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
                        vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
                        vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })
                        vim.keymap.set('n', '<leader>a', builtin.diagnostics, { desc = 'Telescope diagnostics' })
                    '';
                }
                {
                    plugin = telescope-file-browser-nvim;
                    type = "lua";
                    config = ''
                        local fb_actions = require "telescope".extensions.file_browser.actions
                        require("telescope").setup {
                            extensions = {
                                file_browser = {
                                    theme = 'dropdown',
                                    previewer = false,
                                    hijack_netrw = true,
                                    quiet = true,
                                    hide_parent_dir = true,
                                    display_stat = { date = false, size = true, mode = true, },
                                    dir_icon = "",
                                    use_fd = true,
                                    git_status = true,
                                    -- initial_mode = "normal",
                                    mappings = {
                                        i = {
                                            ["<C-h>"] = fb_actions.goto_parent_dir,
                                            ["<C-l>"] = fb_actions.open_dir,
                                            ["<C-g>"] = fb_actions.toggle_hidden,
                                            ["<C-o>"] = false,
                                        },
                                        n = {
                                            ["h"] = fb_actions.goto_parent_dir,
                                            ["l"] = fb_actions.open_dir,
                                            ["g"] = fb_actions.toggle_hidden,
                                            ["o"] = false,
                                        },
                                    },
                                    layout_config = {
                                        flex = {
                                            height = 0.8,
                                            width = 0.5,
                                        }
                                    },
                                    wrap_results = true,
                                    scroll_strategy = "cycle",
                                },
                            },
                        }
                        require("telescope").load_extension "file_browser"
                        vim.keymap.set("n", "<leader>o", "<Cmd>Telescope file_browser<CR>", { desc = 'Telescope file browser' })
                    '';
                }
                {
                    plugin = nvim-lspconfig;
                    type = "lua";
                    config = ''
                        vim.diagnostic.config({
                            virtual_text = true,
                            signs = {
                                text = {
                                    [vim.diagnostic.severity.ERROR] = '☠',
                                    [vim.diagnostic.severity.WARN] = '⚠',
                                    [vim.diagnostic.severity.HINT] = "",
                                    [vim.diagnostic.severity.INFO] = "",
                                },
                            },
                        })

                        vim.lsp.config['clangd'] = {
                            cmd = {
                                'clangd',
                                '--clang-tidy',
                                '--background-index',
                                '--offset-encoding=utf-8',
                            },
                            root_markers = {
                                '.clangd',
                                'compile_commands.json',
                                '.git',
                            },
                            filetypes = { 'c', 'cpp' },
                        }
                        vim.lsp.enable('clangd')

                        vim.lsp.config['luals'] = {
                            cmd = { 'lua-language-server' },
                            filetypes = { 'lua' },
                            root_markers = {
                                { '.luarc.json', '.luarc.jsonc' },
                                '.git'
                            },
                            settings = {
                                Lua = {
                                    runtime = {
                                        version = 'LuaJIT',
                                    }
                                }
                            }
                        }
                        vim.lsp.enable('luals')

                        vim.lsp.config('pyright', {
                            settings = {
                                pyright = {
                                    disableOrganizeImports = true,
                                    openFilesOnly = true,
                                },

                                python = {
                                    analysis = {
                                        typeCheckingMode = 'basic',
                                        diagnosticSeverityOverrides = {
                                            reportMissingImports = false,
                                            reportUnusedParameter = false,
                                        },
                                    },
                                },
                            },
                        })
                        vim.lsp.enable('pyright')

                        vim.lsp.config['bashls'] = {
                            cmd = { 'bash-language-server', 'start' },
                            filetypes = { 'bash', 'sh' }
                        }
                        vim.lsp.enable('bashls')

                        vim.lsp.enable('nixd')
                    '';
                }
            ];

            extraConfig = ''
            '';
        } // (if nixOSVersion == "25.11" then
            {
               extraLuaConfig = initLua;
            }
        else
            {
                initLua = initLua;
            }
        );
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
