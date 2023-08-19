require "core" -- Load OmnidApps NeoViM core

---@type UserConfig
local userConfig = {
	lsp = {
		languages = {
			"lua",
		}
	},
	packages = {
		manager = "lazy.nvim",
		installed = {
			{
				lazy = true,
				"neovim/nvim-lspconfig",
			},
			{
				lazy = false,
				priority=1000,
				'tanvirtin/monokai.nvim'
			},
			{
				"folke/neodev.nvim"
			}
		},
	},
	options = {
		linum = {
			Options.Linum.Normal,
			Options.Linum.Relative
		}
	}
}

Core.Setup(userConfig)
