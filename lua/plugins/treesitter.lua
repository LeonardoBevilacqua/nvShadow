return {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { 
                "c", 
                "vim",
                "lua",
                "vimdoc",
                "query",
                "html",
                "css",
                "java",
                "markdown",
                "markdown_inline",
                "json",
                "angular",
                "scss",
                "javascript",
                "typescript",
                "tsx"
            },
            auto_install = true,
            highlight = {
                enable = true,
            },
            incremental_selection = { 
                enable = true,
                keymaps = { 
                    -- TODO: Document keys
                    init_selection = "<Leader>ss",
                    node_incremental = "<Leader>si", 
                    scope_incremental = "<Leader>sc", 
                    node_decremental = "<Leader>sd", 
                }, 
            }, 
        })
    end,
}
