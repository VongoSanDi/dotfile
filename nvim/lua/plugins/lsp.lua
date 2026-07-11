local gh = function(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add({
  gh('neovim/nvim-lspconfig'),
  gh('mason-org/mason.nvim'),
  gh('mason-org/mason-lspconfig.nvim'),
  gh('WhoIsSethDaniel/mason-tool-installer.nvim'),
})

require('lsp').setup()
