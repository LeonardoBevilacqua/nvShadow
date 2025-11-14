---@class VimTip
---@field title string
---@field description string

local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

---@param tip VimTip
local function format_tip(tip)
	local parts = {}

	table.insert(parts, "- " .. tip.title)

	if tip.description then
		table.insert(parts, string.format("→ %s", tip.description))
	end

	return table.concat(parts, "  ")
end

local function show_vim_cheatsheet()
	local api = vim.api

	local lines = { "# Vim tricks and tips: " }
	---@type VimTip[]
	local tips = {
		{
			title = "Telescope live_grep by file",
			description = "Use the command `:Telescope live_grep glob_pattern=*.{json,vim,lua}`",
		},
		{
			title = "Reverse lines",
			description = "Use the command `:global/^/move 0` or the short version `:g/^/m0`",
		},
		{
			title = "Search and replace selection",
			description = "Use `/` to search the text to be replaced, and use `:%s//new-string` to replace the last searched pattern",
		},
		{
			title = "Terminal command history",
			description = "In terminal, enter command mode (`<Esc>`) and press `/`, type the command to search and press enter. Use `n` and `N` to navigate",
		},
	}
	for _, tip in ipairs(tips) do
		table.insert(lines, format_tip(tip))
	end

	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = require("config.floating_window").create_floating_window({ buf = -1 })
		api.nvim_buf_set_lines(state.floating.buf, 0, -1, false, lines)
		api.nvim_set_option_value("modifiable", false, { buf = state.floating.buf })
		api.nvim_set_option_value("readonly", true, { buf = state.floating.buf })
		api.nvim_set_option_value("filetype", "markdown", { buf = state.floating.buf })
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

vim.api.nvim_create_user_command("VimCheatsheet", function()
	show_vim_cheatsheet()
end, {})
