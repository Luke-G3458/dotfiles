local servers = { "basedpyright", "rust_analyzer", "ts_ls" }

local typescript_inlay_hints = {
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
}

return {
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
          ensure_installed = {
            "basedpyright",
            "rust-analyzer",
            "tree-sitter-cli",
            "typescript-language-server",
          },
          run_on_start = true,
        },
      },
    },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        virtual_lines = { current_line = true },
        virtual_text = {
          current_line = false,
          source = "if_many",
          spacing = 2,
        },
      })

      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
            },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
          },
        },
      })

      vim.lsp.config("ts_ls", {
        settings = {
          javascript = { inlayHints = typescript_inlay_hints },
          typescript = { inlayHints = typescript_inlay_hints },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = function(event)
          local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
          local buffer = event.buf
          local map = function(mode, lhs, rhs, description)
            vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = description })
          end

          map("n", "gd", vim.lsp.buf.definition, "LSP: go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "LSP: go to declaration")
          map("n", "gi", vim.lsp.buf.implementation, "LSP: go to implementation")
          map("n", "gr", vim.lsp.buf.references, "LSP: references")
          map("n", "K", function()
            vim.lsp.buf.hover({
              border = "rounded",
              max_height = 24,
              max_width = 80,
              title = " Documentation ",
              title_pos = "center",
            })
          end, "LSP: hover documentation")
          map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: rename symbol")
          map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: code action")
          map("n", "<leader>ld", vim.diagnostic.open_float, "LSP: line diagnostics")
          map("i", "<C-Space>", vim.lsp.completion.get, "LSP: complete")

          if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, buffer, { autotrigger = true })
          end

          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            map("n", "<leader>uh", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buffer })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = buffer })
            end, "LSP: toggle inlay hints")
          end
        end,
      })

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = servers,
      })
    end,
  },
}
