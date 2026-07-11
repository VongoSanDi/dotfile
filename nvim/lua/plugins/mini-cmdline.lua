vim.pack.add({ 'https://github.com/nvim-mini/mini.cmdline' })

local cmdline = require("mini.cmdline")

cmdline.setup({
  autocorrect = {
    enable = false
  }
})
