local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

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
	ts_ls = {
		commands = {
			OrganizeImports = {
				organize_imports,
				description = "Organize imports",
			},
		},
	},
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
