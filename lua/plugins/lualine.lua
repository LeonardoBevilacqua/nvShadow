return {
	"nvim-lualine/lualine.nvim",
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
				lualine_a = { { "buffers", filetype_names = {
					oil = "Explore",
				} } },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "tabs" },
			},
		})
	end,
}
