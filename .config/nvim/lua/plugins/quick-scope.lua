return {
  "unblevable/quick-scope",
  event = { "BufReadPost", "BufNewFile" }, -- load lazily on buffer open
  config = function()
    -- enable quick-scope
    -- vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }

    -- optional: customize highlight groups
    -- vim.cmd [[
    --   highlight QuickScopePrimary   ctermfg=14 guifg=#89B4FA gui=underline
    --   highlight QuickScopeSecondary ctermfg=13 guifg=#F38BA8
    -- ]]
  end,
}
