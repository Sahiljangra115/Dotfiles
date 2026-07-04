-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local toggles = require("config.toggles")

-- Use Ctrl+g for UI mode cycle if nothing else already maps it.
if vim.fn.maparg("<C-g>", "n") == "" then
  vim.keymap.set("n", "<C-g>", toggles.toggle_cycle, { desc = "Toggle UI mode (glass/focus/solid)" })
end

vim.keymap.set("n", "<leader>ug", toggles.toggle_glass, { desc = "Toggle glass mode" })
vim.keymap.set("n", "<leader>uf", toggles.toggle_focus, { desc = "Toggle focus mode" })
