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
	end,
}
