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
			"neovim/nvim-lspconfig",
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
