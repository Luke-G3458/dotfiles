return {
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"

      require("everforest").setup({
        background = "hard",
        float_style = "dim",
        inlay_hints_background = "dimmed",
        transparent_background_level = 0,
        ui_contrast = "high",
      })

      vim.cmd.colorscheme("everforest")
    end,
  },
}
