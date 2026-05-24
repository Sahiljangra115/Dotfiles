return {
  -- Keep LazyVim default colorscheme/syntax highlighting,
  -- only apply glass-like UI tweaks.

  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      opts.defaults = opts.defaults or {}
      opts.defaults.winblend = 12
      opts.defaults.layout_strategy = opts.defaults.layout_strategy or "horizontal"
      opts.defaults.layout_config = vim.tbl_deep_extend("force", opts.defaults.layout_config or {}, {
        prompt_position = "top",
      })
      opts.defaults.sorting_strategy = opts.defaults.sorting_strategy or "ascending"
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = function(_, opts)
      opts.window = opts.window or {}
      opts.window.popup_border_style = "rounded"
    end,
  },

  {
    "folke/noice.nvim",
    optional = true,
    opts = function(_, opts)
      opts.presets = opts.presets or {}
      opts.presets.lsp_doc_border = true
    end,
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.win = opts.win or {}
      opts.win.border = "rounded"
      opts.win.wo = vim.tbl_deep_extend("force", opts.win.wo or {}, { winblend = 12 })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.globalstatus = true

      -- cleaner glass-like statusline
      local transparent = { bg = "none" }
      local inactive = { fg = "#8087a2", bg = "none" }
      opts.options.theme = {
        normal = {
          a = transparent,
          b = transparent,
          c = transparent,
        },
        insert = {
          a = transparent,
          b = transparent,
          c = transparent,
        },
        visual = {
          a = transparent,
          b = transparent,
          c = transparent,
        },
        replace = {
          a = transparent,
          b = transparent,
          c = transparent,
        },
        command = {
          a = transparent,
          b = transparent,
          c = transparent,
        },
        inactive = {
          a = inactive,
          b = inactive,
          c = inactive,
        },
      }
    end,
  },

  {
    "folke/lazydev.nvim",
    enabled = false,
  },
}
