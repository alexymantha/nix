return {
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme catppuccin-macchiato]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = { theme = "catppuccin" },
			sections = {
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
				},
			},
		},
		dependencies = {},
	},
	"tpope/vim-sensible",
	"tpope/vim-surround",
	"tpope/vim-endwise",
	"tpope/vim-sleuth",
	"tpope/vim-commentary",
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			plugins = {
				kitty = {
					enabled = true,
					font = "+8",
				},
			}
		}
	},
	{
		"folke/twilight.nvim",
		opts = {
			expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
				"function",
				"method",
				"table",
				"if_statement",
				-- "block_mapping", -- for yaml
				"block_mapping_pair", -- for yaml
			},
		}
	}
}
