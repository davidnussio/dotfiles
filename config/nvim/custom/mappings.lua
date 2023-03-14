--@type MappingsTable
local M = {}

-- M.general = {
--   i = {
--     ["<C-K>"] = { "<ESC> ddi", "delete line"}
--   },
--   n = {
--     ["<C-K>"] = { "dd", "delete line"}
--   }
-- }

M.copilot = {
  i = {
    ["<C-J>"] = { 'copilot#Accept("<CR>")', opts = { silent = true, expr = true } },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ["<C-7>"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment",
    },
  },

  i = {
    ["<C-7>"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment",
    },
  },

  v = {
    ["<C-7>"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
  },
}

-- more keybinds!

return M
