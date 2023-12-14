local os = require('os')

local cmd = vim.cmd
local opt = vim.opt

-- general stuff
opt.wildmenu = true
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = "utf-8"
opt.showcmd  = true
opt.hlsearch = true
opt.incsearch = true
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.number = true
opt.scrolloff = 10 
opt.colorcolumn = '120'
opt.wrap = false
opt.showmode = false
opt.swapfile = false
opt.scl = 'number' -- merge signocolumn with number
opt.clipboard = 'unnamed'
opt.hidden = true
opt.termguicolors = true
opt.cursorline = true
opt.syntax = 'enable'
opt.filetype = 'on'
opt.mouse = ''

-- spellcheck configuration
opt.spelllang = 'en'
opt.spellsuggest = 'best,9'

-- disable python provider support to speed-up start time
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

-- disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- those should be defined before call to 'colorscheme gruvbox'
vim.g.gruvbox_contrast_light = 'hard'
vim.g.gruvbox_contrast_dark = 'hard'

-- hide status line
vim.o.showmode = false
vim.o.ruler = false
vim.o.showcmd = false
vim.o.laststatus = 0

cmd [[
    colorscheme vscode
    " highlight trailing spaces
    set list
    set listchars=trail:·
]]

