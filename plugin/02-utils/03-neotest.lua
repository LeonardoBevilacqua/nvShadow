local function is_windows()
	return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

vim.pack.add({
	"https://github.com/antoinemadec/FixCursorHold.nvim",
	"https://github.com/nvim-neotest/neotest-jest",
	"https://github.com/rcasia/neotest-java",
	"https://github.com/nvim-neotest/neotest",
}, { load = not is_windows() })

local keymap = require("config.keymap")
local neotest = require("neotest")

require("neotest").setup({
	adapters = {
		require("neotest-jest")({
			jestCommand = "npm test --",
			jestConfigFile = "",
			env = { CI = true },
			cwd = function()
				return vim.fn.getcwd()
			end,
		}),
		require("neotest-java")({}),
	},
})

keymap.map(keymap.normalMode, keymap.leader .. "tf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run File (Neotest)" })
keymap.map(keymap.normalMode, keymap.leader .. "tT", function()
	neotest.run.run(vim.uv.cwd())
end, { desc = "Run All Test Files (Neotest)" })
keymap.map(keymap.normalMode, keymap.leader .. "tr", function()
	neotest.run.run()
end, { desc = "Run Nearest (Neotest)" })
keymap.map(keymap.normalMode, keymap.leader .. "tDr", function()
	neotest.run.run({ strategy = "dap" })
end, { desc = "Run Debug Nearest (Neotest)" })
keymap.map(keymap.normalMode, keymap.leader .. "tl", function()
	neotest.run.run_last()
end, { desc = "Run Last (Neotest)" })
keymap.map(keymap.normalMode, keymap.leader .. "ts", function()
	neotest.summary.toggle()
end, { desc = "Toggle Summary (Neotest)" })
keymap.map(keymap.normalMode, keymap.leader .. "to", function()
	neotest.output.open({ enter = true, auto_close = true })
end, { desc = "Show Output (Neotest)" })
keymap.map(keymap.normalMode, keymap.leader .. "tO", function()
	neotest.output_panel.toggle()
end, { desc = "Toggle Output Panel (Neotest)" })
keymap.map(keymap.normalMode, keymap.leader .. "tS", function()
	neotest.run.stop()
end, { desc = "Stop (Neotest)" })
keymap.map(keymap.normalMode, keymap.leader .. "tW", function()
	neotest.watch.toggle(vim.fn.expand("%"))
end, { desc = "Toggle Watch (Neotest)" })
