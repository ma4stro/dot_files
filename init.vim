"----------------------------
" nvim basic config
set number
set relativenumber
set rnu
" tab =~ 4 spaces
set tabstop=4 
set shiftwidth=4

" Enables cursor line position tracking:
set cursorline

" prevent displaying 2 times mode
set noshowmode

" open file from the sime position
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

"----------------------------------
" plugins

call plug#begin('~/.vim/plugged')
"   " Initialize plugin system
Plug 'rafamadriz/neon'
Plug 'nvim-lualine/lualine.nvim'
Plug 'preservim/nerdcommenter'
Plug 'dominikduda/vim_current_word'
Plug 'christoomey/vim-system-copy' 
Plug 'mileszs/ack.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
" autocompletion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'shime/vim-livedown'
"search:
Plug 'PeterRincker/vim-searchlight' 
" auto pair
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'steelsojka/pears.nvim' "http://neovimcraft.com/plugin/steelsojka/pears.nvim/index.html
call plug#end()

let g:neon_style='my_style'
colorscheme neon

"search highlight
highlight link Searchlight CurrentSearch 

" autocompletion
set completeopt=menu,menuone,noselect,noinsert

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
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
      ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    }),
    documentation = {
      border = "rounded",
      winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
      max_width = 50,
      min_width = 50,
      max_height = math.floor(vim.o.lines * 0.4),
      min_height = 3,
    }
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
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
  --Enable (broadcasting) snippet capability for completion
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  require('lspconfig')['html'].setup {
    capabilities = capabilities
  }
  -- go
  require'lspconfig'.gopls.setup{}
  -- bash
  require'lspconfig'.bashls.setup{}
  -- c
EOF

if executable('cquery')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'cquery',
      \ 'cmd': {server_info->['cquery']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': { 'cacheDirectory': '/tmp/cquery/cache' },
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif


highlight clear Pmenu
highlight clear PmenuSel
highlight Pmenu guibg=#2f2f2f guifg=#87ceeb 
highlight PmenuSel guibg=#00afff guifg=#222223 gui=bold



" autopair
lua << EOF
require "pears".setup()
EOF

" airline
lua << EOF
require('lualine').setup {
  options = {
    theme = 'my_airline',
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 
	    { 'mode', separator = { left = '' }, right_padding = 2 },
    }, 
    lualine_b = { '%F', 'branch' },
    lualine_c = {'diagnostics'},
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}
EOF


" surround
lua << END
require"surround".setup {
  context_offset = 100,
  load_autogroups = false,
  mappings_style = "sandwich",
  map_insert_mode = true,
  quotes = {"'", '"'},
  brackets = {"(", '{', '['},
  pairs = {
    nestable = {{"(", ")"}, {"[", "]"}, {"{", "}"}},
    linear = {{"'", "'"}, {"`", "`"}, {'"', '"'}}
  },
  prefix = "s",
}
END

" underword setup
" Twins of word under cursor:
let g:vim_current_word#highlight_twins = 1
" The word under cursor:
let g:vim_current_word#highlight_current_word = 0
hi CurrentWordTwins guibg=#344134

" nerdtree
nnoremap <leader>n :NERDTreeToggle<CR>
hi NERDTreeDir guifg=#ffaf00  


"----------------------------------------------------
" Shortucuts

" Quickly insert an empty new line without entering insert mode
" / + o
" / + O
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>
" Clear highlighting on space in normal mode
map <Space> :noh<cr>


"---------------------------------
" Functions
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" nerdcommenter toggle: \ c <space>
