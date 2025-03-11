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
		})
	end,
}
