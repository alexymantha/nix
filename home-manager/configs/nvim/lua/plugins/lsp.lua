return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		keys = {
			{ "[e",         vim.diagnostic.open_float },
			{ "[d",         vim.diagnostic.goto_prev },
			{ "]d",         vim.diagnostic.goto_next },
			{ "[q",         vim.diagnostic.setloclist },
			{ "<Leader>fd", ":Telescope diagnostics<CR>" },
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.buf_ls.setup({ capabilities = capabilities })
			lspconfig.dockerls.setup({ capabilities = capabilities })
			lspconfig.gopls.setup({ capabilities = capabilities })
			lspconfig.html.setup({ capabilities = capabilities, filetypes = { "html", "templ" } })
			lspconfig.htmx.setup({ capabilities = capabilities, filetypes = { "html", "templ" } })
			lspconfig.jsonls.setup({ capabilities = capabilities })
			lspconfig.nil_ls.setup({ capabilities = capabilities })
			lspconfig.pyright.setup({ capabilities = capabilities })
			lspconfig.rust_analyzer.setup({ capabilities = capabilities })
			lspconfig.templ.setup({ capabilities = capabilities })
			lspconfig.terraformls.setup({ capabilities = capabilities })
			lspconfig.ts_ls.setup({ capabilities = capabilities })
			lspconfig.zls.setup({ capabilities = capabilities })

			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
				filetypes = { "templ", "astro", "javascript", "typescript", "react" },
				settings = {
					tailwindCSS = {
						includeLanguages = {
							templ = "html",
						},
					},
				},
			})

			-- lspconfig.harper_ls.setup {
			-- 	settings = {
			-- 		["harper-ls"] = {
			-- 			codeActions = {
			-- 				forceStable = true
			-- 			}
			-- 		}
			-- 	},
			-- }

			lspconfig.yamlls.setup({
				capabilities = capabilities,
				on_attach = function(client, _)
					if client.name == "yamlls" and vim.bo.filetype == "helm" then
						vim.lsp.stop_client(client.id)
					end
				end,
				settings = {
					schemaStore = {
						url = "https://www.schemastore.org/api/json/catalog.json",
						enable = false,
					},
					yaml = {
						validate = false,
						schemas = {
							["file:///Users/amantha/.datree/crdSchemas/cluster.open-cluster-management.io/placement_v1beta1.json"] =
							"**/placements/**/*.yaml",
							["kubernetes"] = "/*.yaml",
						},
					},
				},
			})

			lspconfig.helm_ls.setup({
				settings = {
					["helm-ls"] = {
						yamlls = {
							path = "yaml-language-server",
							config = {
								schemas = {
									["kubernetes"] = "/*.yaml",
								},
							},
						},
					},
				},
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			require("lspconfig").dartls.setup({
				capabilities = capabilities,
				settings = {
					dart = {
						analysisExcludedFolders = { ".dart_tool/**", "**/.pub-cache/**", "**/.bin/**" }
					},
				},
			})

			require("lspconfig").clangd.setup({
				capabilities = capabilities,
				cmd = {
					'clangd',
					'--background-index',
					'--clang-tidy',
					'--log=verbose',
					'--compile-commands-dir=.',
				},
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "<Leader>gD", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "L", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<Leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<Leader>bf", function()
						vim.lsp.buf.format()
					end, opts)

					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = ev.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
							end,
						})
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
				indent = {
					disable = { 'yaml', 'templ' },
					enable = true,
				},
			})

			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.gotmpl = {
				install_info = {
					url = "https://github.com/ngalaiko/tree-sitter-go-template",
					files = { "src/parser.c" },
				},
				filetype = "gotmpl",
				used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl" },
			}
		end,
	},
	{ "towolf/vim-helm", ft = "helm" }, -- Helm not working properly with treesitter so using a custom plugin
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<Leader>xx",
				function()
					require("trouble").toggle()
				end,
			},
			{
				"<Leader>xw",
				function()
					require("trouble").toggle("workspace_diagnostics")
				end,
			},
			{
				"<Leader>xd",
				function()
					require("trouble").toggle("document_diagnostics")
				end,
			},
			{
				"<Leader>xq",
				function()
					require("trouble").toggle("quickfix")
				end,
			},
			{
				"<Leader>xl",
				function()
					require("trouble").toggle("loclist")
				end,
			},
			{
				"gR",
				function()
					require("trouble").toggle("lsp_references")
				end,
			},
		},
		opts = {},
	},
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", 'gomod' },
	}
}
