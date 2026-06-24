-- ~/.config/nvim/lua/plugins/whichkey.lua

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      spec = {
        { "<leader>f", group = "Find / Telescope" },
        { "<leader>l", group = "LSP" },
        { "<leader>a", group = "Align" },
        { "<leader>e", desc = "File explorer (oil)" },
        { "<leader>w", group = "Window / Save" },
        { "<leader>t", group = "Toggle" },
      },
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer local keymaps",
      },
    },
  },
}
