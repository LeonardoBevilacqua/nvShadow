local cmd = {
	"sonarlint-language-server",
	"-stdio",
	"-analyzers",
	vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
	vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
	vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
	vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
}
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
