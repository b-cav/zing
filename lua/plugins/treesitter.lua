-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      install = {
        "c", "cpp", "bash", "python", "lua", "vim", "vimdoc",
        "query", "html", "xml", "markdown", "markdown_inline", "regex",
      },
    },
    config = function(_, opts)
      local treesitter = require("nvim-treesitter")
      treesitter.setup(opts)

      if vim.fn.executable("tree-sitter") ~= 1 then
        vim.notify("tree-sitter CLI not found, parsers cannot be installed", vim.log.levels.WARN)
        return
      end

      -- install any languages not already present
      local installed = treesitter.get_installed()
      local to_install = {}
      for _, lang in ipairs(opts.install) do
        if not vim.list_contains(installed, lang) then
          table.insert(to_install, lang)
        end
      end
      if #to_install > 0 then
        treesitter.install(to_install)
      end

      -- start highlighting + indent per-buffer, gracefully skipping broken queries
      local function start_highlight(bufnr, lang)
        if not vim.treesitter.language.add(lang) then
          return -- parser not available for this language, skip silently
        end
        local ok = pcall(vim.treesitter.start, bufnr, lang)
        if not ok then
          vim.notify(
            string.format("Treesitter highlight query failed for '%s', falling back to regex highlighting", lang),
            vim.log.levels.WARN
          )
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local bt = vim.bo[args.buf].buftype
          if bt ~= "" then return end -- skip special buffers (terminal, oil, telescope, etc)

          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then return end

          if vim.list_contains(treesitter.get_installed(), lang) then
            start_highlight(args.buf, lang)
          elseif vim.list_contains(treesitter.get_available(), lang) then
            treesitter.install(lang):await(function()
              start_highlight(args.buf, lang)
            end)
          end

          if not vim.tbl_contains({ "python", "html", "yaml", "markdown" }, ft) then
            vim.bo[args.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
          end
        end,
      })
    end,
  },
}
