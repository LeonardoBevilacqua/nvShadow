local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local toggle_lazygit = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = require("config.floating_window").create_floating_window({ buf = state.floating.buf })
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
