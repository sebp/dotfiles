" Specify a directory for plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ntpeters/vim-better-whitespace'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" Initialize plugin system
call plug#end()

" Enable true color support
set termguicolors

" show a visual line under the cursor's current line
set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

" show line numbers
set nu

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" delay before writing swap file (for vim-gitgutter)
set updatetime=500

colorscheme dracula

" Python indentation
augroup python
autocmd BufNewFile,BufRead *.py
  \ set fileencoding="utf-8"
  \ set tabstop=4
  \ softtabstop=4
  \ shiftwidth=4
  \ textwidth=119
  \ expandtab
  \ autoindent
  \ fileformat=unix
augroup END

" ============================================================================
" Plugins settings and mappings
"
let g:airline_theme='bubblegum'

" enable highlighting and stripping whitespace on save
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

" vim-gitgitter: turn line number highlighting on
let g:gitgutter_highlight_linenrs = 1
let g:gitgutter_grep = 'rg'
