require("nvchad.configs.lspconfig").defaults()

local servers = { "clangd" }
vim.lsp.enable(servers)

