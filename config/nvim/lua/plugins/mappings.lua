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
        n = {
          -- Neovim's built-in `gri` mapping calls this unconditionally.
          gri = {
            function()
              local bufnr = vim.api.nvim_get_current_buf()
              for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
                if client:supports_method("textDocument/implementation", bufnr) then
                  vim.lsp.buf.implementation()
                  return
                end
              end
            end,
            desc = "Show implementations of current symbol",
          },
        },
      },
    },
  },
}
