return {
	"andythigpen/nvim-coverage",
	config = function()
		require("coverage").setup({
			auto_reload = true,
			lang = {
				java = {
					coverage_file = "target/site/jacoco/jacoco.xml",
				},
			},
		})
	end,
}
