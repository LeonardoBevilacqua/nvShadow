vim.pack.add({
    "https://github.com/echasnovski/mini.icons",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/refractalize/oil-git-status.nvim",
})

require("oil").setup({
    win_options = {
        signcolumn = "yes:2",
    },
    view_options = {
        show_hidden = true,
    },
})
local keymap = require("config.keymap")
keymap.map(
    keymap.normalMode,
    keymap.getCtrlCommand("n"),
    ":Oil" .. keymap.enter,
    { desc = "Open Explorer" }
)
