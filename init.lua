--[[
--========== One-line setup for copy-pasting ==========
-- You can copy everything inside '' and use it in the command mode

echo 'set nocompatible ruler laststatus=2 showcmd showmode number incsearch ignorecase smartcase hlsearch shiftwidth=4 tabstop=4 expandtab smarttab autoindent scrolloff=3 wildmenu wildmode=list:longest,full cursorline | command C :let @/ = ""' > ~/.vimrc
--]]

vim.opt.shortmess  = vim.opt.shortmess + 'I' -- disable intro message on vim open

vim.opt.number     = true   -- show line numbers
vim.opt.cursorline = true   -- highlight the line with the cursor
vim.opt.scrolloff  = 3      -- keep the cursor at least 3 lines from the edge of the screen
vim.opt.signcolumn = 'yes'  -- always show sign column

vim.opt.ignorecase = true -- ignore case...
vim.opt.smartcase  = true -- ...unless search string contains an uppercase character

vim.opt.wildmode   = 'list:longest,full'

vim.opt.pumheight  = 10 -- limit the number of popup menu options

-- Formatting
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true -- use spaces instead of tabs

-- Mark tabs with » and trailing spaces with °
vim.cmd [[ set list listchars=tab:»\ ,trail:° ]]

-- Disable line numbers in Terminal
vim.cmd [[
autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=auto
]]

vim.cmd [[ autocmd FileType nerdtree setlocal signcolumn=auto ]]

-- ========== Commands ==========

-- Clear search
vim.cmd [[ command! C :let @/ = "" ]]

-- Copy full file path to clipboard
vim.cmd [[ command! FilePathYank :let @+ = expand("%:p") ]]

-- I sometipes type :W instead of :w
vim.cmd [[ command! -bang -nargs=* W w<bang> <args> ]]

-- Trim trailing spaces
vim.cmd [[ command! TrimSpaces :%s/\s\+$//e ]]

-- Create a new terminal vsplit 120 columns wide
vim.cmd [[ command! TT :lua setupTerminal() ]]
function setupTerminal()
  vim.cmd [[ vsplit ]]
  vim.cmd [[ wincmd l ]]
  vim.cmd [[ vert res 120 ]]
  vim.cmd [[ terminal ]]
  vim.cmd [[ wincmd h ]]
end

-- ========== Keymaps ==========

-- (vim-airline) Shortcuts to switch to next/previous buffer
vim.api.nvim_set_keymap('n', '<leader><S-Tab>', '<Plug>AirlineSelectPrevTab', {})
vim.api.nvim_set_keymap('n', '<leader><Tab>', '<Plug>AirlineSelectNextTab', {})

-- Force delete the current buffer
vim.api.nvim_set_keymap('n', '<leader>W', '<cmd>bd!<CR>', {noremap=true, silent=true})

-- Close the current tab
vim.api.nvim_set_keymap('n', '<leader>tw', ':tabclose<CR>', {noremap=true, silent=true})
-- Close the current normal buffer without closing the window
vim.api.nvim_set_keymap('n', '<leader>w', ':lua closeBufferIfNormal()<CR>', {noremap=true, silent=true})
function closeBufferIfNormal()
  -- Only operate on normal buffers
  if vim.api.nvim_buf_get_option(0, 'buftype') ~= '' then
    return
  end
  local curBuf = vim.api.nvim_get_current_buf()
  local allBufs = vim.api.nvim_list_bufs()

  -- Find the previous buffer. If not available, find next
  local foundCur = false
  local prevNormal = nil
  for b in pairs(allBufs) do
    if b == curBuf then
      foundCur = true
      -- If we already found a buffer, stop the search
      if prevNormal ~= nil then
        break
      end
    -- Only consider normal and loaded buffers
    elseif vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_option(b, 'buftype') == '' then
      prevNormal = b
      -- If we have already seen the active buffer, then this one is the next
      if foundCur then
        break
      end
    end
  end

  -- If we found a suitable buffer to switch to, use it
  if prevNormal ~= nil then
    vim.api.nvim_set_current_buf(prevNormal)
    vim.cmd('bdelete' .. curBuf)
  -- If there is only one buffer, switch to a new buffer and close it.
  -- But only if it is not an unnamed buffer - otherwise there's no use closing
  -- it - it will either do nothing or close the split and we don't want that.
  elseif vim.api.nvim_buf_get_name(0) ~= '' then
    vim.cmd [[ enew ]]
    vim.cmd('bdelete' .. curBuf)
  end
end

-- Stop using those pesky arrow keys
vim.api.nvim_set_keymap('n', '<Up>',    '', {})
vim.api.nvim_set_keymap('n', '<Down>',  '', {})
vim.api.nvim_set_keymap('n', '<Left>',  '', {})
vim.api.nvim_set_keymap('n', '<Right>', '', {})

-- Use `ALT+{h,j,k,l}` to navigate windows from any mode
vim.api.nvim_set_keymap('t', '<A-h>', '<C-\\><C-N><C-w>h', {noremap=true})
vim.api.nvim_set_keymap('t', '<A-j>', '<C-\\><C-N><C-w>j', {noremap=true})
vim.api.nvim_set_keymap('t', '<A-k>', '<C-\\><C-N><C-w>k', {noremap=true})
vim.api.nvim_set_keymap('t', '<A-l>', '<C-\\><C-N><C-w>l', {noremap=true})
vim.api.nvim_set_keymap('i', '<A-h>', '<C-\\><C-N><C-w>h', {noremap=true})
vim.api.nvim_set_keymap('i', '<A-j>', '<C-\\><C-N><C-w>j', {noremap=true})
vim.api.nvim_set_keymap('i', '<A-k>', '<C-\\><C-N><C-w>k', {noremap=true})
vim.api.nvim_set_keymap('i', '<A-l>', '<C-\\><C-N><C-w>l', {noremap=true})
vim.api.nvim_set_keymap('n', '<A-h>', '<C-w>h', {noremap=true})
vim.api.nvim_set_keymap('n', '<A-j>', '<C-w>j', {noremap=true})
vim.api.nvim_set_keymap('n', '<A-k>', '<C-w>k', {noremap=true})
vim.api.nvim_set_keymap('n', '<A-l>', '<C-w>l', {noremap=true})

-- Disable ex mode
vim.api.nvim_set_keymap('n', 'Q', '', {})

-- (fzf) Start searching for files
vim.api.nvim_set_keymap('n', '<c-p>', ':FZF<CR>', {})
-- (fzf) Start searching in command history
vim.api.nvim_set_keymap('n', 'q:', ':History:<CR>', {})
-- (fzf) Start searching in buffers
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<CR>', {})
-- (fzf) Find the word under the cursor either as a substring match (f) or a whole
-- word match (F)
vim.api.nvim_set_keymap('n', '<leader>f', [[:exec "Rg ".expand('<cword>')<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>F', [[:exec "Rgw ".expand('<cword>')<CR>]], {})

-- (NERDTree) Open the file tree on the current file
vim.api.nvim_set_keymap('n', '<Leader>v', ':NERDTreeFind<CR>', {silent=true})

-- (vim-vsnip) Jump between snippet parts
vim.cmd [[
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]]

-- ========== Plugins ==========
-- I should switch to packer.nvim but haven't gotten around to it
vim.cmd [[
call plug#begin('~/.local/share/nvim/plugged')

" Status and tabline
Plug 'vim-airline/vim-airline'

" File searcher
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Use FZF for LSP-based symbol search
Plug 'gfanto/fzf-lsp.nvim'

" Colorscheme
Plug 'tanvirtin/monokai.nvim'

" Show VCS diffs on files in the sign column
Plug 'mhinz/vim-signify'

" Git wrapper
Plug 'tpope/vim-fugitive'

" A collection of language packs
Plug 'sheerun/vim-polyglot'

" File tree viewer
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" A collection of common configurations for Neovim's built-in language server client.
Plug 'neovim/nvim-lspconfig'

" Completion engine
Plug 'hrsh7th/nvim-cmp'
" Source for LSP
Plug 'hrsh7th/cmp-nvim-lsp'
" Source for buffer words
Plug 'hrsh7th/cmp-buffer'
" Source for filesystem paths
Plug 'hrsh7th/cmp-path'
" Source for vim's command line
Plug 'hrsh7th/cmp-cmdline'

" Snippet engine
Plug 'hrsh7th/vim-vsnip'
" Source for vsnip
Plug 'hrsh7th/cmp-vsnip'

Plug 'ray-x/lsp_signature.nvim'

" Adds vertical indent lines
Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()
]]

-- ========== Plugin configs ==========
-- Config for vim-airline
vim.g['airline#extensions#tabline#enabled'] = 1 -- enable tabs for buffers

-- Config for colorschemes
vim.opt.termguicolors = true
vim.cmd [[ colorscheme monokai ]]
vim.cmd [[ highlight! CursorLine guibg=#333842 ]]

-- Config for NERDTree
-- Open NERDTree on vim start if no files were specified
vim.cmd [[
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd l | endif
]]
vim.g.NERDTreeShowHidden = 1

-- Use simplified characters in NERDTree when we are under ssh
if os.getenv('SSH_CONNECTION') ~= nil then
  vim.g.NERDTreeDirArrowExpandable = ' '
  vim.g.NERDTreeDirArrowCollapsible = ' '
  vim.g.NERDTreeGitStatusIndicatorMapCustom = {
    Modified  = '*',
    Staged    = '+',
    Untracked = '!',
    Renamed   = '»',
    Unmerged  = '=',
    Deleted   = '×',
    Dirty     = '~',
    Clean     = 'ᴠ',
    Unknown   = '?'
  }
end

-- Config for FZF
-- Add Rgw command for matching whole words
vim.cmd [[
command! -bang -nargs=* Rgw call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case --word-regexp -- ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)
]]

-- Config for indent-blankline
-- Do not show indent in terminal and file tree
require('indent_blankline').setup {
    buftype_exclude = {'terminal'},
    filetype_exclude = {'nerdtree'}
}

-- Config for vim-signify
-- Custom signs
vim.g.signify_sign_add               = '+'
vim.g.signify_sign_delete            = '-'
vim.g.signify_sign_delete_first_line = '‾'
vim.g.signify_sign_change            = '~'
vim.g.signify_sign_change_delete     = vim.g.signify_sign_change .. vim.g.signify_sign_delete_first_line
-- Don't show the number of deleted lines
vim.g.signify_sign_show_count = 0


-- ========== Lua utils ==========

-- Split the path into directory, filename, and extension
function splitFilepath(filepath)
  base_dir, name, ext = filepath:match("(.-)([^\\/]-)%.?([^%.\\/]*)$")
  return base_dir, name, ext
end

-- Makes a relative path of current buf to cwd
function makeRelPath()
  filepath = vim.api.nvim_buf_get_name(0)
  folder = vim.fn.getcwd()
  if folder[-1] ~= '/' then
    folder = folder .. '/'
  end
  filepath = filepath:gsub(folder, '')
  return filepath
end

-- ========== LSP-related stuff ==========

require'fzf_lsp'.setup()

-- Show completion even when there's only one option and don't select by
-- default.
vim.opt.completeopt = 'menuone,noselect'

function findMatchingFile(name, base_dir, endings, max_up_lvls, folder_names_to_check, add_dot)
  for lvl=1,max_up_lvls do
    for _, folder_name in ipairs(folder_names_to_check) do
      for _, ending in ipairs(endings) do
        folder_name = folder_name ~= '' and folder_name .. '/' or ''
        fname = base_dir .. string.rep('../', lvl-1) .. folder_name .. name .. (add_dot and '.' or '') .. ending
        if vim.fn.filereadable(fname) ~= 0 then
          return fname
        end
      end
    end
  end
  return nil
end

function switchSourceHeaderFallback()
  -- Src extensions
  src_exts = { 'cc', 'c', 'cpp', 'cxx' }
  -- Header extensions
  hdr_exts = { 'h', 'hpp' }

  -- Folder names to check
  folder_names_to_check = { '', 'inc', 'include', 'src', 'source' }

  -- Max levels to go up to find a folder
  max_lvls = 3

  filepath = vim.api.nvim_buf_get_name(0)
  base_dir, name, ext = splitFilepath(filepath)

  is_source = nil
  for _, src_ext in ipairs(src_exts) do
    if ext == src_ext then
      is_source = true
      break
    end
  end

  for _, hdr_ext in ipairs(hdr_exts) do
    if ext == hdr_ext then
      is_source = false
      break
    end
  end

  if is_source == nil then
    return
  end

  new_file = findMatchingFile(name,
    base_dir,
    is_source and hdr_exts or src_exts,
    max_lvls,
    folder_names_to_check,
    true)

  if new_file ~= nil then
    vim.cmd('edit ' .. new_file)
  else
    print('No source/header found')
  end
end

vim.cmd [[ command! SwitchSourceHeader :lua switchSourceHeaderFallback() ]]

local cmp = require('cmp')
local cmp_buffer = require('cmp_buffer')

cmp.setup {
  -- Specifies a snippet engine
  snippet = {
    expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }
    }, {
      { name = 'buffer' },
    }),
  sorting = {
    comparators = {
      function(...) return cmp_buffer:compare_locality(...) end,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    }
  }
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local nvim_lsp = require('lspconfig')
local configs = require('lspconfig.configs')

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>Diagnostics<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  require 'lsp_signature'.on_attach({
    bind = true,
    hint_prefix = ''
  })

  vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr")
  vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

  -- Key mappings.
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  if vim.fn.exists('ClangdSwitchSourceHeader') ~= 0 then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>h', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
  else
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>h', '<cmd>lua switchSourceHeaderFallback()<CR>', opts)
  end
end


-- LSP setup.
  nvim_lsp['pyright'].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities
  }
  nvim_lsp['clangd'].setup {
    cmd = { 'clangd', '--background-index', '--compile-commands-dir=' .. vim.fn.getcwd() },
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities
  }

