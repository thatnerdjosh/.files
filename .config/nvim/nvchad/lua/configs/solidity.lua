-- SPDX-FileCopyrightText: 2026 thatnerdjosh
-- SPDX-License-Identifier: AGPL-3.0-or-later

local M = {}

-- "nomic" is the default (MIT, recommended).  "solc" trials the
-- GPL-3.0-or-later compiler LSP; select it with SOLIDITY_LSP=solc.
M.provider = vim.env.SOLIDITY_LSP == "solc" and "solc" or "nomic"

function M.setup()
  if M.provider == "solc" then
    vim.lsp.config("solc", {
      root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, {
          "foundry.toml",
          "hardhat.config.js",
          "hardhat.config.ts",
          ".git",
        })
        if root then
          on_dir(root)
        end
      end,
    })
    vim.lsp.enable "solc"
  else
    vim.lsp.enable "solidity_ls_nomicfoundation"
  end
end

return M
