local keymap = require("config.keymap")

return {
	"olimorris/onedarkpro.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local onedarkpro = require("onedarkpro")
		onedarkpro.setup({
			options = {
				transparency = true,
			},
		})

		vim.cmd("colorscheme onedark")

		keymap.map(keymap.normalMode, keymap.leader .. "tt", function()
			local onedarkpro_config = require("onedarkpro.config")
			onedarkpro.setup({
				options = {
					transparency = not onedarkpro_config.options.transparency,
				},
			})
			vim.cmd("colorscheme onedark")
		end, { desc = "Toggle background transparency" })
	end,
}
