local keymap = require("config.keymap")
local function normalize_path(path)
	return path:gsub("\\", "/")
end

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-jest",
	},
	config = function()
		local function is_windows()
			return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
		end

		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = is_windows() and "npm.cmd test --" or "npm test --",
					jestConfigFile = "",
					--jestCommand = is_windows() and "npx.cmd jest" or "npm test --",
					--jestConfigFile = function()
					--local base_dir = vim.fn.getcwd()
					--return base_dir .. "/jest.config.js"
					--end,
					env = { CI = true },
					cwd = function()
						return vim.fn.getcwd()
					end,
				}),
			},
		})
	end,
	keys = {
		{
			keymap.leader .. "tt",
			function()
				require("neotest").run.run(normalize_path(vim.fn.expand("%")))
			end,
			desc = "Run File (Neotest)",
		},
		{
			keymap.leader .. "tT",
			function()
				require("neotest").run.run(vim.uv.cwd())
			end,
			desc = "Run All Test Files (Neotest)",
		},
		{
			keymap.leader .. "tr",
			function()
				require("neotest").run.run()
			end,
			desc = "Run Nearest (Neotest)",
		},
		{
			keymap.leader .. "tl",
			function()
				require("neotest").run.run_last()
			end,
			desc = "Run Last (Neotest)",
		},
		{
			keymap.leader .. "ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle Summary (Neotest)",
		},
		{
			keymap.leader .. "to",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Show Output (Neotest)",
		},
		{
			keymap.leader .. "tO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle Output Panel (Neotest)",
		},
		{
			keymap.leader .. "tS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop (Neotest)",
		},
		{
			keymap.leader .. "tW",
			function()
				require("neotest").watch.toggle(vim.fn.expand("%"))
			end,
			desc = "Toggle Watch (Neotest)",
		},
	},
}
