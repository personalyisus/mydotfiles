call plug#begin('~/.vim/plugged')
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'leafgarland/typescript-vim' "typescript highlighting
Plug 'machakann/vim-highlightedyank' " highlight text when yanking
Plug 'vim-airline/vim-airline' "pretty bottom bar
Plug 'vim-airline/vim-airline-themes'
Plug 'haya14busa/incsearch.vim' " word finder inside file
Plug 'tpope/vim-fugitive' " git info
Plug 'tommcdo/vim-fugitive-blame-ext' " git blame line by line on a new buffer
Plug 'nvim-lua/plenary.nvim' " file finder dependency
Plug 'nvim-telescope/telescope.nvim' " file finder
Plug 'neovim/nvim-lspconfig' "language server
Plug 'dense-analysis/ale' "prettier and linting
Plug 'mhartington/oceanic-next' " alright theme
Plug 'jiangmiao/auto-pairs' "autocompletion of brackets

Plug 'phaazon/hop.nvim' " FUCKING MAGIC I'M TELLING YOU

" LSP autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
"END of LSP autocomplete
call plug#end()
" Important!!
if has('termguicolors')
  set termguicolors
endif

syntax on
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
set cursorline
colorscheme OceanicNext
let g:airline_theme='oceanicnext'

set number " activate numbers in gutter
set relativenumber " activate relative numbers in gutter
set tabstop=2 shiftwidth=2 expandtab " use two spaces instead of longer tabs
set noswapfile
set nowrap
set scrolloff=8
set nohls
" Remappings
map <Space> <Leader>

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <C-l> :tabn<CR>
nnoremap <C-h> :tabp<CR>
nnoremap <C-n> :tabnew<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>
" Fucking Magic I tell you
nnoremap <leader>gg :HopWord<CR>
:imap jj <Esc>

" incsearch mappings
" replace forward and backard search
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)


let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 1
let g:netrw_altv = 1
let g:netrw_winsize = 25

" netrw mappings
nnoremap <leader>t :Vexplore<CR>

"telescope mappings Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>s :Git blame<CR>

"mappings to allow for moving lines and blocks up and down

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" No annoying sound on errors
set noerrorbells
set novisualbell
set visualbell t_vb=
set tm=500


let g:ale_fixers = {
\   '*': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\}

" let g:coq_settings = { "keymap.jump_to_mark":"<c-\>", 'auto_start': 'shut-up' }
let g:ale_fix_on_save = 1
lua << EOF
 require'lspconfig'.tsserver.setup{}
 require'hop'.setup()
EOF

" Autocomplete LSP settings
set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

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
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig').tsserver.setup {
    capabilities = capabilities
  }
EOF