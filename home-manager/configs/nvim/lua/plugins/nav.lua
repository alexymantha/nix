return {
	{
		"stevearc/oil.nvim",
		lazy = false,
		keys = {
			{
				"<C-p>",
				function()
					require("oil").open()
				end,
			},
		},
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		keys = {
			-- Cannot setup mappings here because they need
			-- to use the same harpoon instance.
			{ "<Leader>a" },
			{ "<C-e>" },
			{ "<C-h>" },
			{ "<C-j>" },
			{ "<C-k>" },
			{ "<C-l>" },
		},
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup()

			vim.keymap.set("n", "<Leader>a", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<C-h>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<C-j>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<C-k>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<C-l>", function()
				harpoon:list():select(4)
			end)
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{
				"<Leader>ff",
				function()
					local is_inside_work_tree = {}

					local cwd = vim.fn.getcwd()
					if is_inside_work_tree[cwd] == nil then
						vim.fn.system("git rev-parse --is-inside-work-tree")
						is_inside_work_tree[cwd] = vim.v.shell_error == 0
					end

					if is_inside_work_tree[cwd] then
						require("telescope.builtin").git_files()
					else
						require("telescope.builtin").find_files()
					end
				end,
			},
			{
				"<Leader>pf",
				function()
					require("telescope.builtin").find_files()
				end,
			},
			{
				"<Leader>fg",
				function()
					require("telescope.builtin").live_grep()
				end,
			},
			{
				"<Leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
			},
			{
				"<Leader>fh",
				function()
					require("telescope.builtin").help_tags()
				end,
			},
		},
	},
}
