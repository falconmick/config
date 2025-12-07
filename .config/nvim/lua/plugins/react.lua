return {
  -- LSP tweaks & Emmet
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {},
        html = {},
        cssls = {},
        tailwindcss = {},
        emmet_language_server = {
          filetypes = { "html", "css", "javascriptreact", "typescriptreact" },
        },
      },
    },
  },

  -- TS error explanations
  {
    "dmmulroy/ts-error-translator.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- Emmet helpers
  {
    "olrtg/nvim-emmet",
    ft = { "html", "css", "javascriptreact", "typescriptreact" },
  },
}
