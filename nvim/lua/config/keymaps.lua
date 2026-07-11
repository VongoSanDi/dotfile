local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })

-- Move between windows with Ctrl+hjkl
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Smart j/k: moves by visual lines when no count, real lines with count
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move lines up/down (Alt+j/k like VSCode)
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files"})
map("n", "<leader><leader>", "<cmd>FzfLua files<cr>", { desc = "Find files"})
map("n", "<leader>fh", "<cmd>FzfLua history<cr>", { desc = "Find files history"})
map("n", "<leader>f/", "<cmd>FzfLua live_grep<cr>", { desc = "Find live grep"})
map("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Find keymaps"})
map("n", "<leader>fm", "<cmd>FzfLua manpages<cr>", { desc = "Find manpages"})
map("n", "<leader>ft", "<cmd>FzfLua helptags<cr>", { desc = "Find help"})

map("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini files explorer" })
map("n", "<leader>-", function()
  MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
  MiniFiles.reveal_cwd()
  end,
 {desc = "Toggle mini files explorer into currently opened file"}
)


--TODO: add picker for diagnostics
