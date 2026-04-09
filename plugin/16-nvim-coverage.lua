vim.pack.add({ "https://github.com/andythigpen/nvim-coverage" })

require("coverage").setup({
	auto_reload = true,
	lang = {
		java = {
			coverage_file = "target/site/jacoco/jacoco.xml",
		},
	},
})
