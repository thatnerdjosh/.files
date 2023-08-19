--- @class VimSetting
--- @field key string
--- @field value any

Options = {}

-- TODO: See if there is some way to use something like this instead: @type table<string, VimSetting>
Options.Linum = {
	----- @type VimSetting
	Relative = {
		key = "relativenumber",
		value = true
	},
	----- @type VimSetting
	Normal = {
		key = "number",
		value = true
	}
}

---@class VimOptions
---@field linum table<VimSetting>
Options.DefaultConfig = {
	linum = {}
}

---@param userConfig UserConfig
function Options.Configure(userConfig)
	local config = {}
	for k, v in pairs(Options.DefaultConfig) do
		config[k] = userConfig.options[k] or v
	end

	-- Each config item is a table
	for _, opt in pairs(config) do
		-- Each table contains setting tables
		for _, vim_setting in pairs(opt) do
			vim.o[vim_setting.key] = vim_setting.value
		end
	end
end
