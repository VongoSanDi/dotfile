vim.pack.add({'https://github.com/nvim-mini/mini.completion'})

local completion = require("mini.completion")

completion.setup({
  lsp_completion = {
    process_items = function(items, base)
      return completion.default_process_items(items, base, {
        filtersort = "fuzzy"
      })
    end
  }
})
