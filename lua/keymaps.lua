-- ~/.config/nvim/lua/keymaps.lua

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Core REMAPS
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
vim.keymap.set("n", ";", ":", { noremap = true })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Window navigation
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
map("n", "<C-h>", "<C-w>h", "Move to left split")
map("n", "<C-l>", "<C-w>l", "Move to right split")
map("n", "<C-j>", "<C-w>j", "Move to split below")
map("n", "<C-k>", "<C-w>k", "Move to split above")

-- Resize splits
map("n", "<C-Left>",  "<C-w><", "Shrink split left")
map("n", "<C-Right>", "<C-w>>", "Grow split right")
map("n", "<C-Up>",    "<C-w>+", "Grow split up")
map("n", "<C-Down>",  "<C-w>-", "Shrink split down")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Editing utilities
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Strip trailing whitespace
map("n", "<leader>ws", "<cmd>%s/\\s\\+$//e<CR>", "Strip trailing whitespace")

-- Keep cursor centered when jumping
map("n", "<C-d>", "<C-d>zz", "Scroll down and center")
map("n", "<C-u>", "<C-u>zz", "Scroll up and center")
map("n", "n",     "nzzzv",   "Next match centered")
map("n", "N",     "Nzzzv",   "Prev match centered")

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Leader — oil.nvim
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
map("n", "<leader>e",  "<cmd>Oil<CR>", "Open oil.nvim")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Leader — telescope.nvim
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local function builtin()
  return require("telescope.builtin")
end

-- Open telescope in normal mode for h/j/k/l nav
local function telescope_normal(fn)
  return function()
    fn()
    vim.schedule(function()
      vim.cmd("stopinsert")
    end)
  end
end

map("n", "<leader>ff", telescope_normal(function() builtin().find_files() end), "Find files")
map("n", "<leader>fg", telescope_normal(function() builtin().live_grep() end),  "Live grep")
map("n", "<leader>fb", telescope_normal(function() builtin().buffers() end),    "Find open buffers")
map("n", "<leader>fr", telescope_normal(function() builtin().oldfiles() end),   "Recent files")
map("n", "<leader>fh", telescope_normal(function() builtin().help_tags() end),  "Help tags")

map("n", "<leader>bb", telescope_normal(function()
  builtin().find_files({ cwd = vim.fn.expand("~/.local/share/nvim/backup") })
end), "Browse backup dir")

map("n", "<leader>bc", telescope_normal(function()
  builtin().find_files({ cwd = vim.fn.expand("~/.config/nvim") })
end), "Browse config dir")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Leader — LSP
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
map("n", "<leader>lr", "<cmd>LspRestart<CR>",  "LSP: restart")
map("n", "<leader>li", "<cmd>LspInfo<CR>",     "LSP: info")

-- Toggle LSP underlines
map("n", "<leader>tu", function()
  local current = vim.diagnostic.config().underline
  vim.diagnostic.config({ underline = not current })
end, "Toggle diagnostic underline")

-- Toggle inline virtual text
map("n", "<leader>te", function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
end, "Toggle LSP error comments (virtual text)")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Leader — misc
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
map("n", "<leader>w",  "<cmd>w<CR>",           "Save")
map("n", "<leader>q",  "<cmd>q<CR>",           "Quit")
map("n", "<leader>wq", "<cmd>wq<CR>",          "Save and quit")
map("n", "<leader>/",  "gcc",                  "Toggle comment (line)")
map("v", "<leader>/",  "gc",                   "Toggle comment (selection)")


map("n", "<leader>tw", function()
  vim.opt_local.wrap = not vim.opt_local.wrap:get()
end, "Toggle line wrap")
map("n", "<leader>s", "ggVG", "Select all")

map("n", "<leader>tl", function()
  vim.opt_local.relativenumber = not vim.opt_local.relativenumber:get()
end, "Toggle relative/absolute line numbers")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- C/C++ headers
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Open the matching .h for a .c or vice versa in a vertical split
map("n", "<leader>gh", function()
  local file = vim.fn.expand("%:t:r")
  local ext  = vim.fn.expand("%:e")
  local companion = ext == "c" and (file .. ".h")
                 or ext == "h" and (file .. ".c")
                 or nil
  if companion then
    vim.cmd("vsp " .. companion)
  else
    vim.notify("No companion file for ." .. ext, vim.log.levels.WARN)
  end
end, "Open companion .h / .c in vsp")
