return {
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					css = { "prettier" },
					html = { "prettier" },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})

			local keymap = require("config.keymap")
			print(keymap.leader)
			keymap.map(keymap.normalMode, keymap.leader .. "fm", function()
				require("conform").format({ lsp_fallback = true })
			end, { desc = "general format file" })
		end,
	},
	{
		"zapling/mason-conform.nvim",
		dependencies = { "mason.nvim", "conform.nvim" },
		config = function()
			require("mason-conform").setup({})
		end,
	},
}
