return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("lint").linters_by_ft = {
			java = { "checkstyle" },
		}
		local checkstyle = require("lint").linters.checkstyle
		checkstyle.config_file = vim.fn.getcwd() .. package.config:sub(1, 1) .. "checkstyle.xml"

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			desc = "Try lint when saving a java file",
			group = vim.api.nvim_create_augroup("java-lint", { clear = true }),
			pattern = "*.java",
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
