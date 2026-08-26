return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      git = {
        ignore = false,
      },
      hijack_cursor = true,
      renderer = {
        group_empty = true,
        highlight_git = "name",
        indent_markers = { enable = true },
      },
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
      },
      view = {
        preserve_window_proportions = true,
        width = 34,
      },
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer: toggle" },
      { "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "Explorer: reveal current file" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      local themes = require("telescope.themes")

      telescope.setup({
        defaults = {
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
          layout_strategy = "horizontal",
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
          prompt_prefix = "  ",
          selection_caret = "> ",
          sorting_strategy = "ascending",
        },
        pickers = {
          buffers = themes.get_dropdown({
            previewer = false,
            sort_mru = true,
          }),
          find_files = {
            hidden = true,
          },
        },
      })

      pcall(telescope.load_extension, "fzf")
    end,
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Find text in project",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Find open buffers",
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Find recent files",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Find help",
      },
      {
        "<leader>fs",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "Find symbols in file",
      },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find(
            require("telescope.themes").get_dropdown({ previewer = false })
          )
        end,
        desc = "Find text in current file",
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        always_show_bufferline = true,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local marker = level:match("error") and "E" or "W"
          return string.format(" %s:%d", marker, count)
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "Files",
            text_align = "left",
            separator = true,
          },
        },
        separator_style = "thin",
        show_close_icon = false,
      },
    },
    keys = {
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>bd", "<cmd>bdelete<cr>", desc = "Close current buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin current buffer" },
    },
  },
}
