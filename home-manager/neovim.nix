{ config, pkgs, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.neovim = {
            enable = true;

            viAlias = false;
            vimAlias = true;

            waylandSupport = true;

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
                powerline-symbols
            ];

            plugins = with pkgs.vimPlugins; [
                # vim-airline-themes
                # {
                #     plugin = vim-airline;
                #     type = "viml";
                #     config = ''
                #         let g:airline_theme = 'base16_gruvbox_dark_hard'
                #         let g:airline_powerline_fonts = 1
                #     '';
                # }
                kitty-scrollback-nvim
                plenary-nvim
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
                    plugin = lualine-nvim;
                    type = "lua";
                    config = ''
                        require('lualine').setup {
                            options = {
                                icons_enabled = true,
                                theme = 'gruvbox',
                                component_separators = { left = '', right = ''},
                                -- section_separators = { left = '', right = ''},
                                -- component_separators = { left = '', right = '' },
                                section_separators = { left = '', right = '' },
                                disabled_filetypes = {
                                    statusline = {},
                                    winbar = {},
                                },
                                ignore_focus = {},
                                always_divide_middle = true,
                                always_show_tabline = true,
                                globalstatus = false,
                                refresh = {
                                    statusline = 1000,
                                    tabline = 1000,
                                    winbar = 1000,
                                    refresh_time = 16, -- ~60fps
                                    events = {
                                        'WinEnter',
                                        'BufEnter',
                                        'BufWritePost',
                                        'SessionLoadPost',
                                        'FileChangedShellPost',
                                        'VimResized',
                                        'Filetype',
                                        'CursorMoved',
                                        'CursorMovedI',
                                        'ModeChanged',
                                    },
                                }
                            },
                            sections = {
                                lualine_a = {'mode'},
                                lualine_b = {'branch', 'diff', 'diagnostics'},
                                lualine_c = {'filename'},
                                lualine_x = {'encoding', 'fileformat', 'filetype'},
                                lualine_y = {'progress'},
                                lualine_z = {'location'}
                            },
                            inactive_sections = {
                                lualine_a = {},
                                lualine_b = {},
                                lualine_c = {'filename'},
                                lualine_x = {'location'},
                                lualine_y = {},
                                lualine_z = {}
                            },
                            tabline = {},
                            winbar = {},
                            inactive_winbar = {},
                            extensions = {}
                        }
                    '';
                }
                {
                    plugin = yazi-nvim;
                    type = "lua";
                    config = ''
                        vim.keymap.set("n", "<leader>e", function()
                            require("yazi").yazi(
                                {
                                    yazi_floating_window_winblend = 0,
                                    floating_window_scaling_factor = 0.75,
                                    yazi_floating_window_border = "single"
                                }
                            )
                        end, { silent = true, desc = "yazi file browser" })
                    '';
                }
                {
                    plugin = nvim-web-devicons;
                    type = "lua";
                    config = ''
                        require('nvim-web-devicons').setup {
                            override = {
                                zsh = {
                                    icon = "",
                                    color = "#428850",
                                    cterm_color = "65",
                                    name = "Zsh"
                                }
                            };
                            color_icons = true;
                            default = true;
                            strict = true;
                            variant = "light|dark";
                            blend = 0;
                            override_by_filename = {
                                [".gitignore"] = {
                                    icon = "",
                                    color = "#f1502f",
                                    name = "Gitignore"
                                }
                            };
                            override_by_extension = {
                                ["log"] = {
                                    icon = "",
                                    color = "#81e043",
                                    name = "Log"
                                }
                            };
                            override_by_operating_system = {
                                ["apple"] = {
                                    icon = "",
                                    color = "#A2AAAD",
                                    cterm_color = "248",
                                    name = "Apple",
                                },
                            };
                        }
                    '';
                }
                {
                    plugin = telescope-nvim;
                    type = "lua";
                    config = ''
                        require("telescope").setup({
                            defaults = {
                                color_devicons = false,
                                prompt_prefix = "> ",
                                entry_prefix = "  ",
                                selection_caret = "◆ ",
                                layout_strategy = "flex",
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
                                    layout_strategy = "horizontal",
                                    vimgrep_arguments = {  "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--trim", },
                                    layout_config = {
                                        horizontal = {
                                            width = 0.98,
                                            previewer_width = 100,
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
                    plugin = telescope-fzf-native-nvim;
                    type = "lua";
                    config = ''
                        require('telescope').setup {
                            extensions = {
                                fzf = {
                                    fuzzy = true,
                                    override_generic_sorter = true,
                                    override_file_sorter = true,
                                    case_mode = "smart_case",
                                }
                            }
                        }
                        require('telescope').load_extension('fzf')
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
                            cmd = { 'clangd' },
                            filetypes = { 'h', 'c' },
                            root_markers = {
                                '.clangd',
                                '.git',
                            },
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

                        vim.lsp.config['pyright'] = {
                            settings = {
                                pyright = {
                                    disableOrganizeImports = true,
                                    openFilesOnly = true,
                                },

                                python = {
                                    analysis = {
                                        ignore = { '*' },
                                        typeCheckingMode = 'basic',
                                        diagnosticSeverityOverrides = {
                                            reportMissingImports = false,
                                            reportUnusedParameter = false,
                                        },
                                    },
                                },
                            },
                        }
                        vim.lsp.enable('pyright')

                        vim.lsp.config['ruff'] = {
                            init_options = {
                                settings = {
                                    configuration = {
                                        lint = {
                                            unfixable = { 'F401' },
                                            ['extend-select'] = { 'TID251' },
                                            ['flake8-tidy-imports'] = {
                                                ['banned-api'] = {
                                                    ['typing.TypedDict'] = {
                                                        msg = 'Use `typing_extensions.TypedDict` instead'
                                                    }
                                                }
                                            }
                                        },
                                        format = {
                                            ['quote-style'] = 'single'
                                        }
                                    }
                                }
                            }
                        }
                        vim.lsp.enable('ruff')

                        vim.lsp.config['bashls'] = {
                            cmd = { 'bash-language-server', 'start' },
                            filetypes = { 'bash', 'sh' }
                        }
                        vim.lsp.enable('bashls')

                        vim.lsp.enable('nixd')
                    '';
                }
            ];

            initLua = ''

                vim.g.mapleader = ";"

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
                -- vim.opt.guicursor="n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50"

                -- vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
                -- vim.keymap.set("n", "<leader>e", "<Cmd>32Lexplore<CR>", { silent = true, desc = "file explorer" })

                vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { silent = true, desc = "nohlsearch" })
                vim.keymap.set("n", "<leader>d", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { silent = true, desc = "disable diagnostics" })
                vim.keymap.set("n", "<leader>p", ':set paste<CR>"+p:set nopaste<CR>', { silent = true, desc = "paste from clipboard" })

                vim.cmd[[autocmd InsertEnter * set cursorline]]
                vim.cmd[[autocmd InsertLeave * set nocursorline]]

                -- trailing spaces
                vim.api.nvim_create_autocmd('FileType', {
                    group = vim.api.nvim_create_augroup('trim_whitespaces', { clear = true }),
                    desc = 'Trim trailing white spaces',
                    pattern = 'nix,python,bash,c,lua,javascript,make,markdown',
                    callback = function()
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            pattern = '<buffer>',
                            -- Trim trailing whitespaces
                            callback = function()
                                -- Save cursor position to restore later
                                local curpos = vim.api.nvim_win_get_cursor(0)
                                -- Search and replace trailing whitespaces
                                vim.cmd([[keeppatterns %s/\s\+$//e]])
                                vim.api.nvim_win_set_cursor(0, curpos)
                            end,
                        })
                    end,
                })
                --

                require("vim._core.ui2").enable({})
            '';
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
