local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

local toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = create_floating_window({ buf = state.floating.buf })
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
