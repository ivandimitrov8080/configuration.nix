vim.wo.number = true -- show numbers
vim.o.scrolloff = 15 -- scrll if n lines left
vim.o.hlsearch = false -- highlight search

vim.g.mapleader = " " -- leader space
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true }) -- nop leader

local nmap = function(keys, cmd)
	vim.keymap.set("n", keys, cmd, { noremap = true, silent = true })
end

nmap("<Tab>", "<cmd>BufferNext<cr>")
nmap("<S-Tab>", "<cmd>BufferPrevious<cr>")
nmap("<leader>x", "<cmd>BufferClose<cr>")

nmap("<C-t>", "<cmd>NvimTreeToggle<cr>")

nmap("<leader>ff", require("telescope.builtin").find_files)
nmap("<leader>fw", require("telescope.builtin").live_grep)

nmap('<leader>e', vim.diagnostic.open_float)

-- START LSP

local cmp = require("cmp")
local lspconfig = require("lspconfig")
local servers = { tsserver = {}, pylsp = {}, lua_ls = {}, rnix = {} }
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function(_, bufnr)
	nmap('<leader>ca', vim.lsp.buf.code_action)
	nmap("K", vim.lsp.buf.hover)
	nmap("gr", require("telescope.builtin").lsp_references)
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

for server, settings in pairs(servers) do
	lspconfig[server].setup({
		settings = settings,
		capabilities = cmp_capabilities,
		on_attach = on_attach,
	})
end

-- END LSP

require("autoclose").setup()

require("nvim-tree").setup()

require("nightfox").setup({ options = { transparent = true } })
vim.cmd.colorscheme("nightfox")
