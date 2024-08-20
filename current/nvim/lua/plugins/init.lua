return 
{
	{
		"chipsenkbeil/org-roam.nvim",
		tag = "0.1.0",
		config = function()
			require("org-roam").setup({
				directory = "~/orgfiles"
			})
		end
	},
	{
		'nvim-orgmode/orgmode',
		event = 'VeryLazy',
		ft = { 'org' },
		config = function()
			-- Setup orgmode
			require('orgmode').setup({
				org_agenda_files = '~/orgfiles/**/*',
				org_default_notes_file = '~/orgfiles/refile.org',
				org_capture_templates = {
					j = {
						description = 'Journal',
						template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
					}
				}
			})
			-- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
			-- add ~org~ to ignore_install
			-- require('nvim-treesitter.configs').setup({
			--   ensure_installed = 'all',
			--   ignore_install = { 'org' },
			-- })
		end,
	},
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' }
	}
}
