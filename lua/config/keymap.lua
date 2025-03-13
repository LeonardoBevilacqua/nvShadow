local normalMode = "n"
local visualMode = "v"
local terminalMode = "t"
local insertMode = "i"
local cmd = "<cmd>"
local enter = "<CR>"
local esc = "<Esc>"
local leader = "<Leader>"
local map = vim.keymap.set

local function getCommand(command)
	return cmd .. command .. enter
end

local function getCtrlCommand(command)
	return "<C-" .. command .. ">"
end

-- setup leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- vim helpers
map(normalMode, leader .. leader .. "vx", getCommand("source %"), { desc = "Source the current file" })
map(normalMode, leader .. "vx", getCommand(".lua"), { desc = "Run the current line" })
map(visualMode, leader .. "vx", ":lua" .. enter, { desc = "Run the current lines" })
map(normalMode, ";", ":", { desc = "CMD enter command mode" })
map(terminalMode, esc .. esc, getCtrlCommand("\\") .. getCtrlCommand("n"), { desc = "Exit terminal mode" })
map(normalMode, esc, getCommand("nohlsearch"), { desc = "Remove serach highlights" })
map(insertMode, "jk", esc, { desc = "Leave insert mode" })

-- window navigation
map(
	normalMode,
	getCtrlCommand("h"),
	getCtrlCommand("w") .. getCtrlCommand("h"),
	{ desc = "Move focus to the left window" }
)
map(
	normalMode,
	getCtrlCommand("l"),
	getCtrlCommand("w") .. getCtrlCommand("l"),
	{ desc = "Move focus to the right window" }
)
map(
	normalMode,
	getCtrlCommand("j"),
	getCtrlCommand("w") .. getCtrlCommand("j"),
	{ desc = "Move focus to the lower window" }
)
map(
	normalMode,
	getCtrlCommand("k"),
	getCtrlCommand("w") .. getCtrlCommand("k"),
	{ desc = "Move focus to the upper window" }
)

-- Easily split windows
map(normalMode, leader .. "wv", getCommand("vsplit"), { desc = "Window Split Vertical" })
map(normalMode, leader .. "wh", getCommand("split"), { desc = "Window Split Horizontal" })

-- Stay in indent mode
map(visualMode, "<", "<gv", { desc = "Indent left in visual mode" })
map(visualMode, ">", ">gv", { desc = "Indent right in visual mode" })

-- spell
map(normalMode, leader .. "Ss", getCommand("set spell"), { desc = "Set spell" })
map(normalMode, leader .. "Sns", getCommand("set nospell"), { desc = "Set no spell" })

-- buffers
map(normalMode, "<Tab>", getCommand("bnext"), { desc = "Next buffer" })
map(normalMode, "<S-Tab>", getCommand("bprevious"), { desc = "Previous buffer" })
map(normalMode, leader .. "x", getCommand("bdelete"), { desc = "Close buffer" })

-- explorer
map(normalMode, getCtrlCommand("n"), ":Explore" .. enter, { desc = "Open Explorer" })

return {
	normalMode = normalMode,
	visualMode = visualMode,
	terminalMode = terminalMode,
	insertMode = insertMode,
	cmd = cmd,
	enter = enter,
	esc = esc,
	leader = leader,
	map = map,
	getCommand = getCommand,
	getCtrlCommand = getCtrlCommand,
}
