vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		vim.pack.add({ "https://github.com/windwp/nvim-ts-autotag" })
		require("nvim-ts-autotag").setup()
	end,
})
