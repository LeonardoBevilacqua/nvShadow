return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		config = function()
			require("blink.cmp").setup({
				keymap = {
					preset = "default",
					["<C-j>"] = { "select_next", "fallback_to_mappings" },
					["<C-k>"] = { "select_prev", "fallback_to_mappings" },
					["<CR>"] = { "select_and_accept", "fallback" },
				},

				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},
				signature = { enabled = true },
			})
		end,
	},
}
