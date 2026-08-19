local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local window = require("config.floating_window")

local toggle_lazygit = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = window.create_floating_window({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.term("lazygit")
		end
		vim.fn.feedkeys("^", "n")
		vim.fn.feedkeys("i", "n")
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

vim.api.nvim_create_user_command("LazyGit", toggle_lazygit, {})

vim.api.nvim_create_autocmd("WinResized", {
	desc = "Resize lazygit window",
	group = vim.api.nvim_create_augroup("lazygit-resize", { clear = true }),
	callback = function()
		if state.floating.win ~= -1 then
			window.resize_window(state.floating.win, {})
		end
	end,
})
