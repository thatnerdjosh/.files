local cmp = {}
function cmp.Configure()
    local cmpMod = require('cmp')
    cmpMod.setup({
        enabled = true,
        window = {
            completion = cmpMod.config.window.bordered(),
            documentation = cmpMod.config.window.bordered(),
        },
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
        mapping = cmpMod.mapping.preset.insert({
            ['<C-j>'] = cmpMod.mapping.scroll_docs(-4),
            ['<C-k>'] = cmpMod.mapping.scroll_docs(4),
            ['<C-Space>'] = cmpMod.mapping.complete(),
            ['<C-e>'] = cmpMod.mapping.abort(),
            ['<CR>'] = cmpMod.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmpMod.config.sources({
            { name = 'nvim_lsp' },
        }),
        formatting = {
            format = function(entry, vim_item)
                -- Kind icons
                vim_item.kind = string.format('%s', vim_item.kind) -- This concatonates the icons with the name of the item kind
                -- Source
                vim_item.menu = ({
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[LaTeX]",
                })[entry.source.name]
                return vim_item
            end
        },
    })
end

return cmp
