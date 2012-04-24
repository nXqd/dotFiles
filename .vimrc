" Original author: amix.dk
" Modified by nXqd
" Update:
"
" Sections:
"    -> General
"    -> Vim UI
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Command mode related
"    -> Moving around, tabs and buffers
"    -> Statusline
"    -> Brackets expanding
"    -> Shortcuts
"    -> Cope
"    -> Spell Checking
"
"    -> Plugins
"       -> NERDTree plugin
"       -> MRU
"       -> Omni complete functions
"       -> cTags plugins
"       -> Matchit                                          : extends % for various Languages
"       -> php-doc
"       -> pathogen                                         : Help manage runtime path
"    -> Languages
"       -> Python section
"       -> PHP section
"       -> JavaScript section
"       -> HTML section
"       -> CSS section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Run pathogen before hand
call pathogen#infect()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tips
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" YOU SHOULD USE VIM IN A RIGHT WAY
inoremap jk <esc>

" Remap leader
let g:mapleader = ","

" Map copy and paste with system clipboard register
map <C-y> "+y
vmap <C-y> "+y
map <C-p> "+p
vmap <C-p> "+p

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Unicode
set fileencoding=utf8
set fileencodings=ucs-bom,utf8,prc

"Default file types
set ffs=unix,dos,mac

" / instead of \ in windows
set shellslash

" Get running OS
let os = ""
if has("win32")
    let os="win"
  else
    if has("mac")
      let os = "mac"
    endif
endif

" Sets how many lines of history VIM has to remember
set history=200

" Enable filetype plugin
filetype plugin on
filetype indent on


" edit vimrc according to os
if os=="win"
    map <leader>e :e! D:\Dropbox\apps\gVimPortable\Data\settings\_vimrc
else
    map <leader>e :e! ~/.vimrc<cr>
endif

" quick save file
nmap <leader>w : w!<cr>

" autoreload vimrc config
if os=="win"
    au! bufwritepost _vimrc source D:\Dropbox\apps\gVimPortable\Data\settings\_vimrc
else
    au! bufwritepost .vimrc source ~/.vimrc
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set so=7                       " Set 7 lines to the curors - when moving vertical..
set wildmenu                   " Turn on WiLd menu
set ruler                      " Always show current position
set cmdheight=1                " The commandbar height
set hid                        " Change buffer - without saving
set nu                         " No line number

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Search
set ignorecase                 " Ignore case when searching
set smartcase
set hlsearch                   " Highlight search things
set incsearch                  " Make search act like search in modern browsers
set nolazyredraw
set magic                      " Set magic on, for regular expressions
set showmatch                  " Show matching bracets when text indicator is over them
set mat=2                      " How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Invisible character colors
highlight NonText guifg=#dddddd
highlight SpecialKey guifg=#dddddd

" Enable syntax hilight
syntax enable

" Set font according to system
if os=="win"
    set gfn=Consolas:h10
    set shell=cmd.exe
else
    set gfn=Consolas:h13
    set shell=/bin/zsh
endif

if has("gui_running")
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=l  "remove left-hand scroll bar
    set background=dark
    colorscheme solarized
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

"Persistent undo
try
    if os=="win"
        set undodir=C:\Windows\Temp
    else
        set undodir=~/.vim_runtime/undodir
    endif

    set undofile
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
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
	" Auto remove when saving
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" display indentation guides
set shiftwidth=2
set tabstop=2
set smarttab
set expandtab

set lbr
set tw=500

set ai     " Auto indent
set si     " Smart indent
set nowrap


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Replace selected text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map space to / (search) and c-space to ? (backgwards search)
map <space> /
map <c-space> ?
map <silent> <leader><cr> :noh<cr>

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


map <leader>bd :bdelete<cr>
map <leader>bc :Bclose<cr>

" Close all the buffers
map <leader>ba :1,300 bd!<cr>

" Use the arrows to something usefull
map <right> :bn<cr>
map <left> :bp<cr>

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>

command! Bclose call <SID>BufcloseCloseIt()
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

" Specify the behavior when switching between buffers
try
    set switchbuf=usetab
    set stal=2
catch
endtry


""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always show the statusline
set laststatus=2

" Format the statusline
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Brackets expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let preBracket="`"
if os=="mac"
  let preBracket="$"
endif

exe 'vnoremap' . preBracket . '1 <esc>`>a)<esc>`<i(<esc>'
exe 'vnoremap' . preBracket . '2 <esc>`>a]<esc>`<i[<esc>'
exe 'vnoremap' . preBracket . '3 <esc>`>a}<esc>`<i{<esc>'
exe 'vnoremap' . preBracket . '$ <esc>`>a"<esc>`<i"<esc>'
exe 'vnoremap' . preBracket . 'q <esc>`>a''<esc>`<i''<esc>'
exe 'vnoremap' . preBracket . 'e <esc>`>a"<esc>`<i"<esc>'

" Map auto complete of (, ", ', [
exe 'inoremap ' . preBracket . '1 ()<esc>i'
exe 'inoremap ' . preBracket . '2 []<esc>i'
exe 'inoremap ' . preBracket . '3 {}<esc>i'
exe 'inoremap ' . preBracket . '4 {<esc>o}<esc>O'
exe 'inoremap ' . preBracket . 'q ''''<esc>i'
exe 'inoremap ' . preBracket . 'e ""<esc>i'

" Map to enter ; end of line
inoremap <leader>; <esc>A;
nnoremap <leader>; A;<esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" map select all text to C-A
noremap <C-A> ggVG

" Remap saving
nmap <leader>w : w!<cr>

"Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

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

" => Pathogen
call pathogen#infect()

""""""""""""""""""""""""""""""
" => NERDTree plugin
""""""""""""""""""""""""""""""
map <leader>o :NERDTreeToggle<cr>

" MRU blugin
let MRU_Max_Entries = 400
map <leader>r :MRU<CR>

" YankRing
map <leader>y :YRShow<CR>=

" cTags plugins
if os=="win"
    let Tlist_Ctags_Cmd='d:\Dropbox\apps\gVimPortable\ctags\ctags.exe'
endif
map <leader>t :TlistToggle<cr>

" FuzzyFinder
nnoremap <leader>f :FufFile<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Languages
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => Omni complete functions
""""""""""""""""""""""""""""""
au FileType css set omnifunc=csscomplete#CompleteCSS
au FileType php set omnifunc=phpcomplete#CompletePHP
" @TODO: Need to write a function for this

""""""""""""""""""""""""""""""
" => PHP section
""""""""""""""""""""""""""""""
au FileType php inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
au FileType php nnoremap <C-P> :call PhpDocSingle()<CR>
au FileType php vnoremap <C-P> :call PhpDocRange()<CR>

""""""""""""""""""""""""""""""
" => HTML section
""""""""""""""""""""""""""""""
if os=="win"
    nmap <silent> <Leader>b :!start C:\Users\Administrator\AppData\Local\Google\Chrome SxS\Application\chrome.exe %
else
    nmap <silent> <Leader>b :!chromium-browser --user-data-dir=~/.chromium % &
endif

""""""""""""""""""""""""""""""
" => CSS section
""""""""""""""""""""""""""""""
"au BufRead,BufNewFile *.css set ft=css syntax=css3
