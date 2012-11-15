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

" Disable vi compatibilty restrictions.
set nocompatible
" When creating a new line, set indentation same as previous line.
set autoindent
" Make i_backspace act as it does in most other programs.
set backspace=2
" Folding should be set manually, never automatically.
set foldmethod=manual
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
" Tabs are four characters wide.  Note that this is primarily useful for those
" who prefer tabs for indentation rather than spaces which act like tabs.  If
" you prefer indenting with spaces, look into 'softtabstop'.
set softtabstop=4
" (Auto)indents are four characters wide.
set shiftwidth=4
" Set a vertical ruler for line length
set colorcolumn=80
" The default color is hideous. Make it dark gray.
highlight ColorColumn ctermbg=8
" If run in a terminal, set the terminal title.
set title
" Enable wordwrap.
set textwidth=0 wrap linebreak
" Enable unicode characters.  This is needed for 'listchars' below.
set encoding=utf-8
" Disable capitalization check in spellcheck.
set spellcapcheck=""
" Enable syntax highlighting.
syntax on
" Do not show introduction message when starting Vim.
set shortmess+=I
" Enable filetype-specific plugins.
filetype plugin on
" Utilize filetype-specific automatic indentation.
filetype indent on

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
" Faster mapping for closing window / quitting
nnoremap <space>q :q<cr>
" Re-source the .vimrc
nnoremap <space>s :so $MYVIMRC<cr>
" Run :make
nnoremap <space>m :w<cr>:!clear<cr>:silent make %<cr>:cc<cr>
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

