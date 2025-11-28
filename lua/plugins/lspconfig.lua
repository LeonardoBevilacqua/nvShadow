local function get_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
	capabilities = vim.tbl_deep_extend(
		"force",
		capabilities,
		{ textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } }
	)

	return capabilities
end

local function configure_vim_diagnostic()
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
end

local function setup_lsp_servers()
	local languages = require("config.languages")

	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = {},
		automatic_installation = false,
		automatic_enable = {
			exclude = { "jdtls" },
		},
	})
	require("mason-tool-installer").setup({ ensure_installed = languages.ensure_installed })

	for server_name, language_config in pairs(languages.language_configs) do
		local server = language_config.config or {}
		server.capabilities = vim.tbl_deep_extend("force", get_capabilities(), server.capabilities or {})
		vim.lsp.config(server_name, server)
	end
end

local function configure_jdtls()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "java",
		callback = function()
			require("config.jdtls_setup").setup()
		end,
	})
end

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
		{
			"mfussenegger/nvim-jdtls",
			dependencies = { "mfussenegger/nvim-dap" },
		},
	},
	config = function()
		configure_vim_diagnostic()
		setup_lsp_servers()
		configure_jdtls()
		require("sonarlint").setup(require("config.sonarlint"))
	end,
}
