-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

-- Keymapping
vim.g.mapleader = " "
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Diagnostic config
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = true,
	severity_sort = true,
})

-- Load plugins
require("lazy").setup({
	-- Theme
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		--config = function()
		--	vim.o.background = "dark"
		--	vim.cmd([[colorscheme gruvbox]])
		--end
	},
	{
		'nordtheme/vim',
		priority = 1000,
		config = function()
			vim.o.background = "dark"
			vim.cmd([[colorscheme nord]])
		end
	},

	-- LSP Support
	{ "williamboman/mason.nvim",           config = true },
	{ "williamboman/mason-lspconfig.nvim", config = true },
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(_, bufnr)
				-- Enable LSP features live during editing
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Optional: format on save
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ async = false })
					end,
				})
			end

			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.clangd.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.http_lsp.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"saghen/blink.cmp"
		}
	},

	-- Blink CMP plugin
	{
		"saghen/blink.cmp",
		config = function()
			require("blink.cmp").setup({})
		end,
		build = 'cargo +nightly build --release'
	},

	-- Telescope file searcher
	{
		"nvim-telescope/telescope.nvim",
		tag = '0.1.8',
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
			vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
			vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
		end
	},

	-- Add modicator
	{
		'mawkler/modicator.nvim',
		dependencies = 'nordtheme/vim',
		init = function()
			vim.o.cursorline = true
			vim.o.number = true
			vim.o.termguicolors = true
		end,
		opts = {
			show_warnings = true,
		}
	},

	-- Lualine
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require("lualine").setup {}
		end
	},

	-- Enable transpacency
	{
		'tribela/transparent.nvim',
		event = 'VimEnter',
		config = true,
	},
})
