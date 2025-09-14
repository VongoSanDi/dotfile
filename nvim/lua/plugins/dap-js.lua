return {
  {
    "mfussenegger/nvim-dap",
    opts = {
      setup = {
        ["pwa-node"] = function(_, _)
          local dap = require("dap")

          dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug-adapter",
              args = { "${port}" },
            },
          }

          dap.configurations.typescript = {
            {
              name = "Debug NestJS (ESM)",
              type = "pwa-node",
              request = "launch",
              program = "${workspaceFolder}/src/main.ts",
              cwd = "${workspaceFolder}",
              runtimeExecutable = "node",
              runtimeArgs = {
                "--loader",
                "ts-node/esm",
              },
              env = {
                TS_NODE_PROJECT = "${workspaceFolder}/tsconfig.json",
              },
              sourceMaps = true,
              skipFiles = { "<node_internals>/**" },
              resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
              },
              console = "integratedTerminal",
            },
          }

          dap.configurations.javascript = dap.configurations.typescript
        end,
      },
    },
  },
}
