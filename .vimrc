if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif

" save swap files in a custom location
set directory=~/.vim/swap

set tabstop=4
set shiftwidth=4
set expandtab

set title

filetype plugin on
filetype plugin indent on

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

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd BufRead,BufNewFile *.md setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80
augroup END

syntax on
colorscheme wombat256mod
set cursorline
set number

" I don't use folding
set nofoldenable

" have a 5-line context visible when scrolling
set scrolloff=5

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=black guibg=black
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" More discreet speeling highlighting
highlight clear SpellBad
highlight SpellBad cterm=underline ctermfg=red

set list listchars=tab:»·,trail:·

" Searching
set hlsearch                    " highlight matches
nnoremap <ESC>u :nohlsearch<CR> " make hlsearch work like less(1)
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" easy switching between window splits
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

" change the working directory to the open file's directory
" autocmd BufEnter * lcd %:p:h

nmap <F4> :w<CR>:make<CR>:cw<CR><CR>

let mapleader = ","

" use j/k for line navigation even with softwrap
noremap j gj
nnoremap k gk
" also in visual mode
vnoremap j gj
vnoremap k gk

" window size constraints (useful with a lot of splits)
set winwidth=80
set winminwidth=40
set winheight=20
set winminheight=10

" Hide menu, toolbar and scrollbar in gvim
set guioptions-=m
set guioptions-=T
set guioptions-=r

" Disable cursor blinking in gvim
set guicursor+=a:blinkon0

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
    " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" vim-rspec mappings
map <Leader>t :call RunCurrentSpecFile()<CR><CR>
map <Leader>s :call RunNearestSpec()<CR><CR>
map <Leader>l :call RunLastSpec()<CR><CR>

" rspec + dispatch = async feedback awesomeness
let g:rspec_command = 'Dispatch rspec {spec}'

"" airline (status line) configuration
let g:airline_theme = 'badwolf'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

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
