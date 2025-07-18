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
                        require("gruvbox").setup({
                            terminal_colors = true,
                            undercurl = true,
                            underline = true,
                            bold = true,
                            italic = {
                                emphasis = true,
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
                            contrast = "hard",
                            palette_overrides = {},
                            overrides = {},
                            dim_inactive = false,
                            transparent_mode = false,
                        })
                        vim.cmd("colorscheme gruvbox")
                    '';
                }
                {
                    plugin = lualine-nvim;
                    type = "lua";
                    config = ''
                        require('lualine').setup({
                            options = { theme = 'gruvbox' },
                            extensions = { 'quickfix' },
                        })
                    '';
                }
                {
                    plugin = telescope-nvim;
                    type = "lua";
                    config = ''
                        require('telescope').setup({
                            pickers = {
                                buffers = {
                                    previewer = false,
                                },

                                find_files = {
                                    previewer = false,
                                },

                                diagnostics = {
                                    previewer = false,
                                },
                            }
                        })
                    '';
                }
                {
                    plugin = nvim-lspconfig;
                    type = "lua";
                    config = ''
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

                        vim.lsp.config('ruff', {
                            init_options = {
                                settings = {
                                    fixAll = true,
                                    organizeImports = true,
                                    showSyntaxErrors = true,
                                    logLevel = 'warn',
                                    logFile = '~/.local/state/nvim/ruff.log',

                                    lint = {
                                        enable = true,
                                        select = { 'E', 'F' },
                                        extendSelect = { 'W' },
                                        ignore = { },
                                    },

                                    configuration = {
                                        lint = {
                                            unfixable = { 'F401' },
                                        },
                                        format = {
                                            [ 'quote-style' ] = 'single'
                                       }
                                    }
                                }
                            }
                        })
                        vim.lsp.enable('ruff')
                        vim.lsp.enable('pyright')
                    '';
                }
                kitty-scrollback-nvim
            ];

            extraConfig = ''
                set termguicolors
                set background=dark
                set number
                set magic
                set hlsearch
                set incsearch
                set encoding=utf-8
                set fileformat=unix
                set clipboard=unnamedplus
                set wildmenu
                set wildmode=full
                set wrap
                set nobackup

                filetype plugin indent on
                syntax enable

                nnoremap <silent> [s :noh<cr>
                nnoremap <silent> [e :Telescope buffers<cr>
                nnoremap <silent> [f :Telescope find_files<cr>
                nnoremap <silent> [d :Telescope diagnostics<cr>
                nnoremap <silent> [o :lua vim.diagnostic.open_float()<cr>

                autocmd InsertEnter * set cursorline
                autocmd InsertLeave * set nocursorline


                " vim: set ts=4 sw=4 sts=4 ft=vim et:
            '';
        };

        home.enableNixpkgsReleaseCheck = false;
        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
