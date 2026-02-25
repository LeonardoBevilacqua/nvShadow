return {
	"mfussenegger/nvim-lint",
	config = function()
		require("lint").linters_by_ft = {
			java = { "checkstyle" },
		}
		local checkstyle = require("lint").linters.checkstyle
		checkstyle.config_file = vim.fn.getcwd() .. package.config:sub(1, 1) .. "checkstyle.xml"
	end,
}
