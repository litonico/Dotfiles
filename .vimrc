set noswapfile " I've lost so much work from bad swapfiles...
set nocompatible

execute pathogen#infect()
syntax on
filetype plugin on
filetype indent on
set showcmd " Show the current command
let mapleader=','

set t_Co=256
colorscheme jellybeans
highlight Normal ctermbg=233
set expandtab " In this floating world, all is spaces
set tabstop=4 " See language sections for lang-specific tabs and shifts
set shiftwidth=4
set number " Line Numbers
set cursorline
set ignorecase smartcase " Case-insensitive, unless there's a capital letter
set ruler " Line and Character count
set ls=2 " display filename at the bottom-left
set backspace=2 " Can delete anything I please

" Folding settings
" (These don't really work, because vim)
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1

" Over-length lines highlighting
set colorcolumn=81
highlight ColorColumn ctermbg=52
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/

" Window size
set winheight=30
" set winminheight=8
" God knows why the window size misses 3; this should be winwidth=81
set winwidth=84
let NERDTreeWinSize = 31 " Size of the NT file browser, when it's up

" Load Bash settings and $PATH
" set shell=/bin/bash\ -li

" Command-T/Ctrl-P ignores
" Home dir stuff:
set wildignore+=Applications,.git,Desktop,Library,Music,Downloads,Builds,Classwork
set wildignore+=Dropbox,Documents,Public,Pictures,Movies,Applications\ (Parallels)
" Actual ignores:
set wildignore+=tmp
"
set wildignore+=*/tmp/*cache/**
set wildignore+=*/tmp/locale_assets/**
set wildignore+=*/tmp/letter_opener/**

" Command line autocomplete
set wildmenu


" --- Key mappings ---
inoremap jk <esc>
cnoremap jk <esc>

" Yank to clipboard
map <leader>y "+y

" Whitespace
nnoremap <leader>s :StripWhitespace<CR>

" Ctrl-P
nnoremap <leader>t :CtrlP pwd<CR>

" 'x' command should never yank to a register; why the heck would it?
" it now yanks into the black-hole register.
" Also good for visual mode deletion
nnoremap x "_x

" Navigating between splits
nnoremap <silent> <C-l> <C-w>l
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-x> <C-w>x
" Splitting windows
nnoremap <silent> vv <C-w>v
nnoremap <silent> vs <C-w>n

" Center search results
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz

" Write and quit quickly
" (Using ZZ is still better, though)
"nnoremap <silent> <leader>q <C-w>c
nnoremap <silent> <leader>w :w<CR>

" I change my .vimrc lots!
nnoremap vrc :new ~/.vimrc<CR>
nnoremap src :source ~/.vimrc<CR>

" I hate accidentally pressing K
nnoremap K <Nop>
" Note- insta-`man` could be useful at some point...

" Change pwd to current file's directory
nnoremap cd. :cd %:p:h<CR>

" Super cool swapping!
" swap word right
nnoremap <silent> gl "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>
" swap left
nnoremap <silent> gh "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>

" GRB tab fix
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" GRB Rspec test utils
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
    let new_file = AlternateForCurrentFile()
    exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
    let current_file = expand("%")
    let new_file = current_file
    let in_spec = match(current_file, '^spec/') != -1
    let going_to_spec = !in_spec
    let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
    if going_to_spec
        if in_app
            let new_file = substitute(new_file, '^app/', '', '')
        end
        let new_file = substitute(new_file, '\.e\?rb$', '_spec.rb', '')
        let new_file = 'spec/' . new_file
    else
        let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
        let new_file = substitute(new_file, '^spec/', '', '')
        if in_app
            let new_file = 'app/' . new_file
        end
    endif
    return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapCR()
    nnoremap <cr> :call RunTestFile()<cr>
endfunction
"That's awesome, but it breaks the quickfix buffer
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

call MapCR()
nnoremap <leader>T :call RunNearestTest()<cr>
nnoremap <leader>a :call RunTests('')<cr>
nnoremap <leader>c :w\|:!script/features<cr>
" nnoremap <leader>w :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.py|_spec.js.coffee\)$') != -1
    if in_test_file
        call SetTestFile(command_suffix)
    elseif !exists("t:running_test_file")
        return
    end
    call RunTests(t:running_test_file)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" .  spec_line_number)
endfunction

function!  SetTestFile(command_suffix)
    " Set the spec file that tests will be run for.
    let t:running_test_file=@% .  a:command_suffix
endfunction

function!  RunTests(filename)
    " Write the file and run tests for the given filename
    if expand("%") != ""
        :w
    end
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        "First choice: project-specific test script
        if filereadable("script/test")
            exec ":!script/test " .  a:filename
            " Fall back to the .test-commands pipe if available, assuming someone
            " " is reading the other side and running the commands
        elseif filewritable(".test-commands")
            let cmd = 'rspec --color --format progress --require "~/lib/vim_rspec_formatter" --format VimFormatter --out tmp/quickfix'
            exec ":!echo " .  cmd .  " " .  a:filename .  " > .test-commands" 
            " Write an empty string to block until the command completes
            sleep 100m " milliseconds
            :!echo > .test-commands
            redraw!
            " Fall back to a blocking test run with Bundler
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " .  a:filename
            " Fall back to a normal blocking test run
        elseif match(a:filename, '\.js\.coffee$') != -1
            exec ":!rake spec:javascript SPEC=" . a:filename
        else
            exec ":!rspec --color " .  a:filename
        end
    end
endfunction


" L's utils
function! GitBlameFile()
    exec ":!git blame " . expand("%") . " -f"
endfunction
nnoremap <leader>B :call GitBlameFile()<cr>

function! GitBlameLine()
    let line_number = line('.')
    exec ":!git blame " . expand("%") . " -f -L " . line_number . "," . line_number " | awk '{print $3, $4}' | sed 's/(//g'"
endfunction
nnoremap <leader>b :call GitBlameLine()<cr>


" --- Plugin Settings ---

" Syntastic
let g:syntastic_javascript_checkers = ['eslint']

" Ctrl-P
let g:ctrlp_working_path_mode = 'ra'


" --- Language and Build Settings ---

augroup filetype_c
    autocmd BufRead *.c set makeprg=cd\ %:p:h\ &&\ make
    nnoremap <D-r> :update<CR>:make run<CR>
    nnoremap <D-b> :update<CR>:make<CR>
    " Macros for C header files
    au BufNewFile *.h :r !echo -e "#ifndef expand(%)\n #define expand(%)\n #endif
    "This would be cool if I could make it work:
    "if !filereadable(expand("%:p:h")."/Makefile")
    "    setlocal makeprg=gcc\ -Wall\ -Wextra\ -o\ %<\ %
    "endif
augroup end


augroup filetype_python
    autocmd FileType python compiler python3
augroup end

augroup filetype_latex
" (I can't figure this one out)
" autocmd BufRead *.tex set makeprg=latexmk\-cd\ -e\ \\\\$pdflatex\ =\ 'escape(%)E\ -interaction=nonstopmode\ -synctex=1\ escape(%)S\ escape(%)O'\ -silent\ -f\ -pdf
augroup end

augroup filetype_ruby
    autocmd BufRead *.rb setl makeprg=ruby\ %
    autocmd FileType ruby setl ai sw=2 sts=2 et
    autocmd FileType erb setl ai sw=2 sts=2 et
augroup end

" Elm
augroup filetype_elm
    autocmd BufRead *.elm setl makeprg=elm-make\ %
    autocmd FileType elm setl ai sw=2 sts=2 et
augroup filetype_elm

augroup filetype_rust
    autocmd FileType rust setl makeprg=cargo\ run
augroup end

augroup filetype_javascript
    autocmd FileType javascript setl ai sw=2 sts=2 et
augroup end

augroup filetype_coffee
    autocmd FileType coffee setl ai sw=2 sts=2 et
augroup end

augroup filetype_markdown
    autocmd FileType markdown setl makeprg=redcarpet\ %\ >/tmp/%<.html
augroup end

augroup filetype_scheme
    autocmd BufRead *.scm setl makeprg=racket\ %
    autocmd BufRead *.rkt setl makeprg=racket\ %
    " Reasoned Schemer
    set lispwords+=run*,run,fresh,conde,λ
    syn keyword racketFunc nullo pairo cdro conso caro conde ==
    syn keyword racketSyntax run run* fresh conde else λ
    syn keyword racketBoolean %s %u
    " Essentials of Programming Languages
    set lispwords+=cases,define-datatype
    syn keyword racketSyntax cases define-datatype
augroup end

augroup filetype_sml
    autocmd BufRead *.sml setl makeprg=sml\ <%
augroup end

" Haskell
augroup filetype_haskell
    autocmd BufRead *.hs set makeprg=cd\ %:p:h\ &&\ ghc\ -Wall\ %:p\ --make\ &&\ ./%:r
    autocmd BufRead *.hs nnoremap <CR> :!runhaskell %<CR>
augroup end
