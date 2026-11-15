-- SPDX-FileCopyrightText: 2026 thatnerdjosh
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- Parses every Lua file in the active Neovim config without executing it.
-- Requires NVIM_CONFIG to point at the config directory.

local root = vim.env.NVIM_CONFIG
if not root or root == "" then
  io.stderr:write "NVIM_CONFIG is not set\n"
  vim.cmd "cq"
end

local files = vim.fn.globpath(root .. "/lua", "**/*.lua", false, true)
if #files == 0 then
  io.stderr:write("no Lua files found under " .. root .. "\n")
  vim.cmd "cq"
end

local failures = 0
for _, file in ipairs(files) do
  local chunk, err = loadfile(file)
  if not chunk then
    io.stderr:write(err .. "\n")
    failures = failures + 1
  end
end

if failures > 0 then
  vim.cmd "cq"
end

print(("lua syntax: %d files"):format(#files))
