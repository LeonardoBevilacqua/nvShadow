return { 
    "stevearc/conform.nvim",
    --event = 'BufWritePre', -- uncomment for format on save
    config = function() 
        require("conform").setup({ 
            formatters_by_ft = { 
                lua = { "stylua" }, 
                css = { "prettier" }, 
                html = { "prettier" }, 
            }, 
            format_on_save = { 
                -- These options will be passed to conform.format() 
                timeout_ms = 500, 
                lsp_fallback = true, 
            }, 
        }) 

        local keymap = require("config.keymap")
        print(keymap.leader)
        keymap.map(keymap.normalMode, keymap.leader .. "fm", function() 
            print('format')
            require("conform").format { lsp_fallback = true } 
        end, { desc = "general format file" })
    end 
}
