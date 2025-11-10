return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lspconfig = require("lspconfig")
			local server_configs = {
				clangd = {
					cmd = {
						'clangd', '--background-index', '--clang-tidy',
						'--log=verbose', '--compile-commands-dir=.',
					},
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
				},
				dartls = {
					settings = {
						dart = {
							analysisExcludedFolders = { ".dart_tool/**", "**/.pub-cache/**", "**/.bin/**" }
						},
					},
				},
				helm_ls = {
					settings = {
						["helm-ls"] = {
							yamlls = {
								path = "yaml-language-server",
								config = { schemas = { ["kubernetes"] = "/*.yaml" } },
							},
						},
					},
				},
				html = { filetypes = { "html", "templ" } },
				htmx = { filetypes = { "html", "templ" } },
				lua_ls = {
					settings = {
						Lua = { diagnostics = { globals = { "vim" } } },
					},
				},
				tailwindcss = {
					filetypes = { "templ", "astro", "javascript", "typescript", "react" },
					settings = {
						tailwindCSS = { includeLanguages = { templ = "html" } },
					},
				},
				yamlls = {
					on_attach = function(client, _)
						if client.name == "yamlls" and vim.bo.filetype == "helm" then
							vim.lsp.stop_client(client.id)
						end
					end,
					settings = {
						schemaStore = { url = "https://www.schemastore.org/api/json/catalog.json", enable = false },
						yaml = {
							validate = false,
							schemas = {
								["file:///Users/amantha/.datree/crdSchemas/cluster.open-cluster-management.io/placement_v1beta1.json"] =
								"**/placements/**/*.yaml",
								["kubernetes"] = "/*.yaml",
							},
						},
					},
				},
				zls = {
					settings = { zls = { enable_build_on_save = true } }
				},
			}

			-- Simple servers that don't need configuration
			local simple_servers = {
				'buf_ls', 'dockerls', 'gopls', 'jsonls', 'nil_ls',
				'pyright', 'rust_analyzer', 'templ', 'terraformls'
			}

			-- Configure servers with custom settings
			for server, config in pairs(server_configs) do
				vim.lsp.config(server, config)
			end

			-- Auto-enable all servers
			for server, _ in pairs(server_configs) do
				vim.lsp.enable(server)
			end
			for _, server in ipairs(simple_servers) do
				vim.lsp.enable(server)
			end


			-- Vue config
			-- Vue requires a specific setup with plugins for different servers
			vim.lsp.config('vtsls', {
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = {
								{
									name = '@vue/typescript-plugin',
									location =
									"/Users/amantha/dev/temabex-nuxt/node_modules/@vue/language-server",
									languages = { 'vue' },
									configNamespace = 'typescript',
								},
							},
						},
					},
				},
				filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
			})
			vim.lsp.config('vue_ls', {})
			vim.lsp.enable({ 'vtsls', 'vue_ls' })

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
						local buf_group = vim.api.nvim_create_augroup(
							"LspFormatting_" .. ev.buf,
							{ clear = true }
						)

						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = ev.buf,
							group = buf_group,
							callback = function()
								vim.lsp.buf.format({
									bufnr = ev.buf,
									timeout_ms = 3000,
									filter = function(c)
										-- Disable html formatting if templ is available
										if c.name == "html" then
											local templ_clients = vim.lsp.get_clients({
												bufnr = ev.buf,
												name = "templ",
											})
											return #templ_clients == 0
										end
										return true
									end,
								})
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

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "gotmpl",
				once = true,
				callback = function()
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
			})
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
}
