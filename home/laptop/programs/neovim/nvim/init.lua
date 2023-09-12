-- START GLOBAL CONFIG
vim.wo.number = true   -- show numbers
vim.o.scrolloff = 15   -- scrll if n lines left
vim.o.hlsearch = false -- highlight search
vim.o.updatetime = 20
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

-- START LSP

local highlight_filetypes = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.html", "*.lua" }
local prettier_filetypes = { "%.ts$", "%.tsx$", "%.js$", "%.jsx$", "%.html$", "%.json$", "%.css$" }

local function matches_filetypes(file_path, filetypes)
	for _, pattern in ipairs(filetypes) do
		if file_path:match(pattern) then
			return true
		end
	end
	return false
end


local function str_to_table(str)
	local t = {}
	for line in string.gmatch(str, "([^\n]+)") do
		table.insert(t, line)
	end
	return t
end

local function prettier_format(file_path, content)
	local prettier_command = string.format("prettier --stdin-filepath '%s' <<< '%s'", file_path, content)
	local output = io.popen(prettier_command, "r")
	local result = output:read("*a")
	output:close()
	return result
end

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
	hls = {},
	bashls = {},
}
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function(client, bufnr)
	local format_buffer = function()
		local file_path = vim.api.nvim_buf_get_name(bufnr)
		if (matches_filetypes(file_path, prettier_filetypes)) then
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local content = table.concat(lines, "\n")
			local result = prettier_format(file_path, content)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, str_to_table(result))
		else
			vim.lsp.buf.format()
		end
	end

	nmap("<leader>ca", vim.lsp.buf.code_action)
	nmap("<leader>lr", vim.lsp.buf.rename)
	nmap("gd", vim.lsp.buf.definition)
	nmap("<leader>lf", function()
		format_buffer()
	end)
	nmap("K", vim.lsp.buf.hover)
	nmap("gr", require("telescope.builtin").lsp_references)
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			vim.lsp.buf.document_highlight()
		end,
		pattern = highlight_filetypes
	})
	vim.api.nvim_create_autocmd("CursorMoved", {
		callback = function()
			vim.lsp.buf.clear_references()
		end,
		pattern = highlight_filetypes
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
