return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local keymap = require("config.keymap")

				-- Navigation
				keymap.map(keymap.normalMode, "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Git next hunk" })

				keymap.map(keymap.normalMode, "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Git previous hunk" })

				-- Actions
				keymap.map(keymap.normalMode, keymap.leader .. "hs", gitsigns.stage_hunk, { desc = "Git stage hunk" })
				keymap.map(keymap.normalMode, keymap.leader .. "hr", gitsigns.reset_hunk, { desc = "Git reset hunk" })

				keymap.map(keymap.visualMode, keymap.leader .. "hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line(keymap.visualMode) })
				end, { desc = "Git stage hunk" })

				keymap.map(keymap.visualMode, keymap.leader .. "hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line(keymap.visualMode) })
				end, { desc = "Git reset hunk" })

				keymap.map(
					keymap.normalMode,
					keymap.leader .. "hS",
					gitsigns.stage_buffer,
					{ desc = "Git stage buffer" }
				)
				keymap.map(
					keymap.normalMode,
					keymap.leader .. "hR",
					gitsigns.reset_buffer,
					{ desc = "Git reset buffer" }
				)
				keymap.map(
					keymap.normalMode,
					keymap.leader .. "hp",
					gitsigns.preview_hunk,
					{ desc = "Git preview hunk" }
				)
				keymap.map(
					keymap.normalMode,
					keymap.leader .. "hi",
					gitsigns.preview_hunk_inline,
					{ desc = "Git prview hunk inline" }
				)

				keymap.map(keymap.normalMode, keymap.leader .. "hb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "Git blame line" })

				keymap.map(keymap.normalMode, keymap.leader .. "hd", gitsigns.diffthis, { desc = "Git diff this" })

				keymap.map(keymap.normalMode, keymap.leader .. "hD", function()
					gitsigns.diffthis("~")
				end, { desc = "Git diff this" })

				keymap.map(keymap.normalMode, keymap.leader .. "hQ", function()
					gitsigns.setqflist("all")
				end, { desc = "Git quickfix list with hunks" })
				keymap.map(
					keymap.normalMode,
					keymap.leader .. "hq",
					gitsigns.setqflist,
					{ desc = "Git quickfix list with hunks" }
				)

				-- Toggles
				keymap.map(
					keymap.normalMode,
					keymap.leader .. "tb",
					gitsigns.toggle_current_line_blame,
					{ desc = "Git toggle current line blame" }
				)
				keymap.map(
					keymap.normalMode,
					keymap.leader .. "td",
					gitsigns.toggle_deleted,
					{ desc = "Git toggle deleted" }
				)
				keymap.map(
					keymap.normalMode,
					keymap.leader .. "tw",
					gitsigns.toggle_word_diff,
					{ desc = "Git toggle word diff" }
				)

				-- Text object
				keymap.map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Git select hunk" })
			end,
		})
	end,
}
