local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = require("plugin.floating_window").create_floating_window({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.term()
		end
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

local horizontal_terminal = function()
	vim.cmd("hor term")
	vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.25))
end

local vertical_terminal = function()
	vim.cmd("vert term")
	if vim.bo[0].buftype ~= "terminal" then
		vim.api.nvim_win_set_width(0, math.floor(vim.o.columns * 0.25))
	end
end

vim.api.nvim_create_user_command("Floatterminal", toggle_terminal, {})
vim.api.nvim_create_user_command("Horterminal", horizontal_terminal, {})
vim.api.nvim_create_user_command("Vertterminal", vertical_terminal, {})
