
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set background=dark

" A clean-looking font for gvim
set guifont="Courier New"

" File encoding
set encoding=utf-8
set fileencoding=utf-8

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set is			" inner sentence
set magic		" change the special characters that can be used in search patterns
set hls			" highlight search
set noic		" no ignore case
set smartcase		" enables case sensitive only when searching wOrDs
"set nobackup
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set nowrap		" disable line wrap
"set number		" show line numbers
set showmatch		" show matching brackets when typing
set mouse=		" disable mouse
set title		" set title of the window
set laststatus=2	" always shows statusline
"set cursorline		" highlight the screen line under the cursor
"set ve=all

set history=1000        " remember more commands and search history
set undolevels=1000     " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class

set autoread		" watch for file changes by other programs
set scrolloff=5		" keep at least 5 lines above/below cursor
set sidescrolloff=5	" keep at least 5 columns left/right of cursor
set lazyredraw		" don't redraw when running macros
"set winheight=999	" maximize split windows
set winminheight=0	" completely hide other windws

" Autocomplete like bash
set wildmode=longest,list
"" Autocomplete like bash, with full complete after 2 tabs
" set wildmode=longest,list:full
" Always shows menu
set completeopt=menuone,longest

" Toggle line numbers (both normal and insert mode)
noremap <F12> :set invnumber<CR>
inoremap <F12> <C-O>:set invnumber<CR>

" Spelling
" cd ~/.vim/spell/; wget 'http://ftp.vim.org/pub/vim/runtime/spell/pt.utf-8.spl'
"set spelllang=en,pt
set spelllang=en
"silent! set spell
set nospell
hi clear SpellBad
hi Spellbad
    \ term    = underline
    \ cterm   = underline
    \ gui     = underline
    \ ctermbg = NONE
    \ ctermfg = NONE
    \ guibg   = NONE
    \ guifg   = NONE
"    * ]s - Move to next misspelled word after the cursor.
"    * [s - Like ']s' but search backwards, find the misspelled word before the cursor.
"    * z= - For the word under/after the cursor, vim suggest correctly spelled
"    words. The results are sorted, in a list, on similarity to the word being
"    replaced. To chose a word, just hit the word number and press <Enter>, or
"    simply <Enter> to exit the suggested word list.

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  filetype plugin on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

autocmd FileType javascript,scala setlocal
    \ expandtab
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2

autocmd Filetype make setlocal
    \ noexpandtab
    \ tabstop=8
    \ softtabstop=8
    \ shiftwidth=8

autocmd Filetype python setlocal
    \ expandtab
    \ tabstop=4
    \ softtabstop=4
    \ shiftwidth=4

" pylint.vim
"autocmd FileType python compiler pylint

autocmd FileType sh,bash setlocal
    \ textwidth=0

"" adds sha-bang to new *.sh files
"fu! AddShaBang ()
"	if !exists('g:AddShaBang')
"		execute "normal I#!/bin/bash\<C-M>\<C-M>"
"		let g:AddShaBang=1
"	endif
"endfu
"autocmd BufNewFile *.sh call AddShaBang()

" extra whitespace {{{
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=red guibg=red
" The following alternative may be less obtrusive.
"highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
" Try the following if your GUI uses a dark background.
"highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

" Show trailing whitespace:
match ExtraWhitespace /\s\+$/

" Show trailing whitepace and spaces before a tab:
match ExtraWhitespace /\s\+$\| \+\ze\t/

" Show tabs that are not at the start of a line:
match ExtraWhitespace /[^\t]\zs\t\+/

" Show spaces used for indenting (so you use only tabs for indenting).
match ExtraWhitespace /^\t*\zs \+/

match ExtraWhitespace /\s\+\%#\@<!$/
" }}} extra whitespace

" maximize split {{{
" http://vim.wikia.com/wiki/Maximize_window_and_return_to_previous_split_structure
nnoremap <C-W>O :call MaximizeToggle ()<CR>
nnoremap <C-W>o :call MaximizeToggle ()<CR>
nnoremap <C-W><C-O> :call MaximizeToggle ()<CR>

function! MaximizeToggle()
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
endfunction
" }}} maximize split

" {{{ cscope definitions
" http://vimdoc.sourceforge.net/htmldoc/if_cscop.html#if_cscop.txt
if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=0
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
	    cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
	    cs add $CSCOPE_DB
	endif
	set csverb
endif

map <C-_> :cstag <C-R>=expand("<cword>")<CR><CR>

map g<C-]> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
map g<C-\> :cs find 0 <C-R>=expand("<cword>")<CR><CR>

"" Or you may use the following scheme, inspired by Vim/Cscope tutorial from
"" Cscope Home Page http://cscope.sourceforge.net/:
"
"nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
"
"" Using 'CTRL-spacebar' then a search type makes the vim window
"" split horizontally, with search result displayed in
"" the new window.
"
"nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>
"
"" Hitting CTRL-space *twice* before the search type does a vertical
"" split instead of a horizontal one
"
"nmap <C-Space><C-Space>s
"	\:vert scs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>g
"	\:vert scs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>c
"	\:vert scs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>t
"	\:vert scs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>e
"	\:vert scs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>i
"	\:vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-Space><C-Space>d
"	\:vert scs find d <C-R>=expand("<cword>")<CR><CR>
"
" }}} cscope definitions

" for taglist.vim
" (http://vim.sourceforge.net/scripts/script.php?script_id=273)
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>

" Search tag files in parent directories
set tags=tags;
" From ctags.vim
"   let g:ctags_path='/bin/ctags'
"   let g:ctags_title=1	" To show tag name in title bar.
"   let g:ctags_statusline=1	" To show tag name in status line.
"   let generate_tags=1	" To start automatically when a supported
"				" file is opened.

" Mark limit column (81)
autocmd BufWinEnter *.c*,*.h*,*.patch execute 
      \ "set colorcolumn=" . join(range(&textwidth + 1,&textwidth + 1), ',')

" show function name {{{
" retrieve function name
fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  let name = getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
  return name
endfun
map f :call ShowFuncName() <CR>

" show function name on statuline
"set statusline=%f:%{ShowFuncName()}
set statusline=%f:%{ShowFuncName()}\ %m%=\ %l-%v\ %p%%\ %02B
" }}} show function name

" indent kernel coding style {{{
function! LinuxCodingStyle()
  setlocal tabstop=8
  setlocal noexpandtab
  setlocal shiftwidth=8
  setlocal softtabstop=4
  " switch/case indentation
  setlocal cinoptions=:0,l1,t0,g0,(0
  let b:codingstyle = "LinuxCodingStyle"
endfu
" }}}

" indent gnu coding style {{{
function! GNUCodingStyle()
  setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
  setlocal shiftwidth=2
  setlocal tabstop=8
  setlocal softtabstop=2
  setlocal noexpandtab
  setlocal textwidth=80
  setlocal comments=sl:/*,mb:\ ,elx:*/
  let b:codingstyle = "GNUCodingStyle"
endfu
" }}}

" use GNUCodingStyle by default
"autocmd FileType C call GNUCodingStyle()
autocmd BufNewFile,BufRead *.c*,*.h*,*.patch  call GNUCodingStyle()

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

" Stay in visual mode when shifting
vnoremap < <gv
vnoremap > >gv

" Space works as PageDown in command mode
noremap <Space> <PageDown>

