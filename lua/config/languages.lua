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
	html = {},
	cssls = {},
	tailwindcss = {},
	eslint = {},
}

return { servers = servers }
