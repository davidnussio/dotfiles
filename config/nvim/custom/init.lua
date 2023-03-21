  local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
--
--
vim.opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undodir"
vim.opt.undofile = true

vim.opt.scrolloff = 8


-- Copilot
vim.g.copilot_filetypes = {
  ['*'] = false,
  ['markdown'] = true,
  ['javascript'] = true,
  ['typescript'] = true,
  ['vue'] = true,
  ['lua'] = true,
  ['html'] = true,
  ['yaml'] = true,
  ['python'] = true,
  ['fish'] = true,
}
