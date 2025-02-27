return {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    init = function() 
        vim.o.foldcolumn = "1" -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        local keymap = require("config.keymap")

        keymap.map(keymap.normalMode, "zR", require("ufo").openAllFolds, { desc = "UFO Open All folds" })
        keymap.map(keymap.normalMode, "zM", require("ufo").closeAllFolds, { desc = "UFO Close All folds" })
        keymap.map(keymap.normalMode, "zK", function() 
            local winid = require("ufo").peekFoldedLinesUnderCursor() 
            if not winid then 
                vim.lsp.buf.hover() 
            end 
        end, 
        { desc = "UFO Peek fold" })

        require("ufo").setup {
        provider_selector = function(bufnr, filetype, buftype) 
            return { "lsp", "indent" }
        end, 
    }
    end, 
}
