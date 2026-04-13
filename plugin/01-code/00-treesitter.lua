vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } })

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
