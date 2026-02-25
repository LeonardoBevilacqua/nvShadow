local analyzer_base = vim.fn.expand("$MASON/share/sonarlint-analyzers/")
local ft_to_analyzer = {
	java = "sonarjava.jar",
	javascript = "sonarjs.jar",
	typescript = "sonarjs.jar",
	python = "sonarpython.jar",
	c = "sonarcfamily.jar",
	cpp = "sonarcfamily.jar",
}

local function detect_project_filetypes()
	local root = vim.fn.getcwd()
	local filetypes = {}
	local markers = {
		java = { "pom.xml", "build.gradle", "build.gradle.kts", "mvnw", "gradlew" },
		javascript = { "package.json" },
		typescript = { "tsconfig.json" },
		python = { "requirements.txt", "pyproject.toml", "setup.py", "Pipfile" },
		c = { "CMakeLists.txt", "Makefile", "compile_commands.json" },
		cpp = { "CMakeLists.txt", "Makefile", "compile_commands.json" },
		rust = { "Cargo.toml" },
		cs = { "*.csproj", "*.sln" },
	}
	for ft, files in pairs(markers) do
		for _, file in ipairs(files) do
			if file:find("*") then
				if #vim.fn.glob(root .. "/" .. file, false, true) > 0 then
					filetypes[ft] = true
					break
				end
			elseif (vim.uv or vim.loop).fs_stat(root .. "/" .. file) then
				filetypes[ft] = true
				break
			end
		end
	end
	return vim.tbl_keys(filetypes)
end

local function build_analyzer_args()
	local project_fts = detect_project_filetypes()
	local seen = {}
	local args = {}
	for _, ft in ipairs(project_fts) do
		local jar = ft_to_analyzer[ft]
		if jar and not seen[jar] then
			seen[jar] = true
			table.insert(args, analyzer_base .. jar)
		end
	end
	return args
end

local analyzers = build_analyzer_args()
local cmd = vim.list_extend({ "sonarlint-language-server", "-stdio", "-analyzers" }, analyzers)
local settings = {
	sonarlint = {
		connectedMode = {
			connections = {
				sonarqube = {
					{
						connectionId = "DMS_FE",
						serverUrl = vim.fn.getenv("SONAR_SERVER_URL"),
						disableNotifications = false,
					},
				},
			},
		},
		-- rules = {
		-- 	["typescript:S101"] = { level = "on", parameters = { format = "^[A-Z][a-zA-Z0-9]*$" } },
		-- 	["typescript:S103"] = { level = "on", parameters = { maximumLineLength = 18 } },
		-- 	["typescript:S106"] = { level = "on" },
		-- 	["typescript:S107"] = { level = "on", parameters = { maximumFunctionParameters = 7 } },
		-- },
	},
}
local server = {
	cmd = cmd,
	settings = settings,
	before_init = function(params, config)
		local project_root_and_ids = {}
		local root_and_ids = vim.fn.getenv("PROJECT_ROOT_AND_IDS")

		if root_and_ids ~= vim.NIL then
			for _, root_id in pairs(vim.split(root_and_ids, ";")) do
				local root_id_table = vim.split(root_id, "#")
				project_root_and_ids[root_id_table[1]] = root_id_table[2]
			end
		end

		config.settings.sonarlint.connectedMode.project = {
			connectionId = "DMS_FE",
			projectKey = project_root_and_ids[params.rootPath],
		}
	end,
}
local filetypes = {
	"javascript",
	"typescript",
	"java",
}

return { server = server, filetypes = filetypes }
