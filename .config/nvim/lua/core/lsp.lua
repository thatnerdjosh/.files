local lsp = {}

local function configLua()
    require("neodev").setup({})
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace"
                }
            }
        }
    })
end

---@param userConfig UserConfig
function lsp.Setup(userConfig)
    for _, lang in pairs(userConfig.lsp.languages) do
        if lang == "lua" then
            configLua()
        end
    end
end

return lsp
