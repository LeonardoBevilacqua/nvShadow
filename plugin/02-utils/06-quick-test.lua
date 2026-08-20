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

local class_types = {
	class_declaration = true,
	class_definition = true,
}
local function get_first_class_name()
	local parser = vim.treesitter.get_parser(0)
	if not parser then
		return nil
	end

	local root = parser:parse()[1]:root()

	local function find_class(n)
		if class_types[n:type()] then
			local node_name = n:field("name")[1]
			if node_name then
				return vim.treesitter.get_node_text(node_name, 0)
			end
		end
		for child in n:iter_children() do
			local name = find_class(child)
			if name then
				return name
			end
		end
		return nil
	end

	return find_class(root)
end

local function get_class_name()
	local node = vim.treesitter.get_node()
	if not node then
		return ""
	end

	while node do
		if class_types[node:type()] then
			local node_name = node:field("name")[1]
			if not node_name then
				break
			end
			return vim.treesitter.get_node_text(node_name, 0)
		end
		node = node:parent()
	end

	return get_first_class_name()
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
		local filename = get_class_name()
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
		local filename = get_class_name()
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
-- Gradle only writes results to build/reports/tests/test/index.html by default.
-- This init script streams each test's pass/fail/skip result plus a summary line
-- to the console, so quick-test shows the outcome directly in its log.
local gradle_init_script = vim.fn.stdpath("data") .. "/quick-test-gradle-init.gradle"
vim.fn.writefile({
	"allprojects {",
	"    tasks.withType(Test).configureEach {",
	"        testLogging {",
	'            events "passed", "skipped", "failed"',
	'            exceptionFormat = "full"',
	"            showCauses = true",
	"            showStackTraces = true",
	"        }",
	"        afterSuite { desc, result ->",
	"            if (desc.parent == null) {",
	'                println "Test result: ${result.resultType} - ${result.testCount} tests, ${result.successfulTestCount} passed, ${result.failedTestCount} failed, ${result.skippedTestCount} skipped"',
	"            }",
	"        }",
	"    }",
	"}",
}, gradle_init_script)

local java_gradle_adapter = {
	enabled = file_exists(vim.fn.getcwd() .. "/build.gradle") or file_exists(vim.fn.getcwd() .. "/build.gradle.kts"),
	-- cleanTest forces the test task to actually run instead of being skipped as
	-- UP-TO-DATE, which is what opens the --debug-jvm port (5005) on every run and
	-- ensures the test logging below always fires. --init-script enables that logging.
	base_cmd = './gradlew cleanTest test --init-script "' .. gradle_init_script .. '"',
	file_cmd = function(self)
		local filename = get_class_name()
		if filename == "" then
			return ""
		end

		return join({ self.base_cmd, "--tests " .. filename })
	end,
	coverage_cmd = function(self, command)
		local cmd = ""
		if command == "QuickTestAll" then
			cmd = self.base_cmd
		else
			cmd = self:file_cmd()
		end

		return cmd
	end,
	debug_cmd = function(self, command)
		local debug_arg = "--debug-jvm"
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

quick_test.setup({ adapters = { jest_adapter, dotnet_adapter, java_mvn_adapter, java_gradle_adapter } })
