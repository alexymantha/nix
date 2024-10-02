vim.g.mapleader = " "

-- Text Movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Window Movement
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Resizing
vim.keymap.set('n', '<C-<>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C->>', ':vertical resize +2<CR>')

-- Quickfix
vim.keymap.set('n', '<Leader>qo', ':copen<CR>')
vim.keymap.set('n', '<Leader>j', ':cnext<CR>zz')
vim.keymap.set('n', '<Leader>k', ':cprev<CR>zz')

-- Clipboard
vim.keymap.set("v", "<Leader>y", '"+y', { noremap = true })
vim.keymap.set("n", "<Leader>y", '"+y', { noremap = true })
vim.keymap.set("n", "<Leader>Y", '"+yg_', { noremap = true })

vim.keymap.set("v", "<Leader>p", '"+p', { noremap = true })
vim.keymap.set("v", "<Leader>P", '"+P', { noremap = true })
vim.keymap.set("n", "<Leader>p", '"+p', { noremap = true })
vim.keymap.set("n", "<Leader>P", '"+P', { noremap = true })

vim.keymap.set("v", "p", '"0p', { noremap = true })

vim.keymap.set("i", "<C-C>", "<ESC>", { noremap = true })

-- Disable Arrow Keys
for _, mode in pairs({ "n", "i", "v", "x" }) do
	for _, key in pairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
		vim.keymap.set(mode, key, "<nop>")
	end
end
