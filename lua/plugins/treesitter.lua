-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c", "cpp", "bash", "python", "lua", "vim", "vimdoc", "query", "html", "xml", "markdown",
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = function(lang, bufnr)
            local ok = pcall(vim.treesitter.get_parser, bufnr, lang)
            if not ok then return true end
            local query_ok = pcall(vim.treesitter.query.get, lang, "highlights")
            return not query_ok
          end,
        },
        indent = { enable = true },
      })
    end,
  },
}
