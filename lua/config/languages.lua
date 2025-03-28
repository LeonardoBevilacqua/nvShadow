local ensure_installed = {
	"lua_ls",
	"ts_ls",
	"pylsp",
	"html",
	"cssls",
	"tailwindcss",
	"eslint",
	{ "angularls", version = "15.2.1" },
}
local servers = {
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},
	ts_ls = {},
	pylsp = {},
	html = { filetypes = { "html", "templ", "htmlangular" } },
	cssls = {},
	tailwindcss = {
		root_dir = function(fname)
			local root_pattern =
				require("lspconfig").util.root_pattern("tailwind.config.cjs", "tailwind.config.js", "postcss.config.js")
			return root_pattern(fname)
		end,
	},
	eslint = {
		on_init = function(client)
			client.config.settings.workingDirectory = { directory = client.config.root_dir }
		end,
	},
	angularls = {},
}

return { servers = servers, ensure_installed = ensure_installed }
