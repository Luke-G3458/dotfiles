local parsers = {
  "bash",
  "javascript",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "regex",
  "rust",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup()

      local function install_parsers()
        if vim.fn.executable("tree-sitter") == 1 then
          treesitter.install(parsers)
        end
      end

      -- Mason adds tree-sitter-cli to PATH during startup. Also retry after
      -- Mason installs it for the first time.
      vim.schedule(install_parsers)
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = install_parsers,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        pattern = {
          "javascript",
          "javascriptreact",
          "python",
          "rust",
          "typescript",
          "typescriptreact",
        },
        callback = function(event)
          pcall(vim.treesitter.start, event.buf)
        end,
      })
    end,
  },
}
