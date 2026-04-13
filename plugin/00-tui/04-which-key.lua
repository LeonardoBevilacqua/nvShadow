local keymap = require("config.keymap")
vim.pack.add({ "https://github.com/folke/which-key.nvim" })

require("which-key").setup({
	preset = "classic",
})
keymap.map(keymap.normalMode, keymap.leader .. "?", function()
	require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })
