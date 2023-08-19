require('core.options')
require('core.lsp')
require('core.user')

packages = require('core.packages')
print(packages)
Core = {}

---@param userConfig UserConfig
function Core.Setup(userConfig)
	Options.Configure(userConfig)
	packages.Setup(userConfig)
end
