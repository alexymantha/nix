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
			options = { theme = "palenight" },
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
	{ "nvim-lua/plenary.nvim",       lazy = true },
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	"tpope/vim-sensible",
	"tpope/vim-surround",
	"tpope/vim-endwise",
	"tpope/vim-sleuth",
	"tpope/vim-commentary",
	{ "windwp/nvim-autopairs", opts = {} },
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		keys = { {
			"<Leader>gg",
			function()
				require("lazygit").lazygit()
			end,
		} },
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			-- options
		},
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
