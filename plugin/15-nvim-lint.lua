local function setup_nvim_list()
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
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	once = true,
	pattern = "*.java",
	callback = function()
		vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })
		setup_nvim_list()
	end,
})
