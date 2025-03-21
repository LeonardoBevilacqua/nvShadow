return {
	{
		"joeveiga/ng.nvim",
		cond = function()
			-- Check if angular.json exists in the current directory or anywhere in the project
			return vim.fn.filereadable(vim.fn.findfile("angular.json", ".")) > 0
		end,
		config = function()
			local ng = require("ng")
			local keymap = require("config.keymap")

			local opts = function(desc)
				return { noremap = true, silent = true, desc = desc }
			end

			keymap.map(
				keymap.normalMode,
				keymap.leader .. "at",
				ng.goto_template_for_component,
				opts("Angular go to template for component")
			)
			keymap.map(
				keymap.normalMode,
				keymap.leader .. "ac",
				ng.goto_component_with_template_file,
				opts("Angular go to component with template file")
			)
			keymap.map(keymap.normalMode, keymap.leader .. "aT", ng.get_template_tcb, opts("Angular get template"))
		end,
	},
	{ "dlvandenberg/tree-sitter-angular" },
}
