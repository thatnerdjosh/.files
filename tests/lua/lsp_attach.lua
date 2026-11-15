-- SPDX-FileCopyrightText: 2026 thatnerdjosh
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- Confirms that the Solidity language server attaches to a Foundry buffer.
-- Run with the fixture project as the working directory.

local bufnr = vim.api.nvim_get_current_buf()
local expected = "solidity_ls_nomicfoundation"

local attached = vim.wait(20000, function()
  return #vim.lsp.get_clients { bufnr = bufnr } > 0
end, 250)

local clients = vim.lsp.get_clients { bufnr = bufnr }
if not attached or #clients == 0 then
  io.stderr:write("no language server attached to " .. vim.api.nvim_buf_get_name(bufnr) .. "\n")
  vim.cmd "cq"
end

for _, client in ipairs(clients) do
  print(("lsp: %s root=%s"):format(client.name, tostring(client.config.root_dir)))
end

if clients[1].name ~= expected then
  io.stderr:write(("expected %s, got %s\n"):format(expected, clients[1].name))
  vim.cmd "cq"
end

local root = clients[1].config.root_dir
if root ~= vim.fn.getcwd() then
  io.stderr:write(("root_dir %s does not match cwd %s\n"):format(tostring(root), vim.fn.getcwd()))
  vim.cmd "cq"
end
