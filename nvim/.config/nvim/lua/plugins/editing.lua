return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      local cond = require("nvim-autopairs.conds")
      local Rule = require("nvim-autopairs.rule")

      autopairs.setup(opts)
      autopairs.add_rule(
        Rule("<", ">", "rust"):with_pair(cond.before_regex("[%w_:]$", 1))
      )
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "x" },
        desc = "Code: format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
      format_on_save = function(buffer)
        if vim.bo[buffer].filetype == "rust" then
          return { timeout_ms = 1000 }
        end
      end,
    },
  },
}
