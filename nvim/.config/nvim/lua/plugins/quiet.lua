return {
  -- only show ERROR-severity diagnostics; hide warnings/info/hints
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = { severity = vim.diagnostic.severity.ERROR },
        signs = { severity = vim.diagnostic.severity.ERROR },
        underline = { severity = vim.diagnostic.severity.ERROR },
      },
    },
  },

  -- kill "✔pyright" LSP progress popups
  {
    "folke/noice.nvim",
    opts = {
      lsp = { progress = { enabled = false } },
    },
  },

  -- kill markdownlint noise (MD013, MD033, ...) from the markdown extra
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = nil
    end,
  },
}
