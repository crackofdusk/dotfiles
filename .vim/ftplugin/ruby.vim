set nu
set tabstop=2
set shiftwidth=2
set textwidth=80

function! RunCurrentRubyFile()
    echo system("ruby " . bufname("%"))
endfunction

noremap <leader>r :exec RunCurrentRubyFile()<cr>
