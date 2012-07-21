" Original author: amix.dk
" Modified by nXqd
" Construct
"    -> General
"    -> UI
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
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove empty line at the end of page
function! <SID>TrimEndLines()
  let save_cursor = getpos(".")
  :silent! %s#\($\n\s*\)\+\%$##
  call setpos('.', save_cursor)
endfunction
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
" Get running OS
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let os=GetRunningOS()
" Remap leader
let g:mapleader = ","
" work with unicode by default
set encoding=utf-8
setglobal fileencoding=utf-8
" Don’t add empty newlines at the end of files
set binary
set noeol
" Scroll 3 lines
set scrolloff=3
" We are not accient
set nocompatible
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Speed up vim
set lazyredraw
set synmaxcol=200
" Slash
set shellslash                    " Use / instead of \ in Windows
set wildmenu
set wildignorecase
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.rar,*.tar.*
set hidden                        " Change buffer - without saving
" Move to exact place you want
set cursorline
set relativenumber
" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
" Mouse in all mode
set mouse=a
" Enable filetype plugin
filetype plugin on
filetype indent on
" Search
set ignorecase
set smartcase
set hlsearch
set incsearch
" magic for regex search
set magic
" Number of commands store
set history=50
" tab settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set expandtab
" indentation
set autoindent
set smartindent
" keep your code clean and easy to read
set linebreak
set textwidth=120
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile
" enable syntax highlighting
syntax enable
" Specify the behavior when switching between buffers
set switchbuf=usetab
set stal=2
" Undo
set undofile
if os=="win"
  set undodir=C:\Windows\Temp
  map <leader>rc :e! D:\Dropbox\apps\gVimPortable\Data\settings\_vimrc<CR>
  au! bufwritepost _vimrc source D:\Dropbox\apps\gVimPortable\Data\settings\_vimrc
  set shell=powershell.exe
else
  set undodir=~/.vim/undodir
  map <leader>rc :e! ~/.vimrc<CR>
  au! bufwritepost .vimrc source ~/.vimrc
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Gvim
if has("gui_running")
  set guioptions-=m     "remove menu bar
  set guioptions-=T     "remove tool bar
  set guioptions-=r     "remove left scroll
  set guioptions-=l     "remove right scroll
  set guifont=Consolas:h11
  colorscheme solarized
  set background=dark
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto remove when saving
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre * :call <SID>TrimEndLines()

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
map <leader>a :Ack<space>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <space> /
map <silent><leader><cr> :noh<cr>
" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Statusline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" W to save as root
nmap <leader>w :w!<cr>
cnoremap W w !sudo tee % > /dev/null
" Map copy and paste with system clipboard register
map <C-y> "+y
vmap <C-y> "+y
map <C-p> "+p
vmap <C-p> "+p
" Brackets expanding
let bracketPrefix="`"
exe 'vnoremap' . bracketPrefix . '1 <esc>`>a)<esc>`<i(<esc>'
exe 'vnoremap' . bracketPrefix . '2 <esc>`>a]<esc>`<i[<esc>'
exe 'vnoremap' . bracketPrefix . '3 <esc>`>a}<esc>`<i{<esc>'
exe 'vnoremap' . bracketPrefix . '$ <esc>`>a"<esc>`<i"<esc>'
exe 'vnoremap' . bracketPrefix . 'q <esc>`>a"<esc>`<i"<esc>'
exe 'vnoremap' . bracketPrefix . 'e <esc>`>a''<esc>`<i''<esc>'
exe 'inoremap' . bracketPrefix . '1 ()<esc>i'
exe 'inoremap' . bracketPrefix . '2 []<esc>i'
exe 'inoremap' . bracketPrefix . '3 {}<esc>i'
exe 'inoremap' . bracketPrefix . '4 {<esc>o}<esc>O'
exe 'inoremap' . bracketPrefix . 'q ""<esc>i'
exe 'inoremap' . bracketPrefix . 'e ''''<esc>i'
" Map to enter ; end of line
inoremap <leader>; <esc>A;
nnoremap <leader>; A;<esc>
" open file in same directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what cope is. It's super useful!
map <leader>co :botright cope<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>
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

" YankRing
map <leader>y :YRShow<CR>=

" cTags plugins
if os=="win"
  let Tlist_Ctags_Cmd='d:\Dropbox\apps\gVimPortable\ctags\ctags.exe'
endif
map <leader>t :TlistToggle<cr>

" ctrlP
let g:ctrlp_map = '<leader>f'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Languages
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C/AL
au FileType cal set filetype=cal.vb