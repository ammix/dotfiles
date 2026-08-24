-- General
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.o.shell = "fish"
vim.o.undofile = true
vim.o.swapfile = false
vim.o.confirm = true
vim.o.makeprg = "just"

-- Editing
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.breakindent = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.infercase = true

vim.o.formatexpr = require("conform").formatexpr

-- Interface
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.showmode = false
vim.o.scrolloff = 10
vim.o.scrolloffpad = 1
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.list = true
vim.o.listchars = {
  tab = "> ",
  trail = "-",
  extends = ">",
  precedes = "<",
  nbsp = "+",
}
vim.o.pumblend = 10
vim.o.pumheight = 10
vim.o.showcmdloc = "statusline"
vim.o.background = "dark"

vim.o.splitbelow = true
vim.o.splitright = true
