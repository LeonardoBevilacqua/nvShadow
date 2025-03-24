return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local leader = require("config.keymap").leader
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
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
			},
			auto_install = true,
			highlight = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					-- TODO: Document keys
					init_selection = leader .. "ss",
					node_incremental = leader .. "si",
					scope_incremental = leader .. "sc",
					node_decremental = leader .. "sd",
				},
			},
		})
	end,
}
