-- LSP Config
vim.lsp.config = {
	go_lsp = {
		cmd = { "gopls" },
		filetypes = { "go" }
	},
}

vim.lsp.enable("go_lsp")

-- LSP Keybinds
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to Definition" })
