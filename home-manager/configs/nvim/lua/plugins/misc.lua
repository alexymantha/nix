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
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	}
}
