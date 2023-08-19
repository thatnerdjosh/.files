require "core/options"

local settings = {
	linum = Options.Linum.RELATIVE
}

vim.o[settings.linum] = true
