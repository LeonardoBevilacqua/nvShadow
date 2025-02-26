-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Hightlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
