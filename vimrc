" You want Vim, not vi. When Vim finds a vimrc, 'nocompatible' is set anyway.
" We set it explicitely to make our position clear!
set nocompatible

"--------------------------
" Source other vimrc files
"--------------------------

try
  source ~/.vimrc_local
catch
  " No such file? No problem; just ignore it.
endtry

"---------------
" Load vim-plug
"---------------

" Plugins will be downloaded under the specified directory.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Add other plugins here.

Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
" Disable overfull/underfull \hbox and all package warnings
let g:vimtex_quickfix_latexlog = {
        \ 'overfull' : 0,
        \ 'underfull' : 0,
        \ 'font' : 0,
        \ 'packages' : {
        \   'default' : 0,
        \ },
        \}

Plug 'w0rp/ale'
" side bar display
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:ale_enabled = 0
" icon definition
"let g:ale_sign_error = '✗'
"let g:ale_sign_warning = '⚡'
" ALE offers some commands with <Plug> keybinds for moving between
" warnings and errors quickly.
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
"<Leader>s toggle ale
nmap <Leader>a :ALEToggle<CR>
"<Leader>d Look up the details of an error/warning.
nmap <Leader>d :ALEDetail<CR>
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0
let g:airline#extensions#ale#enabled = 1
let g:ale_python_pylint_options = "--init-hook='import sys; sys.path.append(\".\")'"

Plug 'maralla/completor.vim'
" maralla/completor configuration
" https://github.com/maralla/completor.vim/issues/41
let g:completor_tex_omni_trigger =
        \   '\\(?:'
        \  .   '\w*cite\w*(?:\s*\[[^]]*\]){0,2}\s*{[^}]*'
        \  .  '|\w*ref(?:\s*\{[^}]*|range\s*\{[^,}]*(?:}{)?)'
        \  .  '|hyperref\s*\[[^]]*'
        \  .  '|includegraphics\*?(?:\s*\[[^]]*\]){0,2}\s*\{[^}]*'
        \  .  '|(?:include(?:only)?|input)\s*\{[^}]*'
        \  .')'
" Use Tab to select completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
" Use Tab to trigger completion (disable auto trigger)
let g:completor_auto_trigger = 1
" inoremap <expr> <Tab> pumvisible() ? "<C-N>" : "<C-R>=completor#do('complete')<CR>"

Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
" Trigger configuration. Do not use <tab> if you use Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
" begin: https://castel.dev/post/lecture-notes-1/
let g:UltiSnipsJumpForwardTrigger="<tab>" " default <c-b>
let g:UltiSnipsJumpBackwardTrigger="<s-tab>" " default <c-z>
" end: https://castel.dev/post/lecture-notes-1/
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" To use python version 3.x: >
let g:UltiSnipsUsePythonVersion = 3

" Folding
" https://vim.fandom.com/wiki/Folding#Indent_folding_with_manual_folds
augroup vimrc
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END
Plug 'tmhedberg/SimpylFold'
let g:SimpylFold_docstring_preview=1
" https://stackoverflow.com/a/7425005/2400133
" https://www.cnblogs.com/heqiuyu/articles/5630167.html
set foldlevel=0
set foldnestmax=3
" Enable folding with the spacebar
nnoremap <space> za
" https://stackoverflow.com/a/360634/2400133
vnoremap <space> zf

Plug 'altercation/vim-colors-solarized'
syntax enable
colorscheme solarized
if has('gui_running')
    set background=light
else
    set background=dark
endif

" https://lotabout.me/2018/true-color-for-tmux-and-vim/
if has("termguicolors")
    " enable true color
    set termguicolors
endif

" Pluggins related to git:
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'

Plug 'mhinz/vim-startify'
let g:startify_custom_header = []

Plug '907th/vim-auto-save'
let g:auto_save = 1  " enable AutoSave on Vim startup
"let g:auto_save_silent = 1  " do not display the auto-save notification

" https://github.com/junegunn/vim-plug
" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"-----------------
" System settings
"-----------------
" https://www.zhihu.com/question/60367881
" https://github.com/vim/vim/issues/2049#issuecomment-494923065
set maxmempattern=5000
" https://github.com/mhinz/vim-galore/blob/master/static/minimal-vimrc.vim
" A (not so) minimal vimrc.

filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set cursorline             " Find the current line quickly.
set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

" The fish shell is not very compatible to other shells and unexpectedly
" breaks things that use 'shell'.
if &shell =~# 'fish$'
  set shell=/bin/bash
endif

" Put all temporary files under the same directory.
" Create these directories if they do not exist. Otherwise, E303: Unable to ...
" https://stackoverflow.com/a/12488082/2400133 See the comment with high score.
silent call mkdir ($HOME.'/.vim/files/backup', 'p')
silent call mkdir ($HOME.'/.vim/files/info', 'p')
silent call mkdir ($HOME.'/.vim/files/swap', 'p')
silent call mkdir ($HOME.'/.vim/files/undo', 'p')

" https://github.com/mhinz/vim-galore#handling-backup-swap-undo-and-viminfo-files
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.vim/files/swap/
set updatecount =100
set undofile
set undodir     =$HOME/.vim/files/undo/
set viminfo     ='100,n$HOME/.vim/files/info/viminfo
