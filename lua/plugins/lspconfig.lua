return {
	"neovim/nvim-lspconfig",
	dependencies = { "saghen/blink.cmp" },
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local lspconfig = require("lspconfig")
		local languages = require("config.languages")

		for _, lspLanguage in ipairs(languages.lspLanguages) do
			lspconfig[lspLanguage].setup({ capabilities = capabilities })
		end

		local keymap = require("config.keymap")

		keymap.map(keymap.normalMode, "gD", vim.lsp.buf.declaration, { desc = "LSP Go to declaration" })
		keymap.map(keymap.normalMode, "gd", vim.lsp.buf.definition, { desc = "LSP Go to definition" })
		keymap.map(keymap.normalMode, "gi", vim.lsp.buf.implementation, { desc = "LSP Go to implementation" })
		keymap.map(keymap.normalMode, "<leader>sh", vim.lsp.buf.signature_help, { desc = "LSP Show signature help" })
		keymap.map(
			keymap.normalMode,
			"<leader>wa",
			vim.lsp.buf.add_workspace_folder,
			{ desc = "LSP Add workspace folder" }
		)
		keymap.map(
			keymap.normalMode,
			"<leader>wr",
			vim.lsp.buf.remove_workspace_folder,
			{ desc = "LSP Remove workspace folder" }
		)

		keymap.map(keymap.normalMode, "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { desc = "LSP List workspace folders" })

		keymap.map(keymap.normalMode, "<leader>D", vim.lsp.buf.type_definition, { desc = "LSP Go to type definition" })
		keymap.map(keymap.normalMode, "<leader>ra", vim.lsp.buf.rename, { desc = "LSP rename" })

		keymap.map({ keymap.normalMode, "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code action" })
		keymap.map(keymap.normalMode, "gr", vim.lsp.buf.references, { desc = "LSP Show references" })
	end,
}
