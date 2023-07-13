vim.wo.number = true

local nmap = function(keys, cmd)
    vim.keymap.set('n', keys, cmd, {noremap = true, silent = true})
end

nmap('<Tab>', '<cmd>BufferNext<cr>')
nmap('<S-Tab>', '<cmd>BufferPrevious<cr>')
nmap('<C-t>', '<cmd>NvimTreeToggle<cr>')

-- START LSP

local cmp = require 'cmp'
local lspconfig = require('lspconfig')
local servers = {tsserver = {}, pylsp = {}, lua_ls = {}, rnix = {}}
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
cmp.setup({
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({select = true})
    }),
    sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'luasnip'}},
                                 {{name = 'buffer'}})
})

for server, settings in pairs(servers) do
    lspconfig[server].setup {
        settings = settings,
        capabilities = cmp_capabilities
    }
end

-- END LSP

require("autoclose").setup()

require("nvim-tree").setup()

require("catppuccin").setup({flavour = "mocha", transparent_background = true})
vim.cmd.colorscheme "catppuccin"
