local lsp = {}

local function configC()
    -- TODO: Add ccls support
    require 'lspconfig'.clangd.setup {}
end

local function configLua()
    require("neodev").setup({})
    require("nvim-ketho-wow").setup({
        enabled_completions = {
            "API",
        },
    })

    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace"
                },
            }
        },
    })
end

---@param userConfig UserConfig
function lsp.Setup(userConfig)
    for _, lang in pairs(userConfig.lsp.languages) do
        if lang == "lua" then
            configLua()
        elseif lang == "c" then
            configC()
        end
    end
end

return lsp
