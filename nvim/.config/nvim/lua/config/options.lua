-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Slightly translucent popup menus/floats to match the Ghostty glass look
vim.opt.winblend = 12
vim.opt.pumblend = 12
vim.opt.termguicolors = true

-- cleaner glass-like canvas
vim.opt.fillchars:append({ eob = " " })

-- Keep LazyVim's default syntax colors, but make editor surfaces transparent
-- so Ghostty background image/glass effect can show through.
require("config.toggles").setup()

-- Markdown/text readability polish
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 0
  end,
})

vim.g.ai_cmp = true
