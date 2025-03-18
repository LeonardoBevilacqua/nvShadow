return {
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		lazy = false,
		config = function()
			require("oil").setup({
				win_options = {
					signcolumn = "yes:2",
				},
				view_options = {
					show_hiiden = true,
				},
			})
			local keymap = require("config.keymap")
			keymap.map(
				keymap.normalMode,
				keymap.getCtrlCommand("n"),
				":Oil" .. keymap.enter,
				{ desc = "Open Explorer" }
			)
		end,
	},
	{
		"refractalize/oil-git-status.nvim",
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = true,
	},
}
