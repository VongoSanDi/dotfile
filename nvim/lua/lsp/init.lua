local M = {}

function M.setup()
  local servers = require('lsp.servers')

  require('lsp.attach').setup()

  require('mason').setup({})
  require('mason-lspconfig').setup({})

  local ensure_installed = vim.tbl_keys(servers)
  vim.list_extend(ensure_installed, {
    -- Add more here if necessary
  })

  require('mason-tool-installer').setup({
    ensure_installed = ensure_installed,
  })

  for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end

return M
