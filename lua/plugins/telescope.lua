return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup({
			defaults = {
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "top",
					},
				},
				mappings = {
					i = {
						["<C-j>"] = require("telescope.actions").move_selection_next,
						["<C-k>"] = require("telescope.actions").move_selection_previous,
					},
				},
			},
		})
		local keymap = require("config.keymap")

		keymap.map(
			keymap.normalMode,
			keymap.leader .. "fw",
			keymap.getCommand("Telescope live_grep"),
			{ desc = "telescope live grep" }
		)
		keymap.map(
			keymap.normalMode,
			keymap.leader .. "fb",
			keymap.getCommand("Telescope buffers"),
			{ desc = "telescope find buffers" }
		)
		keymap.map(
			keymap.normalMode,
			keymap.leader .. "fh",
			keymap.getCommand("Telescope help_tags"),
			{ desc = "telescope help page" }
		)
		keymap.map(
			keymap.normalMode,
			keymap.leader .. "ma",
			keymap.getCommand("Telescope marks"),
			{ desc = "telescope find marks" }
		)
		keymap.map(
			keymap.normalMode,
			keymap.leader .. "fo",
			keymap.getCommand("Telescope oldfiles"),
			{ desc = "telescope find oldfiles" }
		)
		keymap.map(
			keymap.normalMode,
			keymap.leader .. "fz",
			keymap.getCommand("Telescope current_buffer_fuzzy_find"),
			{ desc = "telescope find in current buffer" }
		)
		keymap.map(
			keymap.normalMode,
			keymap.leader .. "cm",
			keymap.getCommand("Telescope git_commits"),
			{ desc = "telescope git commits" }
		)
		keymap.map(
			keymap.normalMode,
			keymap.leader .. "gt",
			keymap.getCommand("Telescope git_status"),
			{ desc = "telescope git status" }
		)
		keymap.map(
			keymap.normalMode,
			keymap.leader .. "pt",
			keymap.getCommand("Telescope terms"),
			{ desc = "telescope pick hidden term" }
		)

		keymap.map(
			keymap.normalMode,
			keymap.leader .. "ff",
			keymap.getCommand("Telescope find_files"),
			{ desc = "telescope find files" }
		)
		keymap.map(
			keymap.normalMode,
			keymap.leader .. "fa",
			keymap.getCommand("Telescope find_files follow=true no_ignore=true hidden=true"),
			{ desc = "telescope find all files" }
		)
	end,
}
