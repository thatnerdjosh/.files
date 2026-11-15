-- SPDX-FileCopyrightText: 2026 thatnerdjosh
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- Confirms that the full Neovim configuration loads and registers plugins.

local ok, lazy = pcall(require, "lazy.core.config")
if not ok then
  io.stderr:write "lazy.nvim did not load\n"
  vim.cmd "cq"
end

local count = 0
for _ in pairs(lazy.plugins) do
  count = count + 1
end

if count == 0 then
  io.stderr:write "lazy.nvim registered no plugins\n"
  vim.cmd "cq"
end

if vim.g.mapleader ~= " " then
  io.stderr:write "leader key was not set by the config\n"
  vim.cmd "cq"
end

print(("config: plugins=%d"):format(count))
