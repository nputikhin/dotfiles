set nocompatible

"========== Code formatting ==========
set list listchars=tab:»\ ,trail:° " mark tabs with » and spaces with °
set shiftwidth=4 tabstop=4 " set tab size to 4
set expandtab    " replace tabs with shaces
 
" Highlight textwidth margin
set textwidth=80
set colorcolumn=+1
highlight ColorColumn ctermbg=gray guibg=gray17
 
"========== General settings ==========
filetype plugin indent on " enable filetype detection, loading of appropriate plugin and indentation
syntax on
 
set ruler        " show position of the cursor
set laststatus=2 " show status line in every window
set showcmd      " show current command
set showmode     " show current mode
set number       " show line numbers
set shortmess+=I " disable intro message on vim open
set backspace=indent,eol,start " allow backspace over autoindent, line breaks and start of the insert
set autoindent   " indent new lane based on indent in current line
set smarttab     " use 'shiftwidth' for indent
set cursorline   " highlight the line with the cursor
set scrolloff=3  " keep the cursor at least 3 lines from the edge of the screen
 
" Search settings:
set ignorecase " ignore case...
set smartcase  " ...unless search string contains an uppercase character
set incsearch  " incremental search (search as you enter)
set hlsearch   " highlight matches in file
 
" GUI settings
set guioptions-=T " disable toolbar
set guioptions-=m " disable menu bar
 
" Enable enhanced command-line completion
set wildmenu
set wildmode=list:longest,full
 
"========== Custom mappings ==========
" Clear search
command C :let @/ = ""
 
" Copy full file path to clipboard
command FilePathYank :let @+ = expand("%:p")
 
" I sometipes type :W instead of :w
command -bang -nargs=* W w<bang> <args>
 
" (vim-airline) Shortcuts to switch to next/previous buffer
nmap <leader><S-Tab> <Plug>AirlineSelectPrevTab
nmap <leader><Tab> <Plug>AirlineSelectNextTab
 
nnoremap <silent> <leader>W :bd!<CR>
" Delete the buffer without closing the window by switching to previous buffer
" and closing the current one
nnoremap <silent> <leader>w :call CloseBufferIfNormal()<CR>
 
function CloseBufferIfNormal()
  if getbufvar(bufnr("%"), '&buftype') == ""
    bprev " Switch to previous buffer
    try
      bdelete # " Close the buffer we've switched from
    catch /E516/ " Maybe there is only one buffer
      bdelete
    endtry
    if getbufvar(bufnr("%"), '&buftype') != ""
      bprev
    endif
  endif
endfunction
 
" Stop using those pesky arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
 
" Use `ALT+{h,j,k,l}` to navigate windows from any mode
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
 
" (fzf) Start searching for files
nnoremap <c-p> :FZF<CR>
" (fzf) Start searching in command history
nnoremap q: :History:<CR>
" (fzf) Find the word under the cursor either as a substring match (f) or a whole
" word match (F)
nnoremap <leader>f :exec "Ag ".expand('<cword>')<CR>
nnoremap <leader>F :exec "Agw ".expand('<cword>')<CR>
 
" (NERDTree) Open the file tree on the current file
nnoremap <silent> <Leader>v :NERDTreeFind<CR>
 
"========== Plugins ==========
call plug#begin('~/.local/share/nvim/plugged')
 
" Status and tabline
Plug 'vim-airline/vim-airline'
 
" File searcher
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
 
" Colorscheme
Plug 'crusoexia/vim-monokai'
 
" Show Git diffs on files
Plug 'airblade/vim-gitgutter'
 
" Git wrapper
Plug 'tpope/vim-fugitive'
 
" A collection of language packs
Plug 'sheerun/vim-polyglot'
 
" File tree viewer
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
 
call plug#end()
 
" Config for vim-airline
let g:airline#extensions#tabline#enabled = 1 " enable tabs for buffers
 
" Config for colorschemes
set termguicolors
colorscheme monokai
 
" Config for NERDTree
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTreeVCS | wincmd l | endif " open NERDTree on vim start if no files were specified
let NERDTreeShowHidden=1

" Config for FZF
" Add Agw command for matching whole words
command! -bang -nargs=* Agw call fzf#vim#ag(<q-args>, '--word-regexp', <bang>0)
