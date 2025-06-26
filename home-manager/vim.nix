{ config, pkgs, ... }:

let
    userName = config.userName;
    version = config.nixosVersion;
in
{
    home-manager.users.${userName} = {
        programs.vim = {
            enable = true;

            defaultEditor = true;

            plugins = with pkgs.vimPlugins; [
                ale
                bufexplorer
                gruvbox
                vim-airline
                vim-airline-themes
                vim-python-pep8-indent
                vim-wayland-clipboard
            ];

            settings = {
                background = "dark";

                number = true;
                relativenumber = false;

                hidden = true;

                history = 4096;

                mouse = "n";
                mousefocus = false;
                mousehide = true;
            };

            extraConfig = ''
                set nocompatible
                set magic
                set hlsearch
                set incsearch
                set smoothscroll
                set smartindent
                set autoindent
                set softtabstop=0
                set encoding=utf-8
                set fileformat=unix
                set wildignore=*/tmp/*,*.so,*.swp,*.zip,*.rar,*.7z
                set clipboard=unnamed,unnamedplus
                set wildmenu
                set wildmode=full
                set statusline+=%*
                set wrap

                """
                filetype plugin indent on
                syntax enable

                """ keymap
                nnoremap <silent> [f :Explore<CR>
                nnoremap <silent> [e :BufExplorer<CR>
                nnoremap <silent> [s :noh<CR>
                nnoremap <silent> [c :ccl<CR>

                """ cursor
                let &t_SI = "\<Esc>[6 q"
                let &t_SR = "\<Esc>[4 q"
                let &t_EI = "\<Esc>[2 q"
                :autocmd InsertEnter * set cursorline
                :autocmd InsertLeave * set nocursorline

                """ colorscheme
                let g:gruvbox_italic=1
                colorscheme gruvbox

                """ airline
                let g:airline_theme="gruvbox"

                """ netrw
                let g:netrw_dirhistmax=0
                let g:netrw_home=$XDG_CACHE_HOME.'/vim'

                """ vim-ale
                let g:airline#extensions#ale#enabled = 1
                let g:ale_linters_explicit = 1
                let g:ale_lint_on_enter = 0
                let g:ale_set_loclist = 0
                let g:ale_set_quickfix = 1
                let g:ale_open_list = 1
                let g:ale_virtualtext_cursor = 'disabled'
                let g:ale_lint_on_text_changed = 'never'
                let g:ale_lint_on_insert_leave = 0
                let g:ale_sign_error = '>>'
                let g:ale_sign_warning = '--'
                let g:ale_echo_msg_error_str = 'E'
                let g:ale_echo_msg_warning_str = 'W'
                let g:ale_echo_msg_format = '%s'

                let g:ale_linters = {
                            \   'python': ['flake8', 'pyrefly'] ,
                            \   'javascript': ['eslint'],
                            \   'c': ['cpplint'],
                            \   'lua': ['luacheck'],
                            \}


                " vim: set ts=8 sw=8 sts=8 ft=vim et:
            '';
        };

        home.stateVersion  = "${version}";
    };
}


# vim: ts =4 sw=4 sts=4 ft=nix et:
