return {
	"nvim-treesitter/nvim-treesitter",
	version = "main",
	build = ":TSUpdate",
	config = function()
		local nvim_treesitter = require("nvim-treesitter")
		nvim_treesitter.install({
			"c",
			"vim",
			"lua",
			"vimdoc",
			"query",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"json",
			"angular",
			"scss",
			"javascript",
			"typescript",
			"tsx",
			"angular",
			"python",
			"svelte",
			"java",
		})
		nvim_treesitter.update()

		-- auto-start highlights & indentation
		vim.api.nvim_create_autocmd("FileType", {
			desc = "User: enable treesitter highlighting",
			callback = function(ctx)
				-- highlights
				local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

				-- indent
				local noIndent = {}
				if hasStarted and not vim.list_contains(noIndent, ctx.match) then
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
