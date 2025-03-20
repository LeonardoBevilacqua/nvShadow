return {
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		keys = {
			{
				"<leader>taf",
				function()
					-- If autoformat is currently disabled for this buffer,
					-- then enable it, otherwise disable it
					if vim.b.disable_autoformat then
						vim.cmd("FormatEnable")
						vim.notify("Enabled autoformat for current buffer")
					else
						vim.cmd("FormatDisable!")
						vim.notify("Disabled autoformat for current buffer")
					end
				end,
				desc = "Toggle autoformat for current buffer",
			},
			{
				"<leader>taF",
				function()
					-- If autoformat is currently disabled globally,
					-- then enable it globally, otherwise disable it globally
					if vim.g.disable_autoformat then
						vim.cmd("FormatEnable")
						vim.notify("Enabled autoformat globally")
					else
						vim.cmd("FormatDisable")
						vim.notify("Disabled autoformat globally")
					end
				end,
				desc = "Toggle autoformat globally",
			},
		},
		config = function()
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
					local disable_filetypes = { c = false, cpp = false }
					return {
						timeout_ms = 500,
						lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
					}
				end,
			})

			local keymap = require("config.keymap")
			keymap.map({ keymap.normalMode, keymap.visualMode }, keymap.leader .. "fm", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "general format file" })

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
		end,
	},
	{
		"zapling/mason-conform.nvim",
		dependencies = { "mason.nvim", "conform.nvim" },
		config = function()
			require("mason-conform").setup({})
		end,
	},
}
