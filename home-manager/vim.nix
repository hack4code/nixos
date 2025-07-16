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
                                strings = true,
                                emphasis = true,
                                comments = true,
                                operators = false,
                                folds = true,
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
                            options = { theme = 'gruvbox' }
                        })
                    '';
                }
                telescope-nvim
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
                set wildignore=*/tmp/*,*.so,*.swp,*.zip,*.rar,*.7z
                set clipboard=unnamedplus
                set wildmenu
                set wildmode=full
                set wrap

                filetype plugin indent on
                syntax enable

                nnoremap <silent> [s :noh<cr>
                nnoremap <silent> [f :Telescope find_files<cr>
                nnoremap <silent> [b :Telescope buffers<cr>

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
