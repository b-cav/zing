-- ~/.config/nvim/lua/langs/c.lua

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    local opt = vim.opt_local

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Easy-align for inline comments
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    vim.keymap.set("v", "<leader>ac", function()
      vim.cmd([[execute "normal! gaip//"]])
    end, { buffer = true, desc = "Align trailing // comments" })

    -- Normal mode: align the current paragraph's comments without visual-selecting first
    vim.keymap.set("n", "<leader>ac", function()
      vim.cmd([[execute "normal! Vipgaip//"]])
    end, { buffer = true, desc = "Align trailing // comments (paragraph)" })
  end,
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Companion file nav (.h <-> .c)
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.keymap.set("n", "<leader>gh", function()
      local file = vim.fn.expand("%:t:r")
      local ext = vim.fn.expand("%:e")
      local companion = (ext == "c" and file .. ".h")
        or (ext == "h" and file .. ".c")
        or (ext == "cpp" and file .. ".h")
        or (ext == "hpp" and file .. ".cpp")
        or nil
      if companion and vim.fn.filereadable(companion) == 1 then
        vim.cmd("vsp " .. companion)
      else
        vim.notify("No companion file found for ." .. ext, vim.log.levels.WARN)
      end
    end, { buffer = true, desc = "Open companion .h/.c in vsp" })
  end,
})
