require "core" -- Load OmnidApps NeoViM core

---@type UserConfig
local userConfig = {
    lsp = {
        languages = {
            "lua",
        }
    },
    packages = {
        manager = "lazy.nvim",
        installed = {
            {
                lazy = true,
                "neovim/nvim-lspconfig",
            },
            {
                -- TODO: Remove lazy.nvim specifics from main config
                lazy = false,
                priority = 1000,
                'tanvirtin/monokai.nvim'
            },
            {
                "folke/neodev.nvim"
            },
            {
                "hrsh7th/nvim-cmp",
                -- TODO: Abstract out below in this table
                config = function()
                    local cmp = require('cmp')
                    cmp.setup({
                        enabled = true,
                        mapping = cmp.mapping.preset.insert({
                            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                            ['<C-f>'] = cmp.mapping.scroll_docs(4),
                            ['<C-Space>'] = cmp.mapping.complete(),
                            ['<C-e>'] = cmp.mapping.abort(),
                            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                        }),
                        sources = cmp.config.sources({
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
                end,
                event = "InsertEnter",
                dependencies = {
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-buffer",
                },
            },
        },
    },
    options = {
        linum = {
            Options.Linum.Normal,
            Options.Linum.Relative
        }
    }
}


-- TODO: Migrate to setting
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

Core.Setup(userConfig)
