local normalMode = "n"
local visualMode = "v"
local terminalMode = "t"
local insertMode = "i"
local cmd = "<cmd>"
local enter = "<CR>"
local esc = "<Esc>"
local leader = "<Leader>"
local bar = "<bar>"
local map = vim.keymap.set

local function getCommand(command)
	return cmd .. command .. enter
end

local function getCtrlCommand(command)
	return "<C-" .. command .. ">"
end

local function getAltCommand(command)
	return "<M-" .. command .. ">"
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
map({ insertMode, normalMode, visualMode }, "<C-C>", esc, { desc = "Make Ctrl+C behave exactly like escape." })

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

-- Window resize
map(normalMode, leader .. "w+", getCommand("resize +5"), { desc = "Window increase height" })
map(normalMode, leader .. "w-", getCommand("resize -5"), { desc = "Window decrease height" })
map(normalMode, leader .. "w>", getCommand("vertical resize +5"), { desc = "Window decrease width" })
map(normalMode, leader .. "w<", getCommand("vertical resize -5"), { desc = "Window increase width" })
map(normalMode, leader .. "w=", getCommand("wincmd ="), { desc = "Window reset" })
map(normalMode, leader .. "wW=", getCommand("vertical resize"), { desc = "Window width focus" })
map(normalMode, leader .. "wH=", getCommand("resize"), { desc = "Window height focus" })
map(normalMode, leader .. "wF", getCommand("resize") .. bar .. getCommand("vertical resize"), { desc = "Window focus" })

-- Stay in indent mode
map(visualMode, "<", "<gv", { desc = "Indent left in visual mode" })
map(visualMode, ">", ">gv", { desc = "Indent right in visual mode" })

-- spell
map(normalMode, leader .. "Ss", getCommand("set spell"), { desc = "Set spell" })
map(normalMode, leader .. "Sns", getCommand("set nospell"), { desc = "Set no spell" })

-- buffers
map(normalMode, "<Tab>", getCommand("bnext"), { desc = "Next buffer" })
map(normalMode, "<S-Tab>", getCommand("bprevious"), { desc = "Previous buffer" })
map(normalMode, leader .. "x", getCommand("confirm bdelete"), { desc = "Close buffer" })

-- explorer
map(normalMode, getCtrlCommand("n"), ":Explore" .. enter, { desc = "Open Explorer" })

-- terminal
map(normalMode, getAltCommand("h"), getCommand("Horterminal"), { desc = "Open horizontal terminal" })
map(normalMode, getAltCommand("v"), getCommand("Vertterminal"), { desc = "Open vertical terminal" })
map({ normalMode, terminalMode }, getAltCommand("t"), getCommand("Floatterminal"), { desc = "Open floating terminal" })
map(normalMode, leader .. "lg", getCommand("LazyGit"), { desc = "LazyGit" })

-- global lsp mappings
map(normalMode, leader .. "ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })
map(normalMode, leader .. "dc", vim.diagnostic.open_float, { desc = "LSP diagnostic under cursor" })

-- cheatsheet
map(normalMode, leader .. "cs", getCommand("Cheatsheet"), { desc = "Open cheatsheet" })
map(normalMode, leader .. "vcs", getCommand("VimCheatsheet"), { desc = "Open Vim cheatsheet" })

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
