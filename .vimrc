" ==============================================================================
" = embolalia's_.vimrc                                                         =
" ==============================================================================
"
" With great thanks and credit to Paradigm and his wonderfully crafted .vimrc
" https://github.com/paradigm/dotfiles/blob/master/.zshrc
" ==============================================================================
" = general_settings                                                           =
" ==============================================================================
"
" These are general shell settings that don't fit well into any of the
" catagories used below.  Order may matter for some of these.

" Enable Pathogen
execute pathogen#infect()

" Disable vi compatibilty restrictions.
set nocompatible
" When creating a new line, set indentation same as previous line.
set autoindent
" Try to use filetype indentation
if has("autocmd")
    filetype plugin indent on
endif
" Use 4-space indents
set shiftwidth=4
set tabstop=4
" Run DetectIndent immediately
autocmd BufReadPost * :DetectIndent
" Prefer 4 spaces if we can't tell what it is
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 4
" Turn on spellcheck for tex and ReST
au Filetype tex set spell
au Filetype rst set spell
" Make i_backspace act as it does in most other programs.
set backspace=2
" We can probably be safe folding by indent.
set foldmethod=indent
" Do not fold anything by default.
set foldlevel=999
" Allow modified/unsaved buffers in the background.
set hidden
" Highlight search results.
set hlsearch
" When sourcing this file, do not immediately turn on highlighting.
nohlsearch
" Searches are case-sensitive.
set ignorecase
" Searches are not case sensitive if an uppercase character appears within.
" them.
set smartcase
" Print line numbers on the left.
set number
" Always show cursor position in statusline.
set ruler
" Set a vertical ruler for line length
set colorcolumn=80
" The default color is hideous. Make it dark gray.
highlight ColorColumn ctermbg=8
" If run in a terminal, set the terminal title.
" set title
" Enable wordwrap.
set textwidth=0 wrap linebreak
" Enable unicode characters.  This is needed for 'listchars' below.
set encoding=utf-8
" Display special characters for certain whitespace situations.
set list
set listchars=tab:>·,trail:·,extends:…,precedes:…,nbsp:&
" Disable capitalization check in spellcheck.
set spellcapcheck=""
" Enable syntax highlighting.
syntax on
" Do not show introduction message when starting Vim.
set shortmess+=I
" Enable filetype-specific plugins.
filetype plugin on

" ==============================================================================
" = mappings                                                                   =
" ==============================================================================

" ------------------------------------------------------------------------------
" - general_(mappings)                                                         -
" ------------------------------------------------------------------------------

" Disable <f1>'s default help functionality.
nnoremap <f1> <esc>
inoremap <f1> <esc>
" Clear search highlighting and messages at bottom when redrawing
nnoremap <silent> <c-l> :nohlsearch<cr><c-l>
" Faster mapping for saving
nnoremap <space>w :w<cr>
nnoremap <leader>w :w<cr>
" Faster mapping for closing window / quitting
nnoremap <space>q :q<cr>
nnoremap <leader>q :q<cr>
" System clipboard copy/paste
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P
" Re-source the .vimrc
nnoremap <space>s :so $MYVIMRC<cr>
nnoremap <leader>s :so $MYVIMRC<cr>
" Run :make
nnoremap <space>m :w<cr>:!clear<cr>:silent make %<cr>:cc<cr>
nnoremap <space>. :cn<cr>
nnoremap <leader>. :cn<cr>
nnoremap <space>, :cp<cr>
nnoremap <leader>, :cp<cr>
" Move by 'display lines' rather than 'logical lines'.
nnoremap <silent> j gj
xnoremap <silent> j gj
nnoremap <silent> k gk
xnoremap <silent> k gk
" Ensure 'logical line' movement remains accessible.
nnoremap <silent> gj j
xnoremap <silent> gj j
nnoremap <silent> gk k
xnoremap <silent> gk k
" Find next/previous search item which is not visible in the window.
" Note that 'scrolloff' probably breaks this.
nnoremap <space>n L$nzt
nnoremap <space>N H$Nzb

map ; :
noremap ;; ;

filetype plugin indent on
nnoremap <leader>m :PymodeLint<return>

let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_regenerate_on_write = 0
augroup python
    autocmd!
    " 'Compile' with pep8.
    autocmd Filetype python setlocal makeprg=~/env3/bin/flake8
    autocmd Filetype python setlocal errorformat=%f:%l:%c:%m
    " Execute.
    autocmd Filetype python nnoremap <buffer> <space>r :cd %:p:h<cr>:!python3 %<cr>
augroup END
