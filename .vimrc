set nocompatible

if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif

" save swap files in a custom location
set directory=~/.vim/swap

set tabstop=2
set shiftwidth=2
set expandtab

set title

" don't show intro message on start
set shortmess+=I

filetype plugin on
filetype plugin indent on

set autoread

augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

syntax on
set bg=dark
colorscheme gruvbox
set cursorline
set number

" I don't use folding
set nofoldenable

" have a 5-line context visible when scrolling
set scrolloff=5

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=black guibg=black
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" More discreet spelling highlighting
highlight clear SpellBad
highlight SpellBad cterm=underline ctermfg=red

set list listchars=tab:»·,trail:·

" Searching
set hlsearch                    " highlight matches
nnoremap <ESC>u :nohlsearch<CR> " make hlsearch work like less(1)
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" Re-balance pane sizes when the host window is resized
autocmd VimResized * wincmd =

" easy switching between window splits
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

set splitbelow
set splitright

let mapleader = ","
let maplocalleader = ","

" use j/k for line navigation even with softwrap
noremap j gj
nnoremap k gk
" also in visual mode
vnoremap j gj
vnoremap k gk

nnoremap <Leader>l :ls<CR>:b<space>

" window size constraints (useful with a lot of splits)
set winwidth=80
set winminwidth=40
set winheight=20
"set winminheight=10

" Hide menu, toolbar and scrollbar in gvim
set guioptions-=m
set guioptions-=T
set guioptions-=r

" Disable cursor blinking in gvim
set guicursor+=a:blinkon0

set guifont=Droid\ Sans\ Mono\ Slashed\ 12

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
    " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor
endif

" Search for word under the cursor in the entire project
" (requires the silver searcher (ag) plugin)
map <Leader>s :Ag <C-R><C-W><CR>

" trailing space left on purpose
map <Leader>a :Ag! 

" Save with Ctrl-S
" If the current buffer has never been saved, it will have no name, call the
" file browser to save it (only works in GUI mode), otherwise just save it.
command -nargs=0 -bar Update if &modified
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>


let g:pick_height = 10
nnoremap <c-p> :call PickFile()<CR>

" Testing
nmap <silent> <leader>t :TestFile<CR>
nmap <silent> <leader>T :TestNearest<CR>
"nmap <silent> <leader>a :TestSuite<CR>
"nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

set formatoptions+=j

let g:ale_sign_error = '●'
let g:ale_sign_warning = '●'
let g:ale_lint_on_enter = 0

set laststatus=2
set statusline=\ %f\ %m%=(%{&ft})\ %(%3l/%L\ :\ %-2c\ %)


" Run a given vim command on the results of alt from a given path.
" See usage below.
function! AltCommand(path, vim_command)
  let l:alternate = system("alt " . a:path)
  if empty(l:alternate)
    echo "No alternate file for " . a:path . " exists!"
  else
    exec a:vim_command . " " . l:alternate
  endif
endfunction

" Find the alternate file for the current path and open it
command A :call AltCommand(expand('%'), ':e')
command AS :call AltCommand(expand('%'), ':sp')
command AV :call AltCommand(expand('%'), ':vs')
