return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			dependencies = "rafamadriz/friendly-snippets",
			opts = { history = true, updateevents = "TextChanged,TextChangedI" },
			config = function(_, opts)
				require("luasnip").config.set_config(opts)
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
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
				snippets = { preset = "luasnip" },
			})
		end,
	},
}
