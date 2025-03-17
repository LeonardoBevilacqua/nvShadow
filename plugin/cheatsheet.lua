local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local function get_mappings(mode)
	local mappings = {}
	local api = vim.api

	for _, map in ipairs(api.nvim_get_keymap(mode)) do
		if map.lhs and map.desc then
			if not vim.startswith(map.lhs, "<Plug>") then
				table.insert(mappings, {
					lhs = map.lhs:gsub(" ", "<Leader>"),
					rhs = map.rhs,
					desc = map.desc or "",
					mode = mode,
				})
			end
		end
	end
	return mappings
end

local function filter_mappings(mappings, mode, search_term)
	if not search_term then
		return mappings[mode] or {}
	end

	local filtered = {}
	local pattern = vim.pesc(search_term):lower()

	for _, mapping in ipairs(mappings[mode] or {}) do
		if mapping.lhs:lower():find(pattern) or (mapping.desc and mapping.desc:lower():find(pattern)) then
			table.insert(filtered, mapping)
		end
	end

	return filtered
end

local function sort_mappings(mappings)
	table.sort(mappings, function(a, b)
		return a.desc < b.desc
	end)
	return mappings
end

local function format_mapping(mapping)
	local parts = {}

	table.insert(parts, mapping.lhs)

	if mapping.desc then
		table.insert(parts, string.format("→ %s", mapping.desc))
	end

	return table.concat(parts, "  ")
end

local function show_cheatsheet(search_term)
	local mode = "n"
	local api = vim.api
	local mappings = get_mappings(mode)
	local filtered = filter_mappings({ [mode] = mappings }, mode, search_term)
	local sorted = sort_mappings(filtered)

	local lines = { "Mappings for mode: " .. mode }
	for _, mapping in ipairs(sorted) do
		table.insert(lines, format_mapping(mapping))
	end

	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = require("config.floating_window").create_floating_window({ buf = -1 })
		api.nvim_buf_set_lines(state.floating.buf, 0, -1, false, lines)
		api.nvim_buf_set_option(state.floating.buf, "modifiable", false)
		api.nvim_buf_set_option(state.floating.buf, "readonly", true)
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

vim.api.nvim_create_user_command("Cheatsheet", function(opt)
	show_cheatsheet(opt.args)
end, { nargs = "?" })
