vim.pack.add { 'https://github.com/stevearc/conform.nvim' }
require('conform').setup {
  log_level = vim.log.levels.DEBUG,
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Don't format when minifiles is open, since that triggers the "confirm without
    -- synchronization" message.
    if vim.g.minifiles_active then return nil end
    -- Stop if we disabled auto-formatting.
    if not vim.g.autoformat then return nil end
    -- You can specify filetypes to autoformat on save here:
    local enabled_filetypes = {
      -- lua = true,
      -- python = true,
    }
    if enabled_filetypes[vim.bo[bufnr].filetype] then
      return { timeout_ms = 500 }
    else
      return nil
    end
  end,
  default_format_opts = {
    lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
  },
  -- You can also specify external formatters in here.
  formatters_by_ft = {
    lua = { 'stylua' },
    sh = { 'shfmt' },
    rust = { 'rustfmt' },
    -- Conform can also run multiple formatters sequentially
    -- python = { "isort", "black" },
    --
    -- You can use 'stop_after_first' to run the first available formatter from the list
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
    --
    -- For filetypes without a formatter:
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
  },
}

-- Use conform for gq.
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
