-- SPDX-FileCopyrightText: 2026 thatnerdjosh
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- Settings for the optional AI and collaboration plugins.  Credentials are
-- read from environment variables by the plugins themselves; nothing here
-- ever stores a key in this repository.

local M = {}

local function env(name, default)
  local value = vim.env[name]
  if value == nil or value == "" then
    return default
  end
  return value
end

local function env_list(name)
  local list = {}
  for item in env(name, ""):gmatch "[^,]+" do
    item = vim.trim(item)
    if item ~= "" then
      list[#list + 1] = item
    end
  end
  return list
end

-- Inline completion.  Manual by default: request with <A-]>, accept a line
-- with <A-a>, accept everything with <A-A>, dismiss with <A-e>.  Set
-- MINUET_AUTO_FT=solidity,lua (or "*") to auto-trigger in those filetypes.
function M.minuet()
  return {
    provider = env("MINUET_PROVIDER", "openai"),
    request_timeout = 2.5,
    throttle = 1000,
    debounce = 400,
    virtualtext = {
      auto_trigger_ft = env_list "MINUET_AUTO_FT",
      keymap = {
        accept = "<A-A>",
        accept_line = "<A-a>",
        accept_n_lines = "<A-z>",
        prev = "<A-[>",
        next = "<A-]>",
        dismiss = "<A-e>",
      },
    },
    provider_options = {
      openai = {
        model = env("MINUET_MODEL", "gpt-5.6-luna"),
        api_key = "OPENAI_API_KEY",
      },
    },
  }
end

-- Chat and selected-text tools.  The plugin reads LLM_KEY for credentials.
function M.llm()
  return {
    url = env("LLM_URL", "https://api.openai.com/v1/chat/completions"),
    model = env("LLM_MODEL", "gpt-5.6-luna"),
    api_type = env("LLM_API_TYPE", "openai"),
    prompt = "You are a professional programmer.",
  }
end

-- pi runs in a terminal pane, so its credentials live in pi's own config.
function M.pi()
  return {
    cmd = env("PI_CMD", "pi"),
    split_side = "right",
    split_width_percentage = 0.3,
    auto_insert = true,
  }
end

-- `.chat` files are plain Markdown; Flemma detects the filetype in setup().
function M.flemma()
  return {
    editing = { auto_write = true },
  }
end

-- Create a .chat file without leaving the editor.
function M.new_chat()
  local name = vim.fn.input("New chat file: ", vim.fn.getcwd() .. "/notes.chat")
  if name == "" then
    return
  end
  vim.cmd.edit(vim.fn.fnameescape(vim.fn.fnamemodify(name, ":p")))
end

return M
