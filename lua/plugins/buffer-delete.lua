local keymap = require("config.keymap")

return {
	"ojroques/nvim-bufdel",
	keys = {
		{
			keymap.leader .. "x",
			keymap.getCommand("BufDel"),
			desc = "Close buffer",
		},
	},
}
