-- Set leader keybinding
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local normalMode = "n"
local visualMode = "v"
local terminalMode = "t"
local map = vim.keymap.set

-- Remove search highlights afete searching
map(normalMode, "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

-- Better window navigation
map(normalMode, "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map(normalMode, "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map(normalMode, "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map(normalMode, "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Easily split windows
map(normalMode, "<leader>wv", ":vsplit<cr>", { desc = "[W]indow Split [V]ertical" })
map(normalMode, "<leader>wh", ":split<cr>", { desc = "[W]indow Split [H]orizontal" })

-- Stay in indent mode
map(visualMode, "<", "<gv", { desc = "Indent left in visual mode" })
map(visualMode, ">", ">gv", { desc = "Indent right in visual mode" })

-- Exit terminal mode
map(terminalMode, "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Enter command mode
map("n", ";", ":", { desc = "CMD enter command mode" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "telescope find all files" }
)
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "telescope find diagnostics" })
map("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "telescope finder resume" })

-- comment
map("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)", { desc = "Comment Line" })
map("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment Selected" })
