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
set ignorecase " I HATE case-sensitive search
set ruler " Line and Character count

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

" " Load Bash settings and $PATH
" set shell=/bin/bash\ -li

" Command-T/Ctrl-P ignores
" Home dir stuff:
set wildignore+=Applications,.git,Desktop,Library,Music,Downloads,Builds,Classwork
set wildignore+=Dropbox,Documents,Public,Pictures,Movies,Applications\ (Parallels)
" Actual ignores:
set wildignore+=tmp
" Rust builds:
set wildignore+=target

" Ctrl-P settings
let g:ctrlp_working_path_mode = 'ra'

" --- Key mappings ---
inoremap jk <esc>
cnoremap jk <esc>

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

" Strip Whitespace
nnoremap <leader>s :StripWhitespace<CR>

" Change pwd to current file's directory
nnoremap cd. :cd %:p:h<CR>

" Super cool swapping!
" swap word right
nnoremap <silent> gl "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>
" swap left
nnoremap <silent> gh "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>

" c/o Gary Bernhardt
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

let testfile = "test.rb" " TODO
" --- Test runner ---
function! RubyTests()
    :w
    if filereadable("scripts/test")
        exec ":!sh scripts/test"
    elseif filereadable("Rakefile")
        exec ":!rake test"
    elseif filereadable("test.rb")
        exec ":!ruby test.rb"
    else
        echo "Test file not found (maybe run `set testfile=...)"
    endif
endfunction

function! RailsTests() " ONLY use the rakefile for running tests (for rails)
    nnoremap <CR> :!rake test<CR>
endfunction

function! RustTests()
    :w
    exec ":!cargo test"
endfunction

function! RemapCRToAppropriateTests()
    :w
    if &ft == "ruby"
        nnoremap <CR> :call RubyTests()<CR>
    elseif &ft == "rust"
        nnoremap <CR> :call RustTests()<CR>
    endif
endfunction

" call RemapCRToAppropriateTests()
au BufRead,BufNewFile * :call RemapCRToAppropriateTests()

function! TypeCheck()
    :w
    if &ft == "haskell"
        exec ":!ghc -Wall " . expand("%:p") . " --make"
    elseif &ft == "rust"
        exec ":!rustc " . expand("%:p")
    endif
endfunction

" --- Language and Build Settings ---

" C
autocmd BufRead *.c set makeprg=cd\ %:p:h\ &&\ make
nnoremap <D-r> :update<CR>:make run<CR>
nnoremap <D-b> :update<CR>:make<CR>
" Macros for C header files
au BufNewFile *.h :r !echo -e "#ifndef expand(%)\n #define expand(%)\n #endif

"This would be cool if I could make it work:
"if !filereadable(expand("%:p:h")."/Makefile")
"    setlocal makeprg=gcc\ -Wall\ -Wextra\ -o\ %<\ %
"endif

" Python
autocmd BufRead *.py setl makeprg=python3\ %

" Latex (I can't figure this one out)
" autocmd BufRead *.tex set makeprg=latexmk\-cd\ -e\ \\\\$pdflatex\ =\ 'escape(%)E\ -interaction=nonstopmode\ -synctex=1\ escape(%)S\ escape(%)O'\ -silent\ -f\ -pdf

" Ruby
autocmd BufRead *.rb setl makeprg=ruby\ %
" Only two spaces
autocmd FileType ruby setl ai sw=2 sts=2 et
autocmd FileType erb setl ai sw=2 sts=2 et

" Elm
autocmd BufRead *.elm setl makeprg=elm-make\ %
autocmd FileType elm setl ai sw=2 sts=2 et

" Rust
autocmd BufRead *.rs setl makeprg=cargo\ run

" Javascript (V8)
autocmd BufRead *.js setl makeprg=v8\ %
autocmd FileType javascript setl ai sw=2 sts=2 et

" Markdown
autocmd BufRead *.md setl makeprg=redcarpet\ %\ >/tmp/%<.html
" autocmd BufRead *.md set makeprg

" Scheme / Racket
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

" SML
autocmd BufRead *.sml setl makeprg=sml\ <%

" Haskell
" cmd-B to compile
autocmd BufRead *.hs set makeprg=cd\ %:p:h\ &&\ ghc\ -Wall\ %:p\ --make\ &&\ ./%:r
" cmd-R to run
autocmd BufRead *.hs nnoremap <D-r> :!runhaskell %<CR>

" MIX and MMIX for TAOCP
autocmd BufRead *.mixal setl makeprg=mixasm\ %
autocmd BufRead *.mms setl makeprg=mmixal\ %\ &&\ mmix\ %:r
autocmd BufRead *.mmo setl makeprg=mmix\ %
