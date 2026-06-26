-- ~/.config/nvim/lua/autocmds.lua

local augroup = vim.api.nvim_create_augroup("Autocmds", { clear = true })

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- File headers — dispatch table keyed by filetype/extension
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function build_header(comment_style)
  local date = os.date("%m-%d-%Y")
  local filename = vim.fn.expand("%:t")
  -- local user = vim.fn.getenv("USER")
  -- if user == vim.NIL or user == "" then
  --   user = "Ben Cavanagh"
  -- end
  local user = "Ben Cavanagh"

  if comment_style == "c" then
    return {
      "/*",
      " * " .. filename .. " - ",
      " *",
      " * " .. user,
      " * " .. date,
      " * Description: ",
      " *",
      " */",
      "",
    }
  elseif comment_style == "xml" then
    return {
      '<?xml version="1.0" encoding="UTF-8"?>',
      "<!--",
      "  " .. filename .. " - ",
      "",
      "  " .. user,
      "  " .. date,
      "  Description: ",
      "",
      "-->",
      "",
    }
  elseif comment_style == "py" then
    return {
      "#",
      "# " .. filename .. " - ",
      "#",
      "# " .. user,
      "# " .. date,
      "# Description: ",
      "#",
      "",
      "def main() :",
      "",
      "if __name__ == \"__main__\" :",
      "    main()",
      "",
    }
  elseif comment_style == "jl" then
    return {
      "#=",
      " " .. filename .. " - ",
      "",
      " " .. user,
      " " .. date,
      " Description: ",
      "=#",
      "",
    }
  end
end

-- Lookup header commment based on extension
local header_styles = {
  c = "c", cpp = "c", h = "c", hpp = "c",
  html = "xml", xml = "xml", xsd = "xml", tdml = "xml",
  py = "py",
  jl = "jl",
}

vim.api.nvim_create_autocmd("BufNewFile", {
  group = augroup,
  pattern = "*",
  desc = "Insert file header based on extension",
  callback = function()
    local ext = vim.fn.expand("%:e")
    local style = header_styles[ext]
    if not style then return end

    local header = build_header(style)
    vim.api.nvim_buf_set_lines(0, 0, 0, false, header)
    vim.api.nvim_win_set_cursor(0, { #header + 1, 0 })
  end,
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Misc QoL
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Highlight yanked text",
  callback = function()
    if vim.highlight.hl_op then
      -- Version 0.13.0 and after
      vim.highlight.hl_op({ timeout = 200 })
    elseif vim.highlight.on_yank then
      -- Version 0.12.4 and before
      vim.highlight.on_yank({ timeout = 200 })
    end
  end,
})

-- Restore cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore cursor position on file reopen",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Oil on startup
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  desc = "Open oil directly as the startup buffer",
  callback = function()
    if vim.fn.argc() == 0 and vim.bo.filetype == "" then
      vim.cmd("enew | Oil")
    end
  end,
  nested = true,
})

-- Discard unsaved changes in oil
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(args)
    -- 1. Prevent E37 when switching files or typing :q
    vim.opt_local.buftype = "nofile"
    vim.opt_local.bufhidden = "hide"

    -- 2. Clean up when leaving so it doesn't clutter your buffer list
    vim.api.nvim_create_autocmd("BufLeave", {
      buffer = args.buf,
      callback = function()
        -- Mark as unmodified so Neovim lets go completely
        vim.bo[args.buf].modified = false
      end,
    })
  end,
})

