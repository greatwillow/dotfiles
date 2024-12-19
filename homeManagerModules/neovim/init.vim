nnoremap <SPACE> <Nop>
let mapleader=" "

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tomasiser/vim-code-dark'
" Center text
Plug 'junegunn/goyo.vim'
" Code Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" This objectively makes vim better
Plug 'terryma/vim-multiple-cursors'
" Working with tags
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
" Commenting
Plug 'tpope/vim-commentary'
" Syntax highlighting
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'unblevable/quick-scope'
Plug 'junegunn/vim-peekaboo'
Plug 'michaeljsmith/vim-indent-object'
" Vim wki
Plug 'vimwiki/vimwiki'
" Fuzzy find files
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

call plug#end()

" Map escape key
inoremap jj <Esc>
" Map FZF
nnoremap <c-p> :FZF <CR>
" Map opening of .vimrc file
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Map sourcing of .vimrc file so changes take effect
nnoremap <leader>sv :source $MYVIMRC<cr>
" Map delete to black hole registry -> See:https://stackoverflow.com/questions/11993851/how-to-delete-not-cut-in-vim
nnoremap d "_d
vnoremap d "_d
" CTRL+S Save
imap <C-s> <ESC>:w<CR>a

"  let g:airline_theme = 'codedark'

" Basic settings
set exrc " Allows local .vimrc file to override and provide additional functionality
set mouse=a
syntax on
set nohlsearch " Ensures that the search highlight is turned off after search is finished
set hidden " Keeps buffers in background instead of automatically closing them
set noerrorbells
"set nowrap  <-- Set this when we don't want line wrap
set ignorecase
set scrolloff=8
set smartcase
set encoding=utf-8
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set number relativenumber
set termguicolors
set incsearch "ensures search text is highlighted
colorscheme nord

"Undo functionality - use with UndoTree plugin
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

"------------vim-wiki----------
set nocompatible
filetype plugin on
syntax on
"change wiki syntax to markdown
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
noremap <leader>0 :tablast<cr>
noremap <leader>0 :tablast<cr>

"-----------Tabs---------------
"
nnoremap th  :tabfirst<CR>
nnoremap tk  :tabnext<CR>
nnoremap tj  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>
" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt

" Autocompletion
set wildmode=longest,list,full

" Fix splitting
set splitbelow splitright

" Use system clipboard
set clipboard+=unnamedplus

" Vim Quickscope
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 20

function! OpenToRight()
  :normal v
  let g:path=expand('%:p')
  :q!
  execute 'belowright vnew' g:path
  :normal <C-l>
endfunction

function! OpenBelow()
  :normal v
  let g:path=expand('%:p')
  :q!
  execute 'belowright new' g:path
  :normal <C-l>
endfunction


function! NetrwMappings()
    " Hack fix to make ctrl-l work properly
    noremap <buffer> <C-l> <C-w>l
    noremap <silent> <C-f> :call ToggleNetrw()<CR>
    noremap <buffer> V :call OpenToRight()<cr>
    noremap <buffer> H :call OpenBelow()<cr>
endfunction

augroup netrw_mappings
    autocmd!
    autocmd filetype netrw call NetrwMappings()
augroup END

" Allow for netrw to be toggled
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction

" Close Netrw if it's the only buffer open
autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif

" Make netrw act like a project Draw
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :call ToggleNetrw()
augroup END

let g:NetrwIsOpen=0

" Vim Commentary

" ------Vim Auto Closetag------
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml,js'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filetypes = 'xhtml,jsx,js'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'

" ------COC SETTINGS------
" prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-angular',
  \ 'coc-texlab'
  \ ]

" From Coc Readme
set updatetime=300

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use D to show documentation in preview window
nnoremap <silent> D :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <rn> <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" ------Standard Bindings------
" Basic file system commands
nnoremap <C-t> :!touch<Space>
nnoremap <C-e> :!crf<Space>
"nnoremap <C-d> :!mkdir<Space>
nnoremap <C-m> :!mv<Space>%<Space>

cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable disable Goyo
map <leader>g :Goyo<CR>
map <leader>G :Goyo!<CR>

" Enable and disable auto comment
map <leader>c :setlocal formatoptions-=cro<CR>
map <leader>C :setlocal formatoptions=cro<CR>

" Enable spell checking, s for spell check
map <leader>s :setlocal spell! spelllang=en_au<CR>

" Enable Disable Auto Indent
map <leader>i :setlocal autoindent<CR>
map <leader>I :setlocal noautoindent<CR>

" Shell check
map <leader>p :!clear && shellcheck %<CR>

" Compile and open output
map <leader>r :w! \| !comp <c-r>%<CR><CR>
map <leader>o :!opout <c-r>%<CR><CR>

" Shortcutting split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Shortcut split opening
nnoremap <leader>h :split<Space>
nnoremap <leader>v :vsplit<Space>

" Vertically center document when entering insert mode
autocmd InsertEnter * norm zz

" Alias replace all to S
nnoremap S :%s//gI<Left><Left><Left>

" Alias write and quit to Q
" nnoremap <leader>q :wq<CR>
" nnoremap <leader>w :w<CR>

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Save file as sudo when no sudo permissions
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Fix tex file type set
autocmd BufRead,BufNewFile *.tex set filetype=tex
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown

" Guide navigation
noremap <leader><Tab> <Esc>/<++><Enter>"_c4l
inoremap <leader><Tab> <Esc>/<++><Enter>"_c4l
vnoremap <leader><Tab> <Esc>/<++><Enter>"_c4l

" general insert commands
inoremap ;g <++>

" shell
map <leader>b i#!/bin/sh<CR><CR>
autocmd FileType sh inoremap ,f ()<Space>{<CR><Tab><++><CR>}<CR><CR><++><Esc>?()<CR>
autocmd FileType sh inoremap ,i if<Space>[<Space>];<Space>then<CR><++><CR>fi<CR><CR><++><Esc>?];<CR>hi<Space>
autocmd FileType sh inoremap ,ei elif<Space>[<Space>];<Space>then<CR><++><CR><Esc>?];<CR>hi<Space>
autocmd FileType sh inoremap ,sw case<Space>""<Space>in<CR><++>)<Space><++><Space>;;<CR><++><CR>esac<CR><CR><++><Esc>?"<CR>i
autocmd FileType sh inoremap ,ca )<Space><++><Space>;;<CR><++><Esc>?)<CR>i

" html
autocmd FileType html noremap <leader>d i<!DOCTYPE html><CR><html><CR><head><CR><meta charset="UTF-8"><CR><title><++></title><CR></head><CR><body><CR><++><CR></body><CR></html>
autocmd FileType html inoremap ,1 <h1></h1><CR><CR><++><Esc>?</h1<CR>i
autocmd FileType html inoremap ,2 <h2></h2><CR><CR><++><Esc>?</h2<CR>i
autocmd FileType html inoremap ,3 <h3></h3><CR><CR><++><Esc>?</h3<CR>i
autocmd FileType html inoremap ,4 <h4></h4><CR><CR><++><Esc>?</h4<CR>i
autocmd FileType html inoremap ,5 <h5></h5><CR><CR><++><Esc>?</h4<CR>i
autocmd FileType html inoremap ,6 <h6></h6><CR><CR><++><Esc>?</h4<CR>i
autocmd FileType html inoremap ,d <div><CR></div><CR><CR><++><Esc>?</div<CR><S-o>
autocmd FileType html inoremap ,ar <article><CR></article><CR><CR><++><Esc>?</arti<CR><S-o>
autocmd FileType html inoremap ,as <aside><CR></aside><CR><CR><++><Esc>?</asid<CR><S-o>
autocmd FileType html inoremap ,fic <figcaption><CR></figcaption><CR><CR><++><Esc>?</figcap<CR><S-o>
autocmd FileType html inoremap ,fi <figure><CR></figure><CR><CR><++><Esc>?</figure<CR><S-o>
autocmd FileType html inoremap ,he <header><CR></header><CR><CR><++><Esc>?</header<CR><S-o>
autocmd FileType html inoremap ,f <footer><CR></footer><CR><CR><++><Esc>?</footer<CR><S-o>
autocmd FileType html inoremap ,fo <form action=""><CR><++><CR></form><CR><CR><Esc>?"<CR>i
autocmd FileType html inoremap ,in <input type="" name="<++>" placeholder="<++>"/><CR><++><Esc>?""<CR>li
autocmd FileType html inoremap ,te <textarea rows="" col="<++>" placeholder="<++>"/><++></textarea><CR><++><Esc>?s=""<CR>llli
autocmd FileType html inoremap ,bu <button type=""><++></button><CR><++><Esc>?"<CR>i
autocmd FileType html inoremap ,la <label for=""><++></label><CR><++><Esc>?"<CR>i
autocmd FileType html inoremap ,ma <main><CR></main><CR><CR><++><Esc>?</main<CR><S-o>
autocmd FileType html inoremap ,mr <mark><CR></mark><CR><CR><++><Esc>?</mark<CR><S-o>
autocmd FileType html inoremap ,n <nav><CR></nav><CR><CR><++><Esc>?</nav<CR><S-o>
autocmd FileType html inoremap ,se <section><CR></section><CR><CR><++><Esc>?</section<CR><S-o>
autocmd FileType html inoremap ,su <summary><CR><summary><CR><CR><++><Esc>?</summary?<CR><S-o>
autocmd FileType html inoremap ,p <p><CR></p><CR><CR><++><Esc>?</p><CR><S-o>
autocmd FileType html inoremap ,b <b></b><Space><++><Esc>?</b><CR>i
autocmd FileType html inoremap ,a <a href=""><++></a><Space><++><Esc>?"<CR>i
autocmd FileType html inoremap ,br <CR></br><CR>
autocmd FileType html inoremap ,em <em><em><Space><++><Esc>?</p><CR>i
autocmd FileType html inoremap ,im <img src="" alt="<++>"><CR><CR><++><Esc>?""<CR>li
autocmd FileType html inoremap ,ol <ol><CR><li></li><CR><++><CR></ol><CR><CR><++><Esc>?</li><CR>i
autocmd FileType html inoremap ,ul <ul><CR><li></li><CR><++><CR></ul><CR><CR><++><Esc>?</li><CR>i
autocmd FileType html inoremap ,li <li></li><CR><++><Esc>?</li><CR>i
autocmd FileType html inoremap ,ta <table><CR><thead><CR><tr><CR><th></th><CR><++><CR></tr><CR></thead><CR><tbody><CR><tr><CR><td><++></td><CR><++><CR></tr><CR></tbody><CR><tfoot><CR><tr><CR><td><++></td><CR><++><CR></tfoot><CR></table><Esc>?</th><CR>i
autocmd FileType html inoremap ,th <th></th><CR><++><Esc>?</th><CR>i
autocmd FileType html inoremap ,td <td></td><CR><++><Esc>?</td><CR>i
autocmd FileType html inoremap ,tr <tr><CR></tr><CR><CR><++><Esc>?</tr><CR>i

" markdown
autocmd FileType markdown noremap <leader>r i---<CR>title:<Space><++><CR>author:<Space>"Brodie Robertson"<CR>geometry:<CR>-<Space>top=30mm<CR>-<Space>left=20mm<CR>-<Space>right=20mm<CR>-<Space>bottom=30mm<CR>header-includes:<Space>\|<CR><Tab>\usepackage{float}<CR>\let\origfigure\figure<CR>\let\endorigfigure\endfigure<CR>\renewenvironment{figure}[1][2]<Space>{<CR><Tab>\expandafter\origfigure\expandafter[H]<CR><BS>}<Space>{<CR><Tab>\endorigfigure<CR><BS>}<CR><BS>---<CR><CR>
autocmd FileType markdown inoremap ,i ![]("<++>")<Space><++><Esc>F]i
autocmd FileType markdown inoremap ,a []("<++>")<Space><++><Esc>F]i
autocmd FileType markdown inoremap ,1 #<Space><CR><CR><++><Esc>2k<S-a>
autocmd FileType markdown inoremap ,2 ##<Space><CR><CR><++><Esc>2k<S-a>
autocmd FileType markdown inoremap ,3 ###<Space><CR><CR><++><Esc>2k<S-a>
autocmd FileType markdown inoremap ,4 ####<Space><CR><CR><++><Esc>2k<S-a>
autocmd FileType markdown inoremap ,5 #####<Space><CR><CR><++><Esc>2k<S-a>
autocmd FileType markdown inoremap ,u +<Space><CR><++><Esc>1k<S-a>
autocmd FileType markdown inoremap ,o 1.<Space><CR><++><Esc>1k<S-a>

" latex
autocmd FileType tex,latex noremap <leader>d :w<CR>:!texify<Space>-cp<Space>%<CR>
autocmd FileType tex,latex inoremap ,c \{<++>}<CR><++><Esc>?{<CR>i
autocmd FileType tex,latex inoremap ,dc \documentclass{}<CR><CR><++><Esc>?}<CR>i
autocmd FileType tex,latex inoremap ,up \usepackage{}<CR><CR><++><Esc>?}<CR>i
autocmd FileType tex,latex inoremap ,bd \begin{document}<CR><CR><CR><CR>\end{document}<Esc>kki
autocmd FileType tex,latex inoremap ,be \begin{}<CR><CR><CR><CR>\end{<++>}<Esc>?n{<CR>lli
autocmd FileType tex,latex inoremap ,ti \title{}<CR><CR><++><Esc>?}<CR>i
autocmd FileType tex,latex inoremap ,a \author{}<CR><CR><++><Esc>?}<CR>i
autocmd FileType tex,latex inoremap ,mt \maketitle<CR><CR>
autocmd FileType tex,latex inoremap ,s \section{}<CR><CR><++><Esc>?}<CR>i
autocmd FileType tex,latex inoremap ,ss \subsection{}<CR><CR><++><Esc>?}<CR>i
autocmd FileType tex,latex inoremap ,sss \subsubsection{}<CR><CR><++><Esc>?}<CR>i
autocmd FileType tex,latex inoremap ,rc \renewcommand{}{<++>}<CR><CR><++><Esc>?}{<CR>i
autocmd FileType tex,latex inoremap ,tf \titleformat{}{<++>}{<++>}{<++>}{<++>}<CR><CR><++><Esc>?{}<CR>li
autocmd FileType tex,latex inoremap ,lt {\LaTeX}<Space>
autocmd FileType tex,latex inoremap ,b \bfseries
autocmd FileType tex,latex inoremap ,t \tiny
autocmd FileType tex,latex inoremap ,sc \scriptsize
autocmd FileType tex,latex inoremap ,fn \footnotesize
autocmd FileType tex,latex inoremap ,sm \small
autocmd FileType tex,latex inoremap ,l \large
autocmd FileType tex,latex inoremap ,h \huge


"PLUGIN REFERENCE
"
"----------------vim-indent-object---------
"<count>ai	An Indentation level and line above.
"<count>ii	Inner Indentation level (no line above).
"<count>aI	An Indentation level and lines above/below.
"<count>iI	Inner Indentation level (no lines above/below).
"
"----------------vim-commentary---------------
"gcc   -> comments out line
"gc    -> In visual mode - comments out section
"12gcc  -> comment 12 lines
"
"----------------vim-wiki----------------------
"
"Key bindings
" normal mode:

" <Leader>ww -- Open default wiki index file.
" <Leader>wt -- Open default wiki index file in a new tab.
" <Leader>ws -- Select and open wiki index file.
" <Leader>wd -- Delete wiki file you are in.
" <Leader>wr -- Rename wiki file you are in.
" <Enter> -- Follow/Create wiki link
" <Shift-Enter> -- Split and follow/create wiki link
" <Ctrl-Enter> -- Vertical split and follow/create wiki link
" <Backspace> -- Go back to parent(previous) wiki link
" <Tab> -- Find next wiki link
" <Shift-Tab> -- Find previous wiki link
" For more keys, see :h vimwiki-mappings

" Commands
" :Vimwiki2HTML -- Convert current wiki link to HTML
" :VimwikiAll2HTML -- Convert all your wiki links to HTML
" :help vimwiki-commands -- list all commands
" :help vimwiki -- General vimwiki help docs
"
" ----------------------------------------------REFERENCES-----------
" general learning
" - https://learnvimscriptthehardway.stevelosh.com/
" netrw
" - https://blog.stevenocchipinti.com/2016/12/28/using-netrw-instead-of-nerdtree-for-vim/
"i