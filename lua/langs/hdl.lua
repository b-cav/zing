-- ~/.config/nvim/lua/langs/vhdl.lua

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "vhdl", "verilog", "systemverilog" },
  callback = function()
    local opt = vim.opt_local

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Easy-align — multi-column alignment for signal/port declarations
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- VHDL/SV code often has 3-4 logical columns per line
    -- Want one keystroke to align all of: name, colon, type, and trailing comment.

    -- Align on the FIRST colon (name : type boundary)
    vim.keymap.set("v", "<leader>a:", "<Plug>(EasyAlign)*:", { buffer = true, desc = "Align on colon" })

    -- Align on trailing -- comments
    vim.keymap.set("v", "<leader>ac", "<Plug>(EasyAlign)*--", { buffer = true, desc = "Align on -- comments" })

    -- Align on := (signal assignment)
    vim.keymap.set("v", "<leader>a=", "<Plug>(EasyAlign)*:=", { buffer = true, desc = "Align on :=" })

    -- Normal mode variants — align the current paragraph without manual visual select
    vim.keymap.set("n", "<leader>a:", "vip<Plug>(EasyAlign)*:", { buffer = true, desc = "Align paragraph on colon" })
    vim.keymap.set("n", "<leader>ac", "vip<Plug>(EasyAlign)*--", { buffer = true, desc = "Align paragraph on -- comments" })
    vim.keymap.set("n", "<leader>a=", "vip<Plug>(EasyAlign)*:=", { buffer = true, desc = "Align paragraph on :=" })
  end,
})
