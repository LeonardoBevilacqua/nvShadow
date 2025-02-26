# [WIP] NeoVim Configuration

This repository holds the Configuration code for my NeoVim configuration for Full stack web development.

## Checklist
- [ ] Add and document all plugins
- [ ] Configure plugins using the same standard.
- [ ] Document all key bindings.
- [ ] Add spell check `pt.utf-8.spl`.
    - In `options.lua`: `vim.opt.spelllang="en,pt_br"`
- [x] Add highlight when yank.
- [x] Add scrolloffset.
- [x] Add backspace with `<C-h>` in insert mode.
- [x] Add onedark theme.
## Plugins

- [ ] "stevearc/conform.nvim"
- [ ] "neovim/nvim-lspconfig"
- [x] "nvim-treesitter/nvim-treesitter"
- [ ] "iamcco/markdown-preview.nvim"
    ```lua
      {
        "iamcco/markdown-preview.nvim",
        cmd = { "markdownpreviewtoggle", "markdownpreview", "markdownpreviewstop" },
        build = "cd app && npm install",
        init = function()
          vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
      },
   ```
- [ ] "kevinhwang91/nvim-ufo"
    ```lua
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    init = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "UFO Open All folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "UFO Close All folds" })
      vim.keymap.set("n", "zK", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "UFO Peek fold" })

      require("ufo").setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { "lsp", "indent" }
        end,
      }
    end,
  },
    ```
