local utils = require("config.utils")

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path

		if name == "LuaSnip" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("LuaSnip")
			end
			--- @type vim.SystemOpts
			local opts = { cwd = path, text = true }
			vim.system({ "make", "install_jsregexp" }, opts, function(obj)
				if obj.code ~= 0 then
					utils.error_message("LuaSnip", "build failed:\n" .. obj.stderr)
				else
					utils.success_message("LuaSnip", "jsregexp installed")
				end
			end)
		end
	end,
})

vim.pack.add({ "https://github.com/rafamadriz/friendly-snippets" })
vim.pack.add({ { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.x") } })
vim.pack.add({ { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") } })

require("luasnip").config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	region_check_events = "InsertEnter",
	delete_check_events = "TextChanged,InsertLeave",
})
require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<C-j>"] = { "select_next", "fallback_to_mappings" },
		["<C-k>"] = { "select_prev", "fallback_to_mappings" },
		["<CR>"] = { "select_and_accept", "fallback" },
	},

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},
	signature = { enabled = true },
	snippets = { preset = "luasnip" },
	completion = {
		menu = {
			draw = {
				columns = {
					{ "kind_icon", "label", "label_description", gap = 1 },
					{ "kind" },
				},
			},
		},
	},
})
