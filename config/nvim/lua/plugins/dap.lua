return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      dap.adapters.java = {
        type = "server",
        host = "127.0.0.1",
        port = 5005,
        executable = {
          command = "java-debug",
          args = {},
        },
      }

      require("dap.ext.vscode").load_launchjs(nil, { cwd = vim.fn.getcwd() })
    end,
  },
}
