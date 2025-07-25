{ config, pkgs, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        programs.neovim = {
            enable = true;
            viAlias = true;
            vimAlias = true;

            plugins = with pkgs.vimPlugins; [
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
                        require('lualine').setup({
                            options = { theme = 'gruvbox' }
                        })
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
                kitty-scrollback-nvim
            ];

            extraConfig = ''
                set number
                set wrap
                set nobackup
                set mouse=

                nnoremap <silent> ;s :noh<cr>
                nnoremap <silent> ;e :Explore<cr>

                autocmd InsertEnter * set cursorline
                autocmd InsertLeave * set nocursorline
            '';
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
