local function setup_nvim_list()
	local checkstyle_file_path = vim.fn.getcwd() .. package.config:sub(1, 1) .. "checkstyle.xml"
	local found_checkstyle_file = vim.fn.findfile(checkstyle_file_path)
	if type(found_checkstyle_file) == "string" and (found_checkstyle_file == nil or found_checkstyle_file == "") then
		return
	end

	local lint = require("lint")
	lint.linters_by_ft = {
		java = { "checkstyle" },
	}
	---@class lint.Linter
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
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	pattern = "*.java",
	callback = function()
		vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })
		setup_nvim_list()
	end,
})
