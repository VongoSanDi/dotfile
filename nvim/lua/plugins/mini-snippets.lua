vim.pack.add({
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/nvim-mini/mini.snippets'
})

local snippets = require("mini.snippets")
snippets.setup({
  snippets = {
    snippets.gen_loader.from_lang() --loads friendly-snippets automatically
  }
})
snippets.start_lsp_server({match = false })
