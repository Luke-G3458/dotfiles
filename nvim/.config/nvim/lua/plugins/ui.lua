return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          background_colour = "#272e33",
          render = "compact",
          stages = "fade",
          timeout = 3000,
        },
      },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)

      vim.keymap.set({ "n", "i", "s" }, "<C-f>", function()
        if not require("noice.lsp").scroll(4) then
          return "<C-f>"
        end
      end, { silent = true, expr = true, desc = "Scroll LSP documentation down" })

      vim.keymap.set({ "n", "i", "s" }, "<C-b>", function()
        if not require("noice.lsp").scroll(-4) then
          return "<C-b>"
        end
      end, { silent = true, expr = true, desc = "Scroll LSP documentation up" })

      vim.keymap.set("n", "<leader>nh", "<cmd>Noice history<cr>", { desc = "Noice: message history" })
      vim.keymap.set("n", "<leader>nl", "<cmd>Noice last<cr>", { desc = "Noice: last message" })
      vim.keymap.set("n", "<leader>nd", "<cmd>Noice dismiss<cr>", { desc = "Noice: dismiss messages" })
    end,
  },
}
