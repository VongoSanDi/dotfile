vim.pack.add({ 'https://github.com/nvim-mini/mini.files' })

local files = require("mini.files")

files.setup({
  windows = {
      preview = true,
      width_focus = 30,
      width_preview = 30,
    }
})
