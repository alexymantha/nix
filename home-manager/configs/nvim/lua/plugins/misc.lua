return {
	{
		"Shatur/neovim-ayu",
		lazy = false,
		priority = 1000,
		config = function()
			require('ayu').colorscheme()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = { theme = "ayu" },
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
