return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dap.ext.vscode").load_launchjs(nil, { cwd = vim.fn.getcwd() })
    end,
  },
}
