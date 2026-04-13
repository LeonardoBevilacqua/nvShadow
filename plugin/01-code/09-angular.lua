vim.filetype.add({
	pattern = {
		[".*%.component%.html"] = "htmlangular", -- Sets the filetype to `htmlangular` if it matches the pattern
	},
})
vim.pack.add({ "https://github.com/joeveiga/ng.nvim", "https://github.com/dlvandenberg/tree-sitter-angular" })

local found_file = vim.fn.findfile("angular.json", ".")
if type(found_file) == "string" and (found_file == nil or found_file == "") then
	return
end

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
