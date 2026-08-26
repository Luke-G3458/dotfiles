vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.hidden = true
vim.opt.mouse = "a"
vim.opt.signcolumn = "yes"
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.winborder = "rounded"

require("config.lazy")
