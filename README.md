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

- [x] "stevearc/conform.nvim"
- [x] "neovim/nvim-lspconfig"
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
- [x] "kevinhwang91/nvim-ufo"
- Add missing plugins
