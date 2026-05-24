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
local function apply_glass_highlights()
  local groups = {
    "Normal",
    "NormalNC",
    "SignColumn",
    "EndOfBuffer",
    "NormalFloat",
    "FloatBorder",
    "StatusLine",
    "StatusLineNC",
    "TabLineFill",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
  }

  for _, group in ipairs(groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok then
      hl.bg = "none"
      vim.api.nvim_set_hl(0, group, hl)
    else
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
  end

  -- Softer inactive split contrast (theme-aware: use Comment fg)
  local ok_comment, comment = pcall(vim.api.nvim_get_hl, 0, { name = "Comment", link = false })
  if ok_comment and comment.fg then
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = comment.fg, bg = "none" })
  else
    vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_glass_highlights,
})

-- Apply once on startup too
vim.schedule(apply_glass_highlights)

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
