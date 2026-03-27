return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "onedark",
				section_separators = "",
				component_separators = "",
				globalstatus = true,
			},
			sections = {
				lualine_y = { "progress", "searchcount" },
				lualine_z = { "location", "selectioncount" },
			},
			tabline = {
				lualine_a = {
					{
						"buffers",
						filetype_names = { oil = "Explore" },
						max_length = vim.o.columns * 10 / 12,
					},
				},
				lualine_z = {
					{
						"tabs",
						max_length = vim.o.columns * 2 / 12,
					},
				},
			},
		})
	end,
}
