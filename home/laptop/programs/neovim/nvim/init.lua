-- START GLOBAL CONFIG
vim.wo.number = true   -- show numbers
vim.o.scrolloff = 15   -- scrll if n lines left
vim.o.hlsearch = false -- highlight search
vim.o.updatetime = 500
vim.o.autoread = true

vim.g.mapleader = " "                                               -- leader space
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

-- END GLOBAL CONFIG

-- Format on CursorHold

local filetypes = { "*.ts", "*.tsx", "*.prisma", "*.js", "*.jsx", "*.html", "*.css", "*.json", "*.yaml", "*.lua" }

local async = require("plenary.async")

local format_file = function()
	vim.cmd("silent !prettier '%' --write")
	vim.cmd("checktime")
end
local async_format = async.void(format_file)
vim.api.nvim_create_autocmd("CursorHold", {
	callback = async_format,
	pattern = filetypes
})


-- START LSP

local cmp = require("cmp")
local lspconfig = require("lspconfig")
local servers = {
	tsserver = {
		settings = {
			completions = {
				completeFunctionCalls = true,
			},
		},
	},
	pylsp = {},
	lua_ls = {},
	rnix = {},
	gopls = {},
	tailwindcss = {},
	prismals = {},
}
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function(client, bufnr)
	nmap("<leader>ca", vim.lsp.buf.code_action)
	nmap("<leader>lr", vim.lsp.buf.rename)
	nmap("gd", vim.lsp.buf.definition)
	nmap("<leader>l", function()
		vim.lsp.buf.format()
	end)
	nmap("K", vim.lsp.buf.hover)
	nmap("gr", require("telescope.builtin").lsp_references)
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			vim.lsp.buf.document_highlight()
		end,
		pattern = filetypes
	})
	vim.api.nvim_create_autocmd("CursorMoved", {
		callback = function()
			vim.lsp.buf.clear_references()
		end,
		pattern = filetypes
	})
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
		settings = cfg.settings,
		capabilities = cmp_capabilities,
		on_attach = on_attach,
	})
end

-- END LSP

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

require("nightfox").setup({ options = { transparent = true } })
vim.cmd.colorscheme("carbonfox")
