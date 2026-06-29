-- ~/.config/nvim/lua/plugins/navigation.lua
return {
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- oil.nvim
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function(_, opts)
      local oil_module = require("oil")
      oil_module.setup({
        default_file_explorer = true,
        view_options = { show_hidden = true },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
        },
      })

      -- Auto-open oil on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        group = augroup,
        desc = "Open oil directly as the startup buffer",
        callback = function()
          if vim.fn.argc() == 0 and vim.bo.filetype == "" then
            vim.cmd("enew | oil")
          end
        end,
        nested = true,
      })

      -- Discard unsaved changes in oil automatically
      -- instead of prompting a write
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = function(args)
          -- Wipe out the buffer when switching away so it doesn't leak memory
          vim.opt_local.bufhidden = "wipe"

          -- When switching windows, forcefully discard oil changes
          -- right before the window loses focus
          vim.api.nvim_create_autocmd("WinLeave", {
            buffer = args.buf,
            callback = function()
              if vim.bo[args.buf].modified then
                require("oil").discard_all_changes()
                vim.bo[args.buf].modified = false
              end
            end,
          })

          -- Intercept quit commands inside oil
          vim.api.nvim_buf_create_user_command(args.buf, "Quit", function(ctx)
            require("oil").discard_all_changes()
            if ctx.bang then
              vim.cmd("q!")
            else
              vim.cmd("q")
            end
          end, { bang = true })

          -- Redirect standard quit commands
          vim.cmd([[cabbrev <buffer> q Quit]])
          vim.cmd([[cabbrev <buffer> q! Quit!]])

          -- Remap <CR> / Enter to also clean up when opening a file from oil
          vim.keymap.set("n", "<CR>", function()
            require("oil").select({ close = true })
          end, { buffer = args.buf, silent = true })

        end,
      })
    end,
  },

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- telescope.nvim
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    event = "VeryLazy",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
              ["<Esc>"] = actions.close,
            },
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
