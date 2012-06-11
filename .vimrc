" Original author: amix.dk
" Modified by nXqd
" Update:
"
" Sections:
"    -> General
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Command mode related
"    -> Moving around, tabs and buffers
"    -> Statusline
"    -> Shortcuts
"    -> Cope
"    -> Functions
"    -> Plugins
"    -> Languages
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Run pathogen before hand
call pathogen#infect()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap leader
let g:mapleader = ","

" Speed up vim
set lazyredraw
set synmaxcol=128
" We are not accient
set nocompatible
" No sound on errors
set noerrorbells
set novisualbell
" File default format
set fileencoding=utf8 nobomb
set fileformats=unix,dos,mac
" Slash
set shellslash                    " Use / instead of \ in Windows
set wildmenu
set wildignore
set hidden                        " Change buffer - without saving
set relativenumber
set cursorline
" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
" Enable filetype plugin
filetype plugin on
filetype indent on
" Search
set ignorecase                 " Ignore case when searching
set smartcase
set hlsearch                   " Highlight search things
set incsearch                  " Make search act like search in modern browsers
set magic                      " Set magic on, for regular expressions
set showmatch                  " Show matching bracets when text indicator is over them
set history=50
" display indentation guides
set shiftwidth=2
set tabstop=2
set smarttab
set expandtab
set linebreak
set autoindent
set smartindent
" keep your code clean and easy to read
set textwidth=120
set wrap
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile
" Get running OS
let os=GetRunningOS()
" Undo
set undofile
if os=="win"
  set undodir=C:\Windows\Temp
else
  set undodir=~/.vim_runtime/undodir
endif
" edit vimrc according to os
if os=="win"
    map <leader>rc :e! D:\Dropbox\apps\gVimPortable\Data\settings\_vimrc<CR>
else
    map <leader>rc :e! ~/.vimrc<CR>
endif
" autoreload vimrc config
if os=="win"
    au! bufwritepost _vimrc source D:\Dropbox\apps\gVimPortable\Data\settings\_vimrc
else
    au! bufwritepost .vimrc source ~/.vimrc
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable syntax highlight
syntax enable
" Set font according to system
if os=="win"
    set shell=cmd.exe
else
    set shell=/bin/zsh
endif
" Gvim
if has("gui_running")
    set guioptions-=mTrl  "remove menu bar
    set guioptions-=T     "remove tool bar
    set guioptions-=r     "remove left scroll
    set guioptions-=l     "remove right scroll
    set background=dark
    set guifont=Consolas:h10
    colorscheme solarized
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" Auto remove when saving
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>

" Replace selected text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map space to / (search) and c-space to ? (backgwards search)
map <space> /
map <c-space> ?
map <silent> <leader><cr> :noh<cr>
" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
" buffer delete
map <leader>bd :bdelete<cr>
" buffer close
map <leader>bc :Bclose<cr>
" close all buffers
map <leader>ba :1,300 bd!<cr>
" Use the arrows to something usefull
map <right> :bn<cr>
map <left> :bp<cr>
" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>

command! Bclose call <SID>BufcloseCloseIt()
" Specify the behavior when switching between buffers
set switchbuf=usetab
set stal=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Statusline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
set statusline=%<%f\    " Filename
set statusline+=%w%h%m%r " Options
set statusline+=%{fugitive#statusline()} "  Git Hotness
set statusline+=\ [%{&ff}/%Y]            " filetype
set statusline+=\ [%{getcwd()}]          " current dir
set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" quick save file
nmap <leader>w : w!<cr>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>
" quick edit file
nmap <leader>e :e
" map select all text to C-A
noremap <C-A> ggVG
" Map copy and paste with system clipboard register
map <C-y> "+y
vmap <C-y> "+y
map <C-p> "+p
vmap <C-p> "+p
"Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Brackets expanding
let bracketPrefix="`"
if os=="mac"
  let bracketPrefix="$"
endif

exe 'vnoremap' . bracketPrefix . '1 <esc>`>a)<esc>`<i(<esc>'
exe 'vnoremap' . bracketPrefix . '2 <esc>`>a]<esc>`<i[<esc>'
exe 'vnoremap' . bracketPrefix . '3 <esc>`>a}<esc>`<i{<esc>'
exe 'vnoremap' . bracketPrefix . '$ <esc>`>a"<esc>`<i"<esc>'
exe 'vnoremap' . bracketPrefix . 'q <esc>`>a''<esc>`<i''<esc>'
exe 'vnoremap' . bracketPrefix . 'e <esc>`>a"<esc>`<i"<esc>'
exe 'inoremap' . bracketPrefix . '1 ()<esc>i'
exe 'inoremap' . bracketPrefix . '2 []<esc>i'
exe 'inoremap' . bracketPrefix . '3 {}<esc>i'
exe 'inoremap' . bracketPrefix . '4 {<esc>o}<esc>O'
exe 'inoremap' . bracketPrefix . 'q ''''<esc>i'
exe 'inoremap' . bracketPrefix . 'e ""<esc>i'

" Map to enter ; end of line
inoremap <leader>; <esc>A;
nnoremap <leader>; A;<esc>
" open file in same directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what cope is. It's super useful!
" map <leader>cc :botright cope<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove trailing spaces
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" from an idea by michael naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"Get current running OS - Vim terminal
function! GetRunningOS()
  if has("win32")
    return "win"
  endif
  if has("unix")
    if system('uname')=~'Darwin'
      return "mac"
    else
      return "unix"
    endif
  endif
endfunction
"Buffer close
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree plugin
map <leader>o :NERDTreeToggle<cr>
let g:NERDTreeDirArrows=0

" MRU blugin
"let MRU_Max_Entries = 400
"map <leader>r :MRU<CR>

" YankRing
map <leader>y :YRShow<CR>=

" cTags plugins
if os=="win"
    let Tlist_Ctags_Cmd='d:\Dropbox\apps\gVimPortable\ctags\ctags.exe'
endif
map <leader>t :TlistToggle<cr>

" gist
let g:gist_clip_command = 'xclip -selection clipboard'

" ctrlP
let g:ctrlp_map = '<leader>f'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Languages
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C/AL
au FileType cal set filetype=cal.vb
" PHP
autocmd FileType php map <leader>r !php %
