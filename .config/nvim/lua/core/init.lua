require('core.options')
require('core.user')

Core = {}
local packages = require('core.packages')
local cmp = require('core.cmp')
local lsp = require('core.lsp')

---@param userConfig UserConfig
function Core.Setup(userConfig)
    packages.Setup(userConfig)
    cmp.Configure()
    Options.Configure(userConfig)
    lsp.Setup(userConfig)
end
