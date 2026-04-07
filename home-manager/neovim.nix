{ config, pkgs, nixOSVersion, ... }:

let
    userName = config.userName;
    initLua = ''

        vim.opt.modeline = true
        vim.opt.wrap = true
        vim.opt.mouse = ""
        vim.opt.backup = false
        vim.g.mapleader = ";"
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.timeoutlen = 500
        vim.opt.updatetime = 4000
        vim.opt.termguicolors = true
        vim.opt.completeopt = "menu,menuone,noselect,popup"
        vim.opt.shortmess:append("c")
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
                                    vertical = {
                                        height = 0.5,
                                        width = 0.4,
                                    },
                                    horizontal = {
                                        height = 0.5,
                                        width = 0.4,
                                    }
                                }
                            },

                            pickers = {
                                buffers = {
                                    previewer = false,
                                    initial_mode = 'normal',
                                    layout_config = {
                                        vertical = {
                                            height = 0.5,
                                            width = 0.4,
                                        },

                                        horizontal = {
                                            height = 0.5,
                                            width = 0.4,
                                        }
                                    },
                                },

                                find_files = {
                                    theme = 'dropdown',
                                    previewer = false,
                                    find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
                                    layout_config = {
                                        vertical = {
                                            height = 0.8,
                                            width = 0.5,
                                        },
                                        horizontal = {
                                            height = 0.8,
                                            width = 0.5,
                                        }
                                    },
                                },

                                diagnostics = {
                                    previewer = false,
                                    initial_mode = 'normal',
                                    layout_config = {
                                        vertical = {
                                            height = 0.7,
                                            width = 0.8,
                                        },
                                        horizontal = {
                                            height = 0.7,
                                            width = 0.8,
                                        },
                                    },
                                },

                                live_grep = {
                                    previewer = true,
                                    layout_config = {
                                        vertical = {
                                            height = 0.8,
                                            width = 0.9,
                                        },
                                        horizontal = {
                                            height = 0.8,
                                            width = 0.9,
                                        },
                                    },
                                },
                            },
                        })

                        local builtin = require('telescope.builtin')
                        vim.keymap.set('n', ';f', builtin.find_files, { desc = 'Telescope find files' })
                        vim.keymap.set('n', ';b', builtin.buffers, { desc = 'Telescope buffers' })
                        vim.keymap.set('n', ';g', builtin.live_grep, { desc = 'Telescope live grep' })
                        vim.keymap.set('n', ';a', builtin.diagnostics, { desc = 'Telescope diagnostics' })
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

                let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
                let g:netrw_winsize = 30

                nnoremap <silent> ;s :noh<CR>
                nnoremap <silent> ;e :Lexplore<CR>
                nnoremap <silent> ;p :set paste<CR>"+p:set nopaste<CR>
                nnoremap <silent> ;d :lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>

                autocmd InsertEnter * set cursorline
                autocmd InsertLeave * set nocursorline
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
