-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = { "*.js", "*.ts", "*.css", "*.tsx", "*.jsx" },
  nested = true,
  callback = function(args)
    local buf = args.buf

    -- Skip non-file buffers (help, terminals, prompts, etc.)
    if vim.bo[buf].buftype ~= "" then
      return
    end

    -- Skip Harpoon's UI buffer
    if vim.bo[buf].filetype == "harpoon" then
      return
    end

    -- Skip unmodifiable / readonly / unnamed buffers
    if not vim.bo[buf].modifiable or vim.bo[buf].readonly then
      return
    end
    if vim.api.nvim_buf_get_name(buf) == "" then
      return
    end

    -- All good: save
    vim.cmd("silent! write")
  end,
})


-- border highlights
local api = vim.api

-- Define highlight groups for active/inactive window borders
api.nvim_set_hl(0, "WinSeparatorInactive", { fg = "#313244" }) -- surface0

local function set_window_border(win)
  -- Set per-window winhighlight (new API, non-deprecated)
  vim.api.nvim_set_option_value("winhighlight", "WinSeparator:WinSeparatorInactive"
  , {
    scope = "local",
    win = win,
  })
end

local function update_all_window_borders()
  for _, win in ipairs(api.nvim_list_wins()) do
    -- Skip floating windows
    local cfg = api.nvim_win_get_config(win)
    if cfg.relative == "" then
      set_window_border(win)
    end
  end
end

-- Run when windows change / focus changes
api.nvim_create_autocmd(
  { "VimEnter", "WinEnter", "WinLeave", "BufWinEnter", "TabEnter", "TabNewEntered", "WinResized" },
  {
    callback = function()
      update_all_window_borders()
    end,
  }
)

-- Also run once at startup so the initial window is highlighted
update_all_window_borders()
