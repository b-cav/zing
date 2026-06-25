-- ~/.config/nvim/lua/plugins/ui.lua

return {
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- gruvbox.nvim color scheme
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "",
        palette_overrides = {
          -- dark0 = "#302f28",
        },
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")

      vim.api.nvim_set_hl(0, "ErrorMsg", { fg = "#fb4934", bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "Error",    { fg = "#fb4934", bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "WarningMsg", { fg = "#fabd2f", bg = "NONE" })
    end,
  },

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- lualine.nvim
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          section_separators = "",
          component_separators = "|",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "diagnostics", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
}
