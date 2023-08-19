require('core.options')
require('core.user')

Core = {}
local packages = require('core.packages')
local lsp = require('core.lsp')

---@param userConfig UserConfig
function Core.Setup(userConfig)
	packages.Setup(userConfig)
	Options.Configure(userConfig)
	lsp.Setup(userConfig)
end
