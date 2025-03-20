return {
	"David-Kunz/jester",
	config = function()
		require("jester").setup({
			cmd = "npm run test -t '$result' -- $file",
			dap = {
				console = "externalTerminal",
			},
		})
	end,
}
