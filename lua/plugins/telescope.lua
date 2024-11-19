return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			-- general purpose plugin used to build user interfaces in neovim plugins
			"nvim-lua/plenary.nvim",
		},
		cmd = "Telescope",
		opts = {
			defaults = {
				prompt_prefix = "   ",
				selection_caret = " ",
				entry_prefix = " ",
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
					},
					width = 0.87,
					height = 0.80,
				},
				mappings = {
					n = { ["q"] = require("telescope.actions").close },
				},
			},

			extensions_list = { "themes", "terms" },
			extensions = {},
		},
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			-- get access to telescopes navigation functions
			local actions = require("telescope.actions")

			require("telescope").setup({
				-- use ui-select dropdown as our ui
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
				-- set keymappings to navigate through items in the telescope io
				mappings = {
					i = {
						-- use <cltr> + n to go to the next option
						["<C-n>"] = actions.cycle_history_next,
						-- use <cltr> + p to go to the previous option
						["<C-p>"] = actions.cycle_history_prev,
						-- use <cltr> + j to go to the next preview
						["<C-j>"] = actions.move_selection_next,
						-- use <cltr> + k to go to the previous preview
						["<C-k>"] = actions.move_selection_previous,
					},
				},
				-- load the ui-select extension
				require("telescope").load_extension("ui-select"),
			})
		end,
	},
}
