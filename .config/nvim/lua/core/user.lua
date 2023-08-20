---@alias PackageManager
---|"lazy.nvim"

---@class PackageConfig
---@field manager PackageManager
---@field installed table

---@class LspConfig
---@field languages table

---@class UserConfig
---@field options VimOptions
---@field packages PackageConfig
---@field lsp LspConfig