-- ~/.config/nvim/lua/plugins/lsp.lua

return {
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- mason.nvim (LSP manager)
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- mason-lspconfig.nvim
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "bashls",
          "pyright",
          "verible",
        },
      })
    end,
  },

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- nvim-lspconfig — actual server configuration + keymaps on attach
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local lspconfig = require("lspconfig")

      -- blink.cmp provides enhanced completion capabilities to send to servers
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
        callback = function(event)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition,      "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration,     "Go to declaration")
          map("n", "gr", vim.lsp.buf.references,      "Go to references")
          map("n", "gI", vim.lsp.buf.implementation,  "Go to implementation")
          map("n", "K",  vim.lsp.buf.hover,            "Hover docs")
          map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
          map("n", "<leader>lc", vim.lsp.buf.code_action,            "Code action")
          map("n", "<leader>ln", vim.lsp.buf.rename,                 "Rename symbol")
          map("n", "<leader>le", vim.diagnostic.open_float,          "Show diagnostic")
          map("n", "[d", vim.diagnostic.goto_prev,                   "Prev diagnostic")
          map("n", "]d", vim.diagnostic.goto_next,                   "Next diagnostic")
        end,
      })

      -- Setup servers
      lspconfig.clangd.setup({ capabilities = capabilities })
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.verible.setup({ capabilities = capabilities })
    end,
  },
}
