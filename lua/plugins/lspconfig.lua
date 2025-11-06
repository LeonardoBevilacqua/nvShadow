return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"saghen/blink.cmp",
		"https://gitlab.com/schrieveslaach/sonarlint.nvim",
	},
	config = function()
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		local servers = require("config.languages").servers

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
		capabilities = vim.tbl_deep_extend(
			"force",
			capabilities,
			{ textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } }
		)

		local ensure_installed = require("config.languages").ensure_installed
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = {},
			automatic_installation = false,
		})
		for server_name, config in pairs(servers) do
			local server = config or {}
			server.capabilities = vim.tbl_deep_extend("force", capabilities, server.capabilities or {})
			vim.lsp.config(server_name, server)
		end

		require("sonarlint").setup({
			server = {
				cmd = {
					"sonarlint-language-server",
					-- Ensure that sonarlint-language-server uses stdio channel
					"-stdio",
					"-analyzers",
					-- paths to the analyzers you need, using those for python and java in this example
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
				},
				settings = {
					sonarlint = {
						connectedMode = {
							connections = {
								sonarqube = {
									{
										connectionId = "ID",
										serverUrl = vim.fn.getenv("SONAR_SERVER_URL"),
										disableNotifications = false,
									},
								},
							},
						},
					},
				},
				before_init = function(params, config)
					local project_root_and_ids = {
						["folder-path"] = "folder",
					}

					config.settings.sonarlint.connectedMode.project = {
						connectionId = "ID",
						projectKey = project_root_and_ids[params.rootPath],
					}
				end,
				-- settings = {
				-- 	sonarlint = {
				-- 		rules = {
				-- 			["typescript:S101"] = { level = "on", parameters = { format = "^[A-Z][a-zA-Z0-9]*$" } },
				-- 			["typescript:S103"] = { level = "on", parameters = { maximumLineLength = 18 } },
				-- 			["typescript:S106"] = { level = "on" },
				-- 			["typescript:S107"] = { level = "on", parameters = { maximumFunctionParameters = 7 } },
				-- 		},
				-- 	},
				-- },
			},
			filetypes = {
				"javascript",
				"typescript",
			},
		})
	end,
}
