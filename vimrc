" You want Vim, not vi. When Vim finds a vimrc, 'nocompatible' is set anyway.
" We set it explicitly to make our position clear!
set nocompatible

"------------------
" Autocmd
"------------------
" https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
" Using the autocmd method, you could customize when the directory change
" takes place. For example, to not change directory if the file is in /tmp:
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
  augroup END
endif " has("autocmd")

"Change vimrc with auto reload
autocmd! bufwritepost .vimrc source %

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
" Use this option to disable/enable vimtex improved syntax highlighting.
" Default value: 1
let g:vimtex_syntax_enabled=1
" Remove warning message: Can't use callbacks without +clientserver · Issue #507 · lervag/vimtex
let g:vimtex_compiler_latexmk = {'callback' : 0}
let g:vimtex_view_method = 'zathura'
" Disable overfull/underfull \hbox.
let g:vimtex_quickfix_latexlog = {
        \ 'overfull' : 0,
        \ 'underfull' : 0,
        \}
let g:vimtex_quickfix_ignore_filters = [
        \ 'Unused global option(s)',
        \ 'FandolSong-Regular',
        \ 'FandolHei-Regular',
        \ 'FandolKai-Regular',
        \ 'FandolFang-Regular',
        \ 'Package Fancyhdr Warning',
        \ 'Package etex Warning',
        \ 'Empty bibliography',
        \]
" Install coc.nvim:
" Make sure node and npm are installed. On ubuntu 20.04
" sudo apt install nodejs npm
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Install coc-vimtex: In your vim/neovim, run command: :CocInstall coc-vimtex

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0
" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0
" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0
" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''
" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''
" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0
" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''
" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {}
    \ }
" use a custom markdown style must be absolute path
let g:mkdp_markdown_css = ''
" use a custom highlight style must absolute path
let g:mkdp_highlight_css = ''
" use a custom port to start server or random for empty
let g:mkdp_port = ''
" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'
" example
nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle

Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

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
" Trigger completion automatically (Disable auto trigger by setting 1 as 0)
let g:completor_auto_trigger = 1
" Use Tab to select a completion from candidates.
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

Plug 'masawada/completor-dictionary'
autocmd FileType * execute 'setlocal dictionary='.expand($HOME.'/.vim/dict/'.&filetype.'.dict')

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

" Add settings from 'github.com/gillescastel/latex-snippets'
Plug 'KeitaNakamura/tex-conceal.vim'
    set conceallevel=1
    let g:tex_conceal='abdmg'
    hi Conceal ctermbg=none

setlocal spell
set spelllang=en_us,cjk
" https://www.zhihu.com/question/30737688/answer/80203854
autocmd FileType tex setlocal spell spelllang=en_us,cjk
autocmd FileType markdown setlocal spell spelllang=en_us,cjk
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
" Share vim spellchecking additions between multiple machines.
" https://vi.stackexchange.com/a/5052/16763
set spellfile=~/.vim/spell/en.utf-8.add
" re-generate spl file for spell checking
for d in glob('~/.vim/spell/*.add', 1, 1)
    if filereadable(d) && (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
        exec 'mkspell! ' . fnameescape(d)
    endif
endfor

" Folding
" https://vim.fandom.com/wiki/Folding#Indent_folding_with_manual_folds
" augroup vimrc
"   au BufReadPre * setlocal foldmethod=indent
"   au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
" augroup END
setlocal foldmethod=indent
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

Plug 'lifepillar/vim-cheat40'

Plug '907th/vim-auto-save'
let g:auto_save = 1  " enable AutoSave on Vim startup
"let g:auto_save_silent = 1  " do not display the auto-save notification

" https://github.com/junegunn/vim-plug
" Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" The above plug is removed since it might be very slow to install.
" An alternative way is to install by git separately.
Plug 'junegunn/fzf.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"----------------
" Basic settings
"----------------
set number      " Display line number.
" set numberwidth=5
" https://stackoverflow.com/a/26284471/2400133
set columns=86
" autocmd VimResized * if (&columns > 72) | set columns=72| endif
set textwidth=72
set wrap
set linebreak
set showbreak=+

"-----------------
" System settings
"-----------------
" https://www.zhihu.com/question/60367881
" https://github.com/vim/vim/issues/2049#issuecomment-494923065
set maxmempattern=5000

set encoding=utf-8
" Terminal coding
set termencoding=utf-8
" The coding of current file
set fileencodings=ucs-bom,utf-8,gbk,cp936,gb2312,big5,euc-jp,euc-kr,latin1

"-----------------
" a minimal vimrc
"-----------------
" https://github.com/mhinz/vim-galore/blob/master/static/minimal-vimrc.vim
" A (not so) minimal vimrc.

filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set backspace   =indent,eol,start  " Make backspace work as you expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
" set display     =lastline  " Show as much as possible of the last line.

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

" set incsearch              " Highlight while searching with / or ?.
" set hlsearch               " Keep matches highlighted.
" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif
" highlight serach
set hlsearch
" https://vi.stackexchange.com/a/185/16763
nnoremap <Leader><space> :noh<cr>

" https://vim.fandom.com/wiki/Searching#Case_sensitivity
:set ignorecase
:set smartcase
:nnoremap * /\<<C-R>=expand('<cword>')<CR>\><CR>
:nnoremap # ?\<<C-R>=expand('<cword>')<CR>\><CR>
" http://vim.wikia.com/wiki/Search_across_multiple_lines?useskin=monobook
" Search for the ... arguments separated with whitespace (if no '!'),
" or with non-word characters (if '!' added to command).
function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction
command! -bang -nargs=* -complete=tag S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set cursorline             " Find the current line quickly.
set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.

" set list                   " Show non-printable characters.
" if has('multi_byte') && &encoding ==# 'utf-8'
"   let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
" else
"   let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
" endif

" The fish shell is not very compatible to other shells and unexpectedly
" breaks things that use 'shell'.
" if &shell =~# 'fish$'
"   set shell=/bin/bash
" endif

" https://github.com/mhinz/vim-galore#Temporary-files
if !isdirectory($HOME.'/.vim/files') && exists('*mkdir')
  call mkdir($HOME.'/.vim/files')
endif
if !isdirectory($HOME.'/.vim/files/backup') && exists('*mkdir')
  call mkdir($HOME.'/.vim/files/backup')
endif
if !isdirectory($HOME.'/.vim/files/info') && exists('*mkdir')
  call mkdir($HOME.'/.vim/files/info')
endif
if !isdirectory($HOME.'/.vim/files/swap') && exists('*mkdir')
  call mkdir($HOME.'/.vim/files/swap')
endif
if !isdirectory($HOME.'/.vim/files/undo') && exists('*mkdir')
  call mkdir($HOME.'/.vim/files/undo')
endif

" backup files
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
" swap files
set directory   =$HOME/.vim/files/swap//
set updatecount =100
" undo files
set undofile
set undodir     =$HOME/.vim/files/undo/
" viminfo files
set viminfo     ='100,n$HOME/.vim/files/info/viminfo

"--------------------------
" Source other vimrc files
"--------------------------

try
  source ~/.vimrc_local
catch
  " No such file? No problem; just ignore it.
endtry
