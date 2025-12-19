return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        hidden = true,
        ignored = true,
        sources = {
          files = {
            hidden = true,
            ignored = true,
            exclude = {
              "**/.DS_Store",
              "**/node_modules/**",
              "**/.next/**",
              "**/.meteor/**",
            },
          },
          grep = {
            hidden = true,
            ignored = true,
            exclude = {
              "**/.DS_Store",
              "**/node_modules/**",
              "**/.next/**",
              "**/package-lock.json",
              "**/.meteor/**",
            },
          },
        },
      },
      explorer = {
        hidden = true,
        ignored = true,
        sources = {
          files = {
            hidden = true,
            ignored = true,
            exclude = {
              "**/.DS_Store",
              "**/node_modules/**",
              "**/.meteor/**",
              "**/.next/**",
            },
          },
        },
      },
    },
  },
}
