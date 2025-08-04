local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.exec_cmd(params)
end

local function omniSharpDLL()
	local omnisharp_path = vim.fn.stdpath("data") .. "/mason/packages/omnisharp"
	return vim.fn.glob(omnisharp_path .. "/OmniSharp.dll")
end

local ensure_installed = {
	"lua_ls",
	"ts_ls",
	"pylsp",
	"html",
	"cssls",
	"tailwindcss",
	"eslint",
	"angularls",
	"omnisharp",
	"jdtls",
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
		on_attach = function()
			local keymap = require("config.keymap")
			keymap.map(
				keymap.normalMode,
				keymap.leader .. "fM",
				keymap.getCommand("OrganizeImports"),
				{ desc = "general format imports" }
			)
		end,
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
	angularls = { filetypes = { "htmlangular" } },
	omnisharp = {

		-- Optional: diagnostics, mappings, formatting, etc.
		on_attach = function(_, bufnr)
			print("OmniSharp attached to buffer " .. bufnr)
			-- keymaps can go here if needed
		end,
	},
	jdtls = {},
}

return { servers = servers, ensure_installed = ensure_installed }
