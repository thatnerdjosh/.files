-- SPDX-FileCopyrightText: 2026 thatnerdjosh
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- Confirms that the Solidity Treesitter parser is installed and loadable.

local ok, err = pcall(vim.treesitter.language.add, "solidity")
if not ok then
  io.stderr:write("solidity parser unavailable: " .. tostring(err) .. "\n")
  vim.cmd "cq"
end

print "treesitter: solidity parser loaded"
