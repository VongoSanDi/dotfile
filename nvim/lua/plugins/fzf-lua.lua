vim.pack.add({
	"https://github.com/ibhagwan/fzf-lua"
})

local fzf = require("fzf-lua")

fzf.setup({
  "fzf-native",
	keymap = {
    builtin = {
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
    }
  }
})
