-- ~/.config/nvim/lua/plugins/ui.lua

-- Mod gruvbox for lualine
local lualine_gruvbox = {
  normal = {
    a = { fg = "#fbf1c7", bg = "#282828" },
    b = { fg = "#fbf1c7", bg = "#282828" },
    c = { fg = "#fbf1c7", bg = "#282828" },
  },
  insert  = { a = { fg = "#fbf1c7", bg = "#282828" } },
  visual  = { a = { fg = "#fbf1c7", bg = "#282828" } },
  replace = { a = { fg = "#fbf1c7", bg = "#282828" } },
  command = { a = { fg = "#fbf1c7", bg = "#282828" } },
  inactive = {
    a = { fg = "#a89984", bg = "#282828" },
    b = { fg = "#a89984", bg = "#282828" },
    c = { fg = "#a89984", bg = "#282828" },
  },
}

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
          theme = gruvbox,
          section_separators = "",
          component_separators = "|",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {
            "diagnostics",
            "filetype",
            "progress",
          },
          lualine_y = { "location" },
          lualine_z = {
            {
              function() return os.date("%H:%M") end,
            },
          },
        },
      })
    end,
  },

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- nvim-colorizer
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*" }, -- all filetypes
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        mode = "background",
      },
    },
  },
}

