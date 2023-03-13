---@type MappingsTable
local M = {}

M.copilot = {
  i = {
    ["<C-J>"] = { 'copilot#Accept("<CR>")', opts = { silent = true, expr = true } },
    ["<C-H>"] = { 'copilot#Previous()', opts = { silent = true, expr = true } },
    ["<C-K>"] = { 'copilot#Next()', opts = { silent = true, expr = true } },
  },
}

-- more keybinds!

return M
