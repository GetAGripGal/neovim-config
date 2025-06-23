-- The themes
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- The plugins
vim.cmd([[
	call plug#begin()

	Plug 'ellisonleao/gruvbox.nvim'

	call plug#end()
]])

require("plugins.mason")
