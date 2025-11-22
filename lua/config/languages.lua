local M = {}
local lua_ls = {
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
		},
	},
}
local vtsls = {
	settings = {
		typescript = {
			tsserver = {
				maxTsServerMemory = 8192, -- Example: 8GB (in MB)
			},
		},
		javascript = {
			tsserver = {
				maxTsServerMemory = 8192, -- Example: 8GB (in MB)
			},
		},
	},
	reuse_client = function()
		return true
	end,
	on_attach = function()
		local keymap = require("config.keymap")
		keymap.map(
			keymap.normalMode,
			keymap.leader .. "fM",
			keymap.getCommand("VtsExec organize_imports"),
			{ desc = "general format imports" }
		)
	end,
}
local html = { filetypes = { "html", "templ", "htmlangular" } }
local eslint = {
	on_init = function(client)
		client.config.settings.workingDirectory = { directory = client.config.root_dir }
	end,
}
local angularls = { filetypes = { "htmlangular" } }
local omnisharp = {
	on_attach = function(_, bufnr)
		print("OmniSharp attached to buffer " .. bufnr)
	end,
}

---@class LanguageConfig
---@field config table
---@field server_name? string
---@field skip? boolean

---@param key string
---@param language_config LanguageConfig
local function mapServerName(key, language_config)
	if language_config.server_name then
		return language_config.server_name
	end
	return key
end

---@param language_config LanguageConfig
local function shouldNotSkip(_, language_config)
	return not language_config.skip
end

---@param acc { [string]: LanguageConfig }
---@param k string
---@param v LanguageConfig
local function foldLanguageConfigs(acc, k, v)
	acc[k] = v
	return acc
end

---@type { [string]: LanguageConfig }
local language_configs = {
	lua_ls = { config = lua_ls },
	vtsls = { config = vtsls },
	pylsp = { config = {} },
	html = { config = html },
	cssls = { config = {} },
	tailwindcss = { config = {} },
	eslint = { config = eslint },
	angularls = { config = angularls },
	omnisharp = { config = omnisharp },
	jdtls = { config = {} },
	sonarlint = { config = {}, server_name = "sonarlint-language-server", skip = true },
	stylua = { config = {} },
	svelte = { config = {} },
}

---@type string[]
M.ensure_installed = vim.iter(language_configs):map(mapServerName):totable()
---@type { [string]: LanguageConfig }
M.language_configs = vim.iter(language_configs):filter(shouldNotSkip):fold({}, foldLanguageConfigs)

return M
