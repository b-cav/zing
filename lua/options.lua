-- ~/.config/nvim/lua/options.lua

local opt = vim.opt

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Leader
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Clipboard
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
if vim.fn.executable("xclip") == 1 then
  vim.g.clipboard = {
    name = "xclip",
    copy = {
      ["+"] = "xclip -selection clipboard",
      ["*"] = "xclip -selection primary",
    },
    paste = {
      ["+"] = "xclip -selection clipboard -o",
      ["*"] = "xclip -selection primary -o",
    },
    cache_enabled = true,
  }
  opt.clipboard = "unnamedplus" -- Sync to external clipboard
else
  -- Don't try to sync w/o xclip
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Files & backups
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local backup_dir = vim.fn.expand("~/.local/share/nvim/backup")
local undo_dir   = vim.fn.expand("~/.local/share/nvim/undo")

if vim.fn.isdirectory(backup_dir) == 0 then vim.fn.mkdir(backup_dir, "p") end
if vim.fn.isdirectory(undo_dir)   == 0 then vim.fn.mkdir(undo_dir,   "p") end

opt.backup      = true
opt.writebackup = true
opt.backupdir   = backup_dir .. "//"
opt.undofile    = true
opt.undodir     = undo_dir   .. "//"
opt.swapfile    = false

-- Create timestamped backups upon modification
local backup_group = vim.api.nvim_create_augroup("Backup", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group    = backup_group,
  desc     = "Timestamped backups when buffer is modified",
  pattern  = "*",
  callback = function()
    if vim.bo.modified then
      opt.backup    = true
      opt.backupext = "-" .. vim.fn.strftime("%Y%m%d%H%M") .. "~"
    else
      opt.backup = false
    end
  end,
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Indentation
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
opt.tabstop = 4           -- Visual width
opt.shiftwidth = 4        -- Actual shift
opt.softtabstop = 4       -- Width in insert mode
opt.expandtab = true      -- Use spaces
opt.smartindent = true
opt.breakindent = true    -- Wrapped lines inherit indent

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Search
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
opt.ignorecase = true     -- Case-insensitive by default
opt.smartcase = true      -- Case-sensitive if you type a capital
opt.hlsearch = true
opt.incsearch = true

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Appearance
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = true
opt.scrolloff = 8         -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8
opt.termguicolors = true
opt.showmode = false
opt.list = true
opt.listchars = {
  tab = "⇥ ",
  trail = "·",
  nbsp = "␣",
  extends = "…",
  precedes = "…",
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Splits
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
opt.splitright = true     -- :vsp opens right
opt.splitbelow = true     -- :sp opens below

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Completion
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
opt.completeopt = { "menuone", "noselect" }
opt.pumheight = 10        -- Max items in popup

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Misc
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
opt.mouse = "a"
opt.updatetime = 250
opt.timeoutlen = 300
opt.isfname:append("@-@") -- Treat @ as part of filenames
opt.cmdheight = 1

