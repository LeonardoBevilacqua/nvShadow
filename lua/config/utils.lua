local M = {}

--- @param chunks [string, integer|string?][] List of `[text, hl_group]` pairs, where each is a `text` string highlighted by
--- the (optional) name or ID `hl_group`.
--- @param history boolean if true, add to `message-history`.
--- @param opts? vim.api.keyset.echo_opts Optional parameters.
local function echo(chunks, history, opts)
	opts = opts or {
		verbose = false,
	}
	vim.api.nvim_echo(chunks, history or false, opts)
end

function M.is_windows()
	return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

---@param title string
---@param message string
function M.success_message(title, message)
	echo({
		{ title .. ": " },
		{ message, "MoreMsg" },
	}, false)
end

---@param title string
---@param message string
function M.error_message(title, message)
	echo({
		{ title .. ": " },
		{ message, "ErrorMsg" },
	}, true)
end

---@param message string
---@param history? boolean
function M.message(message, history)
	history = history or false
	echo({ { message, "Normal" } }, history)
end

return M
