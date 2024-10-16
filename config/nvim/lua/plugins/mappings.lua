return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {},
        t = {
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
          ["<esc>"] = "<C-\\><C-n>",
        },
        i = {},
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {},
      },
    },
  },
}
