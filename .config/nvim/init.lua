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
				-- TODO: Remove lazy.nvim specifics from main config
				lazy = false,
				priority=1000,
				'tanvirtin/monokai.nvim'
			},
			{
				"folke/neodev.nvim"
			},
			{
				"hrsh7th/nvim-cmp",
				-- TODO: Abstract out below in this table
				config = function()
					local cmp = require('cmp')
					cmp.setup({
						sources = cmp.config.sources({
							{ name = 'nvim_lsp' },
						})
					})
				end,
				event = "InsertEnter",
				dependencies = {
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-buffer",
				},
			},
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
