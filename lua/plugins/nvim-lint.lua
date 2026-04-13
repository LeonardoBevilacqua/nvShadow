return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local checkstyle_file_path = vim.fn.getcwd() .. package.config:sub(1, 1) .. "checkstyle.xml"
		local found_checkstyle_file = vim.fn.findfile(checkstyle_file_path)
		if
			type(found_checkstyle_file) == "string" and (found_checkstyle_file == nil or found_checkstyle_file == "")
		then
			return
		end

		local lint = require("lint")
		lint.linters_by_ft = {
			java = { "checkstyle" },
		}
		local checkstyle = lint.linters.checkstyle
		checkstyle.config_file = checkstyle_file_path

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			desc = "Try lint when saving a java file",
			group = vim.api.nvim_create_augroup("java-lint", { clear = true }),
			pattern = "*.java",
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
