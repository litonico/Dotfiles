nnoremap <CR> :make!<CR>

function! SetRailsMake()
    let l:path = getcwd()
    if match(l:path, "rails\$") > 0
        if filewritable(l:path . "/activesupport") == 2
            let l:base = split(expand("%"), '\/')[0]
            let l:lib = l:base . "/lib"
            let l:test = l:base . "/test"
            let l:prg = "ruby\ -I\ " . l:lib . ":" . l:test . "\ %"
            let &makeprg=l:prg
        endif
    endif
endfunction

" Use makeprg to run stuff instead of running it in the terminal
augroup filetype_ruby
    autocmd BufRead *_spec.rb set makeprg=bundle\ exec\ rspec\ %
augroup end

set guifont=Menlo:h16

set shell=/bin/bash\ -li
