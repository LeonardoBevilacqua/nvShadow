---@param filename string
---@return boolean
local function file_exists(filename)
	return vim.fn.empty(vim.fn.glob(filename)) == 0
end
---@param values string[]
---@param separator? string
---@return string
local function join(values, separator)
	separator = separator or " "
	return table.concat(values, separator)
end
---@return string
local function get_current_cs_file()
	local ts = vim.treesitter
	local parser = ts.get_parser(0, "c_sharp", { error = false })
	if parser == nil then
		return ""
	end
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

	return ""
end
---@return string
local function get_current_java_file()
	local ts = vim.treesitter
	local parser = ts.get_parser(0, "java", { error = false })
	if parser == nil then
		return ""
	end
	local tree = parser:parse()[1]
	local root = tree:root()

	local query = ts.query.parse("java", [[ (class_declaration name: (identifier) @class) ]])

	local class_name

	for id, node in query:iter_captures(root, 0) do
		local name = query.captures[id]

		local text = vim.treesitter.get_node_text(node, 0)

		if name == "class" then
			class_name = text
		end
	end

	if class_name then
		return class_name
	end

	return ""
end

---@type TestAdapter
local jest_adapter = {
	enabled = file_exists(vim.fn.getcwd() .. "/package.json"),
	base_cmd = "npm run test",
	file_cmd = function(self)
		local file_path = vim.fn.expand("%"):gsub("\\", "/")
		return join({ self.base_cmd, "-- " .. file_path })
	end,
	coverage_cmd = function(_, command)
		local cmd = "npm run test:coverage"
		if command == "QuickTestAll" then
			return cmd
		end

		local file_arg = "-- " .. vim.fn.expand("%"):gsub("\\", "/")
		return cmd .. (" %s %s"):format(file_arg, "--collectCoverageFrom=" .. vim.fn.expand("%:p:h"))
	end,
	debug_cmd = function(_, command)
		local cmd = "npm run --node-options --inspect test"
		if command == "QuickTestAll" then
			return cmd
		end

		local file_arg = "-- " .. vim.fn.expand("%"):gsub("\\", "/")
		return join({ cmd, file_arg })
	end,
}
---@type TestAdapter
local dotnet_adapter = {
	enabled = file_exists(vim.fn.getcwd() .. "/*.sln"),
	base_cmd = "dotnet test",
	file_cmd = function(self)
		local filename = get_current_cs_file()
		if filename == "" then
			return ""
		end

		return join({ self.base_cmd, "--filter " .. filename })
	end,
	coverage_cmd = function(self, command)
		local coverage_arg = '--collect:"XPlat Code Coverage;Format=lcov"'
		if command == "QuickTestAll" then
			return join({ self.base_cmd, coverage_arg })
		end

		return join({ self:file_cmd(), coverage_arg })
	end,
}
---@type TestAdapter
local java_mvn_adapter = {
	enabled = file_exists(vim.fn.getcwd() .. "/pom.xml"),
	base_cmd = "mvn test -Djacoco.skip=true",
	file_cmd = function(self)
		local filename = get_current_java_file()
		if filename == "" then
			return ""
		end

		return join({ self.base_cmd, "-Dtest=" .. filename })
	end,
	coverage_cmd = function(self, command)
		local coverage_arg_to_remove = "-Djacoco.skip=true"
		local cmd = ""
		if command == "QuickTestAll" then
			cmd = self.base_cmd:gsub(coverage_arg_to_remove, "")
		else
			cmd = self:file_cmd():gsub(coverage_arg_to_remove, "")
		end

		return cmd
	end,
	debug_cmd = function(self, command)
		local debug_arg = "-Dmaven.surefire.debug"
		local cmd = ""
		if command == "QuickTestAll" then
			cmd = join({ self.base_cmd, debug_arg })
		else
			cmd = join({ self:file_cmd(), debug_arg })
		end

		return cmd
	end,
}

local quick_test = require("quick-test")

quick_test.setup({ adapters = { jest_adapter, dotnet_adapter, java_mvn_adapter } })
