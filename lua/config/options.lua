-- left colum settings
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 25
vim.opt.sidescrolloff = 10

-- tab spacing/behavior
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.breakindent = true

-- general
vim.opt.clipboard = "unnamedplus"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 1000
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.updatetime = 300
vim.opt.writebackup = false
vim.opt.cursorline = true
vim.opt.virtualedit = "block"
vim.opt.inccommand = "split"
vim.opt.winborder = "rounded"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.shortmess:append("c")
vim.g.have_nerd_font = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- spelling
vim.opt.spelllang = "en,pt_br"

-- shell
vim.opt.shellcmdflag = "-c"
vim.opt.shellslash = true
vim.opt.shellquote = '"'
