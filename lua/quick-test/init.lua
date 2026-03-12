---@class TestAdapter
---@field enabled boolean
---@field base_cmd string
---@field file_cmd fun(self: TestAdapter): string
---@field debug_cmd (fun(self: TestAdapter, command: "QuickTestAll" | "QuickTestFile"): string) | nil
---@field coverage_cmd (fun(self: TestAdapter, command: "QuickTestAll" | "QuickTestFile"): string) | nil

---@class QuickTestConfig
---@field adapters TestAdapter[]

local M = {}
local vim_command = {
	ALL = "QuickTestAll",
	FILE = "QuickTestFile",
}

local vim_command_options = { DEBUG = "debug", COVERAGE = "coverage" }
local create_command = vim.api.nvim_create_user_command

---@return boolean
local function is_windows()
	return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

---@param cmd string
local function run_term_cmd(cmd)
	if is_windows() then
		vim.cmd('hor term "' .. cmd .. '"')
	else
		vim.cmd("hor term " .. cmd)
	end
	vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.25))
end

---@param adapter TestAdapter
local function generate_cmd_opts(adapter)
	local options = {}
	if adapter.debug_cmd then
		table.insert(options, vim_command_options.DEBUG)
	end
	if adapter.coverage_cmd then
		table.insert(options, vim_command_options.COVERAGE)
	end

	return {
		nargs = "*",
		complete = function(arg_lead)
			local matches = {}
			for _, opt in ipairs(options) do
				if opt:find("^" .. arg_lead) then
					table.insert(matches, opt)
				end
			end
			return matches
		end,
	}
end

---@param adapter TestAdapter
---@param opts vim.api.keyset.create_user_command.command_args
---@param command "QuickTestAll" | "QuickTestFile")
local function handle_test(adapter, opts, command)
	local should_run_debug = opts.args == vim_command_options.DEBUG and adapter.debug_cmd ~= nil
	local should_run_coverage = opts.args == vim_command_options.COVERAGE and adapter.coverage_cmd ~= nil

	if should_run_debug then
		run_term_cmd(adapter:debug_cmd(command))
		return
	end

	if should_run_coverage then
		run_term_cmd(adapter:coverage_cmd(command))
		return
	end

	if command == "QuickTestFile" then
		run_term_cmd(adapter:file_cmd())
		return
	end

	run_term_cmd(adapter.base_cmd)
end

---@param adapter TestAdapter
local function setup_adapter(adapter)
	if not adapter.enabled then
		return
	end

	local cmd_opts = generate_cmd_opts(adapter)
	for _, command in pairs(vim_command) do
		create_command(command, function(opts)
			handle_test(adapter, opts, command)
		end, cmd_opts)
	end
end

---@param config QuickTestConfig
M.setup = function(config)
	vim.notify("Setting up quick test", vim.log.levels.INFO)
	for _, adapter in ipairs(config.adapters) do
		setup_adapter(adapter)
	end
end

return M
