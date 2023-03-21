--@type MappingsTable
local M = {}


M.general = {
  i = {
    ["<C-k>"] = { "<ESC>ddi", "delete line" },
  },
  n = {
    ["<leader>k"] = { "dd", "delete line"}
  },
  v = {
    ["<leader>k"] = { "<S-V> dd", "delete line"}
  },
}

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
  n = {
    ["<Space>qa"] = { '<cmd> qall <CR>', "Quit all"}
  }
}

-- more keybinds!

return M
