vim.wo.number = true
vim.o.scrolloff = 15
vim.o.hlsearch = false
vim.o.updatetime = 20
vim.o.autoread = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true }) -- nop leader

local nmap = function(keys, cmd)
    vim.keymap.set("n", keys, cmd, { noremap = true, silent = true })
end
local vmap = function(keys, cmd)
    vim.keymap.set("v", keys, cmd, { noremap = true, silent = true })
end
local tmap = function(keys, cmd)
    vim.keymap.set("t", keys, cmd, { noremap = true, silent = true })
end

nmap("<leader>/", require("Comment.api").toggle.linewise.current)
vmap("<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

nmap("<Tab>", "<cmd>BufferNext<cr>")
nmap("<S-Tab>", "<cmd>BufferPrevious<cr>")
nmap("<leader>x", "<cmd>BufferClose<cr>")

nmap("<leader>h", "<cmd>ToggleTerm<cr>")
tmap("<leader>h", "<cmd>ToggleTerm<cr>")

nmap("<leader>r", "<cmd>!%:p<cr>")

nmap("<leader>ff", require("telescope.builtin").find_files)
nmap("<leader>fw", require("telescope.builtin").live_grep)
nmap("<leader>e", vim.diagnostic.open_float)

local cmp = require("cmp")
local lspconfig = require("lspconfig")
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function(client, bufnr)
    nmap("<leader>ca", vim.lsp.buf.code_action)
    nmap("<leader>lr", vim.lsp.buf.rename)
    nmap("gd", vim.lsp.buf.definition)
    nmap("<leader>lf", function()
        vim.lsp.buf.format()
    end)
    nmap("K", vim.lsp.buf.hover)
    nmap("gr", require("telescope.builtin").lsp_references)
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
        })
    end
end
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }, { { name = "buffer" } }),
})

for server, cfg in pairs(servers) do
    lspconfig[server].setup({
        cmd = cfg.cmd,
        settings = cfg.settings,
        capabilities = cmp_capabilities,
        on_attach = on_attach,
    })
end


require 'nvim-treesitter.configs'.setup {
    autotag = {
        enable = true,
    }
}

require("Comment").setup()
require("toggleterm").setup()
require("autoclose").setup()
require("gitsigns").setup()
require("nvim-surround").setup()
require("telescope").setup {
    defaults = {
        file_ignore_patterns = { "hosts" },
    }
}

require("lualine").setup({
    options = {
        theme = "catppuccin"
    }
})
require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        telescope = {
            enabled = true,
        },
        markdown = true
    },
})

vim.cmd.colorscheme("catppuccin")
