local M = {}

M.state = {
  glass = true,
  focus = false,
}

local function apply_transparent_group(group)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok then
    hl.bg = "none"
    vim.api.nvim_set_hl(0, group, hl)
  else
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

function M.apply_glass_highlights()
  if not M.state.glass then
    return
  end

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
    apply_transparent_group(group)
  end

  local ok_comment, comment = pcall(vim.api.nvim_get_hl, 0, { name = "Comment", link = false })
  if ok_comment and comment.fg then
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = comment.fg, bg = "none" })
  else
    vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })
  end
end

function M.set_glass(enabled)
  M.state.glass = enabled
  vim.opt.winblend = enabled and 12 or 0
  vim.opt.pumblend = enabled and 12 or 0

  if enabled then
    M.apply_glass_highlights()
    return
  end

  if vim.g.colors_name and #vim.g.colors_name > 0 then
    pcall(vim.cmd.colorscheme, vim.g.colors_name)
  end
end

local function set_focus_window_opts(enabled)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) then
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative == "" then
        vim.api.nvim_set_option_value("number", not enabled, { win = win })
        vim.api.nvim_set_option_value("relativenumber", false, { win = win })
        vim.api.nvim_set_option_value("cursorline", not enabled, { win = win })
        vim.api.nvim_set_option_value("signcolumn", enabled and "no" or "yes", { win = win })
      end
    end
  end
end

function M.set_focus(enabled)
  M.state.focus = enabled
  vim.opt.laststatus = enabled and 0 or 3
  vim.opt.showtabline = enabled and 0 or 2
  vim.opt.wrap = enabled
  vim.opt.linebreak = enabled
  set_focus_window_opts(enabled)
end

function M.toggle_glass()
  M.set_glass(not M.state.glass)
  vim.notify("Glass mode: " .. (M.state.glass and "ON" or "OFF"), vim.log.levels.INFO, { title = "UI" })
end

function M.toggle_focus()
  M.set_focus(not M.state.focus)
  vim.notify("Focus mode: " .. (M.state.focus and "ON" or "OFF"), vim.log.levels.INFO, { title = "UI" })
end

function M.toggle_cycle()
  local mode
  if M.state.glass and not M.state.focus then
    M.set_focus(true)
    mode = "Focus + Glass"
  elseif M.state.glass and M.state.focus then
    M.set_focus(false)
    M.set_glass(false)
    mode = "Solid"
  else
    M.set_glass(true)
    M.set_focus(false)
    mode = "Glass"
  end

  vim.notify("UI mode: " .. mode, vim.log.levels.INFO, { title = "UI" })
end

function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = M.apply_glass_highlights,
  })

  vim.api.nvim_create_autocmd("WinNew", {
    callback = function()
      if M.state.focus then
        set_focus_window_opts(true)
      end
    end,
  })

  vim.api.nvim_create_user_command("ToggleGlass", function()
    M.toggle_glass()
  end, {})

  vim.api.nvim_create_user_command("ToggleFocus", function()
    M.toggle_focus()
  end, {})

  vim.api.nvim_create_user_command("ToggleUIMode", function()
    M.toggle_cycle()
  end, {})

  vim.schedule(M.apply_glass_highlights)
end

return M
