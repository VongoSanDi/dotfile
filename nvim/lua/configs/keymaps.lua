local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = 'rounded', source = 'if_many' },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },

	-- Can switch between these as you prefer
	virtual_text = true, -- Text shows up at the end of the line
	virtual_lines = false, -- Text shows up underneath the line, with virtual lines

	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = 'cursor',
				focus = false,
			})
		end,
	},
})

map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- ═══════════════════════════════════════════════════════════
-- WINDOW MANAGEMENT (splitting and navigation)
-- ═══════════════════════════════════════════════════════════

-- Move between windows with Ctrl+hjkl
map('n', '<C-h>', '<C-w>h', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move focus to the upper window' })

-- ═══════════════════════════════════════════════════════════
-- SMART LINE MOVEMENT (the VSCode experience)
-- ═══════════════════════════════════════════════════════════

-- Smart j/k: moves by visual lines when no count, real lines with count
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Move lines up/down (Alt+j/k like VSCode)
map('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
map('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
map('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
map('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })

-- ═══════════════════════════════════════════════════════════
-- SMART TEXT EDITING
-- ═══════════════════════════════════════════════════════════
-- Indent
map('v', '<', '<gv', { desc = 'Unindent and keep selection' })
map('v', '>', '>gv', { desc = 'Indent and keep selection' })

-- Better paste (doesn't replace clipboard with deleted text)
map('v', 'p', '"_dP')
map('x', 'p', [["_dP]], { desc = 'Paste over selection without losing yanked text' })

-- ═══════════════════════════════════════════════════════════
-- SEARCH & NAVIGATION (ergonomic improvements)
-- ═══════════════════════════════════════════════════════════

-- Better line start/end (more comfortable than $ and ^)
map('n', '<A-h>', '^', { desc = 'Go to start of line', silent = true })
map('n', '<A-l>', '$', { desc = 'Go to end of line', silent = true })

-- Commenting (add comment above/below current line)
map('n', 'gcb', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
map('n', 'gca', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

-- ═══════════════════════════════════════════════════════════
-- BUFFER NAVIGATION (think browser tabs)
-- ═══════════════════════════════════════════════════════════

-- Tab/Shift-Tab: Like browser tabs, feels natural
map('n', '<S-h>', ':bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<S-l>', ':bnext<CR>', { desc = 'Next buffer' })

-- Quick switch to last edited file (super useful!)
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- ═══════════════════════════════════════════════════════════
-- MINI PICK
-- ═══════════════════════════════════════════════════════════
-- TODO: Add files pick from cwd dir
-- TODO: Add files pick for EXACT word under cursor
map('n', '<leader>sb', function()
	require('mini.pick').builtin.buffers()
end, { desc = '[S]earch [Buffers' })
map('n', '<leader>sc', function()
	require('mini.extra').pickers.commands()
end, { desc = '[S]earch [C]commands' })
map('n', '<leader>sd', function()
	require('mini.extra').pickers.diagnostic()
end, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sf', function()
	require('mini.pick').builtin.files()
end, { desc = '[S]earch [F]iles' })
map('n', '<leader>sg', function()
	require('mini.pick').builtin.grep({ pattern = vim.fn.expand('<cword>') })
end, { desc = '[S]earch by [G]rep' })
map('n', '<leader>sh', function()
	require('mini.pick').builtin.help()
end, { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', function()
	require('mini.extra').pickers.keymaps()
end, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sl', function()
	require('mini.extra').pickers.list({ scope = 'location' })
end, { desc = '[S]earch [L]ocation' })
map('n', '<leader>sm', function()
	require('mini.extra').pickers.manpages()
end, { desc = '[S]earch [M]anpages' })
map('n', '<leader>sq', function()
	require('mini.extra').pickers.list({ scope = 'quickfix' })
end, { desc = '[S]earch [Q]uickfix' })
map('n', '<leader>s.', function()
	require('mini.extra').pickers.oldfiles()
end, { desc = "[S]earch Recent Files ('.' for repeat)" })

-- Override default behavior and theme when searching
-- TODO: Why does this command search in all files and not onl
map('n', '<leader>/', function()
	require('mini.extra').pickers.buf_lines({ scope = 'current' })
end, { desc = '[/] Fuzzily search in buffer lines' })

-- Find references for the word under your cursor.
map('n', 'grr', function()
	require('mini.extra').pickers.lsp({ scope = 'references' })
end, { desc = '[G]oto [R]eferences' })

-- Jump to the implementation of the word under your cursor.
-- Useful when your language has ways of declaring types without an actual implementation.
map('n', 'gri', function()
	require('mini.extra').pickers.lsp({ scope = 'implementation' })
end, { desc = '[G]oto [I]implentation' })

-- Jump to the definition of the word under your cursor.
-- This is where a variable was first declared, or where a function is defined, etc.
-- To jump back, press <C-t>.
map('n', 'grd', function()
	require('mini.extra').pickers.lsp({ scope = 'definition' })
end, { desc = '[G]oto [D]efinition' })

-- Fuzzy find all the symbols in your current document.
-- Symbols are things like variables, functions, types, etc.
map('n', 'grs', function()
	require('mini.extra').pickers.lsp({ scope = 'document_symbol' })
end, { desc = 'Open Document Symbols' })

-- Fuzzy find all the symbols in your current workspace.
-- Similar to document symbols, except searches over your entire project.
map('n', 'grS', function()
	require('mini.extra').pickers.lsp({ scope = 'workspace_symbol_live' })
end, { desc = 'Open Workspace Symbols' })

-- Jump to the type of the word under your cursor.
-- Useful when you're not sure what type a variable is and you want to see
-- the definition of its *type*, not where it was *defined*.
map('n', 'grt', function()
	require('mini.extra').pickers.lsp({ scope = 'type_definition' })
end, { desc = '[G]oto [T]ype Definition' })

-- ═══════════════════════════════════════════════════════════
-- MINI BUFREMOVE
-- ═══════════════════════════════════════════════════════════

-- Save the window layout when closing a buffer.
map('n', '<leader>bd', function()
	require('mini.bufremove').delete(0, false)
end, { desc = 'Delete current buffer' })

-- ═══════════════════════════════════════════════════════════
-- CONFORM
-- ═══════════════════════════════════════════════════════════
map({ 'n', 'v' }, '<leader>f', function()
	require('conform').format({ async = true })
end, { desc = '[F]ormat buffer' })
