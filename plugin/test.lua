---@class Adapter
---@field cmd string
---@field file fun(): string
---@field enabled boolean

---@class TestConfig
---@field adapters Adapter[]

local M = {}
---@param filename string
local function file_exists(filename)
	return vim.fn.empty(vim.fn.glob(filename)) == 0
end
---@param values string[]
---@param separator? string
local function join(values, separator)
	separator = separator or " "
	return table.concat(values, separator)
end

---@param cmd string
M.run_term_cmd = function(cmd)
	vim.cmd('hor term "' .. cmd .. '"')
	vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.25))
end

---@param config TestConfig
M.setup = function(config)
	for _, adapter in ipairs(config.adapters) do
		if adapter.enabled then
			vim.api.nvim_create_user_command("TermTest", function()
				M.run_term_cmd(adapter.cmd)
			end, {})

			vim.api.nvim_create_user_command("TermTestFile", function()
				local cmd = join({ adapter.cmd, adapter.file() })
				M.run_term_cmd(cmd)
			end, {})

			break
		end
	end

	vim.api.nvim_create_user_command("TermExec", function(opts)
		M.run_term_cmd(opts.args)
	end, { nargs = 1 })
end

local function get_current_cs_file()
	local ts = vim.treesitter
	local parser = ts.get_parser(0, "c_sharp")
	local tree = parser:parse()[1]
	local root = tree:root()

	local query = ts.query.parse(
		"c_sharp",
		[[
    (file_scoped_namespace_declaration name: (qualified_name) @namespace)
    (class_declaration name: (identifier) @class)
  ]]
	)

	local namespace, class_name

	for id, node in query:iter_captures(root, 0) do
		local name = query.captures[id]

		local text = vim.treesitter.get_node_text(node, 0)

		if name == "namespace" then
			namespace = text
		elseif name == "class" then
			class_name = text
		end
	end

	if namespace and class_name then
		return join({ namespace, class_name }, ".")
	end

	return nil
end

---@type Adapter
local jest_adapter = {
	cmd = "npm run test",
	file = function()
		return join({ "--", vim.fn.expand("%"):gsub("\\", "/") })
	end,
	enabled = file_exists(vim.fn.getcwd() .. "/package.json"),
}
---@type Adapter
local dotnet_adapter = {
	cmd = "dotnet test",
	file = function()
		return join({ "--filter", get_current_cs_file() })
	end,
	enabled = file_exists(vim.fn.getcwd() .. "/*.sln"),
}
---@type Adapter[]
local adapters = { jest_adapter, dotnet_adapter }

M.setup({ adapters = adapters })
