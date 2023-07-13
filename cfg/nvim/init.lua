vim.wo.number = true

local nmap = function(keys, cmd) vim.keymap.set('n', keys, cmd, {noremap = true, silent = true}) end

nmap('<Tab>','<cmd>BufferNext<cr>')
nmap('<S-Tab>','<cmd>BufferPrevious<cr>')

require("nvim-tree").setup()
nmap('<C-t>', '<cmd>NvimTreeToggle<cr>')

require("catppuccin").setup({flavour = "mocha", transparent_background = true})
vim.cmd.colorscheme "catppuccin"
