vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim",
})

require("lualine").setup({
    options = {
        theme = "onedark",
        section_separators = "",
        component_separators = "",
        globalstatus = true,
    },
    sections = {
        lualine_x = { "filetype" },
        lualine_y = { "progress", "searchcount" },
        lualine_z = { "location", "selectioncount" },
    },
    tabline = {
        lualine_a = {
            {
                "buffers",
                filetype_names = { oil = "Explore" },
                max_length = function()
                    return (vim.o.columns * 10) / 12
                end,
            },
        },
        lualine_z = {
            {
                "tabs",
                max_length = function()
                    return (vim.o.columns * 2) / 12
                end,
            },
        },
    },
})
