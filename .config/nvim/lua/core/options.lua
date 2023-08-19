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
---@field colorscheme string
Options.DefaultConfig = {
	linum = {},
	colorscheme = "monokai"
}

-- This exists so the user doesn't need to be concerned with ViM specifics
Options.ActionMapping = {
	linum = "setting",
	colorscheme = "command"
}

-- FIXME: This leaks to the global scope, migrate to local that's exported.
---@param userConfig UserConfig
function Options.Configure(userConfig)
	local config = {}
	for k, v in pairs(Options.DefaultConfig) do
		config[k] = userConfig.options[k] or v
	end

	-- Each config item is a table
	for cfgItem, cfgVal in pairs(config) do
		if Options.ActionMapping[cfgItem] == "setting" then
			-- Each table contains setting tables
			for k, v in pairs(cfgVal) do
				vim.o[v.key] = v.value
			end
		elseif Options.ActionMapping[cfgItem] == "command" then
			vim.cmd[cfgItem](cfgVal)
		end
	end
end
