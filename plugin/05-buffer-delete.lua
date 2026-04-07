local keymap = require("config.keymap")
vim.pack.add({ "https://github.com/ojroques/nvim-bufdel" })

keymap.map(keymap.normalMode, keymap.leader .. "x", keymap.getCommand("BufDel"), { desc = "Close buffer" })
keymap.map(keymap.normalMode, keymap.leader .. "X", keymap.getCommand("BufDelOthers"), { desc = "Close other buffers"})
