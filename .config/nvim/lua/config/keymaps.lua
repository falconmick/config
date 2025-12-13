-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- move arguments to single line
vim.keymap.set("n", "J", "mzJ`z")

-- navigate around with centering

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- allows pasting over selected without loosing what we had yanked
vim.keymap.set("x", "<leader>p", [["_dP]])

-- delete without adding to register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- source file
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-- Smart "step over" in insert mode:
-- If the next character is the same as `char`, move right instead of inserting.
local function smart_step(char)
  return function()
    local col = vim.fn.col(".") -- 1-based cursor column
    local line = vim.fn.getline(".") -- current line text

    -- If cursor is on the character and it's the same as `char`, step over it
    if col <= #line and line:sub(col, col) == char then
      return "<Right>"
    end

    -- Otherwise insert the character as usual
    return char
  end
end

-- Helper to create insert-mode mappings
local function imap_smart(lhs, char)
  vim.keymap.set("i", lhs, smart_step(char), { expr = true, noremap = true, silent = true })
end

-- Quotes
imap_smart('"', '"')
imap_smart("'", "'")
imap_smart("`", "`")

-- Common closers / terminators
imap_smart(";", ";")
imap_smart(")", ")")
imap_smart("]", "]")

local ts_nav = require("config.ts_nav")

-- Go up to parent node, recording history
vim.keymap.set("n", "<leader>k", ts_nav.goto_parent_with_history, { desc = "TS: Go to parent (with history)" })

-- Go back down to where you came from
vim.keymap.set("n", "<leader>j", ts_nav.goto_prev_from_history, { desc = "TS: Go back down (pop history)" })
