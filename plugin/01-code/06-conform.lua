vim.pack.add({
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/zapling/mason-conform.nvim",
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "prettier" },
		html = { "prettier" },
		typescriptreact = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		javascript = { "prettier" },
	},
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end

		return {
			timeout_ms = 500,
			lsp_format = "fallback",
		}
	end,
})
require("mason-conform").setup({})

local keymap = require("config.keymap")
keymap.map({ keymap.normalMode, keymap.visualMode }, keymap.leader .. "fm", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "general format file" })
keymap.map(keymap.normalMode, keymap.leader .. "taf", function()
	-- If autoformat is currently disabled for this buffer,
	-- then enable it, otherwise disable it
	if vim.b.disable_autoformat then
		vim.cmd("FormatEnable")
		vim.notify("Enabled autoformat for current buffer")
	else
		vim.cmd("FormatDisable!")
		vim.notify("Disabled autoformat for current buffer")
	end
end, { desc = "Toggle autoformat for current buffer" })
keymap.map(keymap.normalMode, keymap.leader .. "taF", function()
	-- If autoformat is currently disabled globally,
	-- then enable it globally, otherwise disable it globally
	if vim.g.disable_autoformat then
		vim.cmd("FormatEnable")
		vim.notify("Enabled autoformat globally")
	else
		vim.cmd("FormatDisable")
		vim.notify("Disabled autoformat globally")
	end
end, { desc = "Toggle autoformat globally" })

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- :FormatDisable! disables autoformat for this buffer only
		vim.b.disable_autoformat = true
	else
		-- :FormatDisable disables autoformat globally
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true, -- allows the ! variant
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})
