"==========================================
" ProjectLink: https://github.com/nandalopes/vim-for-server
" Author:  wklken,nandalopes
" Version: 0.3
" Email: nandalopes@gmail.com
" Donation: http://www.wklken.me/pages/donation.html
" ReadMe: README.md
" Last_modify: 2021-07-21
" Desc: simple vim config for server, without any plugins.
"==========================================

set nocompatible                " don't bother with vi compatibility

" leader
" let mapleader = ','
let g:mapleader = ','

" syntax
syntax on

" history : how many lines of history VIM has to remember
set history=2000

" filetype
filetype on
" Enable filetype plugins
filetype plugin on
filetype indent on


" base
set autoread                    " reload files when changed on disk, i.e. via `git checkout`
set shortmess=atI
set path=.,**,                  " Useful search path to find and friends

set magic                       " For regular expressions turn magic on
set title                       " change the terminal's title
set nobackup                    " do not keep a backup file

set novisualbell                " turn off visual bell
set noerrorbells                " don't beep
set visualbell                  " turn off error beep/flash
set t_vb=
set timeoutlen=500


" show location
" set cursorcolumn              " highlight cursor column
set cursorline                  " highlight cursor line


" movement
set scrolloff=5                 " keep 5 lines when scrolling
set sidescrolloff=3             " keep 3 columns when side scrolling


" show
set ruler                       " show the current row and column
set number                      " show line numbers
set relativenumber              " show line relative numbers
set nowrap
set showcmd                     " display incomplete commands
set showmode                    " display current modes
set showmatch                   " jump to matches when entering parentheses
" set matchtime=2               " tenths of a second to show the matching parenthesis


" search
set hlsearch                    " highlight searches
set incsearch                   " do incremental searching, search as you type
set ignorecase                  " ignore case when searching
set smartcase                   " no ignorecase if Uppercase char present


" tab
set expandtab                   " expand tabs to spaces
set smarttab
set shiftround

" indent
set autoindent smartindent
set shiftwidth=4
set tabstop=4
set softtabstop=4               " insert mode tab and backspace use 4 spaces

" NOT SUPPORT
" fold
set foldenable
set foldmethod=indent
set foldlevel=99
let g:FoldMethod = 0
map <Leader>zz :call ToggleFold()<cr>
function! ToggleFold()
    if g:FoldMethod == 0
        exe 'normal! zM'
        let g:FoldMethod = 1
    else
        exe 'normal! zR'
        let g:FoldMethod = 0
    endif
endfunction

" encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set termencoding=utf-8
set fileformats=unix,dos,mac
set formatoptions+=m            " break at a multibyte character above 255
set formatoptions+=B            " when joining lines, don't insert a space between two multibyte chars
set formatoptions+=j            " remove a comment leader when joining lines

" select & complete
set selection=inclusive
set selectmode=mouse,key

set completeopt=longest,menu
set wildmenu                    " show a navigable menu for tab completion"
set wildmode=longest,list,full
set wildignore=*.o,*~,*.pyc,*.class

" others
set backspace=indent,eol,start  " make that backspace key work the way it should
set whichwrap+=<,>,h,l          " allow <Left>, <Right>, h and l move to the next line

" if this not work, make sure .viminfo is writable for you
augroup vimrc-LastPos
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | exe "normal! g'\"" | endif
augroup end

" NOT SUPPORT
" Enable basic mouse behavior such as resizing buffers.
set mouse+=a

" =============== Turn Off Swap Files ===============

set noswapfile
set nobackup
set nowritebackup


" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
    if !isdirectory(expand('~').'/.cache/vim/backups')
        silent !mkdir --parents ~/.cache/vim/backups > /dev/null 2>&1
    endif
    set undodir=~/.cache/vim/backups
    set undofile
endif


" ============== theme and status line ==============

" theme
set background=dark
colorscheme evening

if has('termguicolors')
    set termguicolors
endif

" set mark column color
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

" status line
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-10.(%l,%c%V%)\ %P\ 
set laststatus=2                " Always show the status line - use 2 lines for the status bar


" =============== specific file type ================

augroup filetypeplugin
    autocmd FileType python set tabstop=4 shiftwidth=4 expandtab autoindent
    autocmd FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2 expandtab autoindent
augroup end
augroup filetypedetect
    autocmd BufRead,BufNew *.md,*.mkd,*.markdown  set filetype=markdown.mkd
augroup end

augroup filetypeplugin
    autocmd BufNewFile *.sh,*.py exec ':call AutoSetFileHead()'
augroup end
function! AutoSetFileHead()
    " .sh
    if &filetype ==? 'sh'
        call setline(1, '\#!/bin/bash')
    endif

    " python
    if &filetype ==? 'python'
        call setline(1, '\#!/usr/bin/env python')
        call append(1, '\# encoding: utf-8')
    endif

    normal! G
    normal! o
    normal! o
endfunction

augroup filetypeplugin
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl \
    autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
augroup end
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line('.')
    let c = col('.')
    " Do the business:
    %snomagic/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" ===================== key map =====================

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

nnoremap <F2> :set number! number?<CR>
nnoremap <F3> :set list! list?<CR>
nnoremap <F4> :set wrap! wrap?<CR>
set pastetoggle=<F5>            " when in insert mode, press <F5> to go to
                                " paste mode, where you can paste mass data
                                " that won't be autoindented
augroup vimrc-InsertLeave
    autocmd!
    autocmd InsertLeave * set nopaste
augroup end
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>

" kj replace Esc
inoremap kj <Esc>

" Quickly close the current window
nnoremap <Leader>q :q<CR>
" Quickly save the current file
nnoremap <Leader>w :w<CR>

" select all
map <Leader>sa ggVG"

" remap U to <C-r> for easier redo
nnoremap U <C-r>

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '

" switch # *
" nnoremap # *
" nnoremap * #

" Keep search pattern at the center of the screen.
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" remove highlight
noremap <silent><Leader>/ :nohls<CR>

" Reselect visual block after indent/outdent.
" After adjusting the indentation, it will be automatically selected,
" which is convenient for re-operation
vnoremap < <gv
vnoremap > >gv

" y$ -> Y Make Y behave like other capitals
map Y y$

" Map ; to : and save a million keystrokes
" ex mode commands made easy, quick access to command line
nnoremap ; :

" Shift+H goto head of the line, Shift+L goto end of the line
nnoremap H ^
nnoremap L $

" save
cmap w!! w !sudo tee >/dev/null %

" command mode, ctrl-a to head， ctrl-e to tail
cnoremap <C-j> <t_kd>
cnoremap <C-k> <t_ku>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
