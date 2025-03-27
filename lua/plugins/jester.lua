return {
	"David-Kunz/jester",
	enabled = false,
	config = function()
		require("jester").setup({
			cmd = "npm run test -t '$result' -- $file",
			dap = {
				console = "externalTerminal",
			},
		})
	end,
}
