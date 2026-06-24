-- ~/.config/nvim/lua/langs/web.lua

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 2-space indent languages
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "html", "xml", "xsd" },
  callback = function()
    local opt = vim.opt_local

    opt.tabstop = 2
    opt.shiftwidth = 2
    opt.softtabstop = 2
    opt.expandtab = true
  end,
})
