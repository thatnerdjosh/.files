-- SPDX-FileCopyrightText: 2026 thatnerdjosh
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- Confirms that the optional AI and collaboration plugins load, register
-- their commands, and expose the documented keymaps.

local function fail(message)
  io.stderr:write(message .. "\n")
  vim.cmd "cq"
end

-- These plugins are lazy-loaded; force them so command and module checks are
-- deterministic.  Flemma and Teamtype load at startup.
local ok, err = pcall(require("lazy").load, {
  plugins = { "minuet-ai.nvim", "llm.nvim", "pi-coding-agent.nvim" },
})
if not ok then
  fail("lazy.nvim could not load the AI plugins: " .. tostring(err))
end

for _, name in ipairs {
  "minuet",
  "llm",
  "pi_coding_agent",
  "flemma",
  "teamtype",
} do
  if not pcall(require, name) then
    fail(("module %s did not load"):format(name))
  end
end

for _, command in ipairs {
  "Minuet",
  "LLMSessionToggle",
  "LLMSelectedTextHandler",
  "Flemma",
  "PiToggle",
  "PiSendBuffer",
  "TeamtypeInfo",
  "TeamtypeJumpToCursor",
  "TeamtypeFollow",
} do
  if vim.fn.exists(":" .. command) ~= 2 then
    fail(("command %s is not registered"):format(command))
  end
end

for _, map in ipairs {
  { "ac", "n" },
  { "al", "v" },
  { "af", "n" },
  { "ap", "n" },
  { "as", "v" },
  { "tj", "n" },
  { "tf", "n" },
} do
  local key = vim.g.mapleader .. map[1]
  if vim.tbl_isempty(vim.fn.maparg(key, map[2], false, true)) then
    fail(("keymap %s (%s) is not registered"):format(key, map[2]))
  end
end

if vim.filetype.match { filename = "notes.chat" } ~= "chat" then
  fail "Flemma did not register the chat filetype for .chat files"
end

print "ai: plugins, commands, keymaps, and chat filetype registered"
