require('omnidapps.core.options')
require('omnidapps.core.remap')
require('omnidapps.core.user')

Core = {}
local packages = require('omnidapps.core.packages')
local cmp = require('omnidapps.core.cmp')
local lsp = require('omnidapps.core.lsp')

---@param userConfig UserConfig
function Core.Setup(userConfig)
    packages.Setup(userConfig)
    cmp.Configure()
    Options.Configure(userConfig)
    lsp.Setup(userConfig)
end
