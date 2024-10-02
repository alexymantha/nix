return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{"<Leader>do", function() require('dapui').open() end},
			{"<Leader>dc", function() require('dapui').close() end},
			{"<Leader>dr", function() require('dap').restart() end},
			{"<Leader>ds", function()
				if vim.fn.filereadable(".vscode/launch.json") then
					require("dap.ext.vscode").load_launchjs()
				end
				require("dap").continue()
			end},
			{"<F6>", function() require("dap").step_over() end},
			{"<F7>", function() require("dap").step_into() end},
			{"<F8>", function() require("dap").step_out() end},
			{"<Leader>db", function() require('dap').toggle_breakpoint() end},
			{"<Leader>dB", function() require('dap').set_breakpoint() end},
			{"<Leader>dC", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end},
			{"<Leader>dlp>", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end},
			{"<Leader>dl", function() require('dap').run_last() end},
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
		end,
		dependencies = {
			{ "theHamsta/nvim-dap-virtual-text", opts = {} },
			{
				"rcarriga/nvim-dap-ui",
				dependencies = {
					{ "nvim-neotest/nvim-nio" }
				},
				opts = {
					layouts = {
						{
							elements = {
								{
									id = "scopes",
									size = 0.50,
								},
								{
									id = "watches",
									size = 0.30,
								},
								{
									id = "breakpoints",
									size = 0.20,
								},
							},
							position = "left",
							size = 40,
						},
						{
							elements = {
								{
									id = "repl",
									size = 1,
								},
							},
							position = "bottom",
							size = 10,
						},
					},
				},
			},
			{ "leoluz/nvim-dap-go", opts = {} },
		},
	},
}
